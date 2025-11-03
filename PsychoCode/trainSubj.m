function [win, winRect, results] = trainSubj(trainPhase, win, winRect, subjID)

    % ----------------
    % INITIAL SETUP
    % ----------------
    if trainPhase
        [animalImages, nonAnimalImages] = loadTrainingStimuli();
    else
        [animalImages, nonAnimalImages] = loadTestStimuli();
    end
    
    global nTrainingBlocks nTrialsPerBlock fixDuration ...
       stimDuration greyDuration maskDuration;

    try

        % Get center coordinates
        [xCenter, yCenter] = RectCenter(winRect);

        % Text style
        Screen('TextSize', win, 30);
        HideCursor;

        % Preallocate a data structure for responses (optional)
        results = struct('Block', cell(1, nTrainingBlocks * nTrialsPerBlock), ...
                         'Trial', cell(1, nTrainingBlocks * nTrialsPerBlock), ...
                         'ImageName', cell(1, nTrainingBlocks * nTrialsPerBlock), ...
                         'Response', cell(1, nTrainingBlocks * nTrialsPerBlock), ...
                         'RT', cell(1, nTrainingBlocks * nTrialsPerBlock), ...
                         'Correct', cell(1, nTrainingBlocks * nTrialsPerBlock), ...
                         'ConfidenceLevel', cell(1, nTrainingBlocks * nTrialsPerBlock));

        trialCounter = 1; % to index into results

        % Determine if subject is odd or even
        isOdd = mod(subjID, 2) == 1;

        % ----------------
        % BLOCK LOOP
        % ----------------
        [blockStimuli, blockStimLabels] = getBlockStimuli(animalImages, nonAnimalImages, nTrialsPerBlock);

        for blockNum = 1:nTrainingBlocks

            % Apply noise or rotation for the last two blocks based on subject ID
            if trainPhase == false
                if blockNum > nTrainingBlocks - 2
                    if isOdd
                        % Add noise to images for the last two blocks (for odd subjects)
                        blockStimuli{blockNum} = applyNoiseToImages(blockStimuli{blockNum});
                    else
                        % Rotate images for the last two blocks (for even subjects)
                        blockStimuli{blockNum} = applyRotationToImages(blockStimuli{blockNum});
                    end
                end
            end

            % ---------
            % TRIAL LOOP
            % ---------
            imagesAndLabels = blockStimuli{blockNum};
            images = imagesAndLabels{1};
            imgNames = imagesAndLabels{2};
            Labels = blockStimLabels{blockNum};

            for trial = 1:nTrialsPerBlock
%             for trial = 1:2

                % Retrieve the image data for the current trial
                img = images{1, trial};       % Row 1 contains image data
                imgName = imgNames{1, trial};

                correctLabel = Labels(trial);
                
                % -- Step 1: Fixation Cross --
                showFixationCross(win, xCenter, yCenter, fixDuration);
            
                % -- Step 2: Stimulus --
                showStimulusStep(win, img, stimDuration);
            
                % -- Step 3: Gray Screen / ISI --
                showGrayStep(win, greyDuration);
            
                % -- Step 4: Mask --
                showMaskStep(win, img, maskDuration);
            
                % -- Step 5: Decision Screen --
                [response, rt, confidence] = decisionScreenStep(win, xCenter, yCenter);

                % Evaluate correctness
                isCorrect = isResponseTrue(response, correctLabel);

                % -----------------------------
                % STORE DATA
                % -----------------------------
                results(trialCounter).Block = blockNum;
                results(trialCounter).Trial = trial;
                results(trialCounter).ImageName = imgName;       % Image name or path
                results(trialCounter).Response = response;       % Subject response
                results(trialCounter).RT = rt;                   % Response time
                results(trialCounter).Correct = isCorrect;       % Correctness
                results(trialCounter).ConfidenceLevel = confidence; % Confidence level

                trialCounter = trialCounter + 1;

            end

            % ----------------------------------
            % END OF BLOCK: TAKE A SHORT BREAK
            % ----------------------------------
            breakText = sprintf('End of Block %d. Please rest.\nPress any key to continue...', blockNum);
            DrawFormattedText(win, breakText, 'center', 'center', [0 0 0]);
            Screen('Flip', win);
            KbWait([], 2);

        end

    catch ME
        % If there is an error, we close the screen
        sca;
        rethrow(ME);
    end
end

% =========================
% AUXILIARY FUNCTIONS
% =========================

% Add noise to images (just a simple example: random pixel alterations)
function noisyImages = applyNoiseToImages(blockStimuli)
    noisyImages = blockStimuli;
    for i = 1:length(blockStimuli{1})
        img = double(blockStimuli{1}{i});
        noisyImg = img + randn(size(img)) * 25; % Adding random noise
        noisyImages{1}{i} = uint8(noisyImg);
    end
end

% Rotate images by a random angle
function rotatedImages = applyRotationToImages(blockStimuli)
    rotatedImages = blockStimuli;
    for i = 1:length(blockStimuli{1})
        img = blockStimuli{1}{i};
        angle = randi([0, 360]); % Random rotation angle
        rotatedImg = imrotate(img, angle, 'bilinear', 'loose'); % Rotate with 'loose' option
        
        % Create a white canvas of the same size as the rotated image
        whiteBackground = ones(size(rotatedImg)) * 255; % Assuming the image is grayscale. Use [255, 255, 255] for RGB images.
        
        % Find the non-zero (non-black) region of the rotated image
        nonZeroMask = rotatedImg > 0;
        
        % Overlay the rotated image onto the white canvas
        whiteBackground(nonZeroMask) = rotatedImg(nonZeroMask);

        whiteBackground = uint8(whiteBackground);
        % Store the result
        rotatedImages{1}{i} = whiteBackground;
    end
end
function isCorrect = isResponseTrue(response, correctLabel)
    % Check if the response matches the correct label
    if strcmp(response, 'Animal') && correctLabel == 1
        isCorrect = 1;  % Correct
    elseif strcmp(response, 'Non-Animal') && correctLabel == 0
        isCorrect = 1;  % Correct
    else
        isCorrect = 0;  % Incorrect
    end
end

function [response, rt, confidence] = decisionScreenStep(win, xCenter, yCenter)
    % DECISIONSCREENSTEP Displays a decision screen with two confidence bars and records the response.
    %
    %   [response, rt, confidence] = DECISIONSCREENSTEP(win, xCenter, yCenter) displays a screen with two bars
    %   (one for "Animal" and one for "Non-Animal") and allows the subject to adjust confidence
    %   levels and make a choice.
    %
    %   Inputs:
    %       win - Psychtoolbox window pointer.
    %       xCenter, yCenter - Coordinates for the center of the screen.
    %
    %   Outputs:
    %       response - "Animal" or "Non-Animal" based on the subject's choice.
    %       rt - Reaction time for the decision.
    %       confidence - Confidence level of the chosen response.

    % Define colors
    green = [0, 255, 0];
    red = [255, 0, 0];
    white = WhiteIndex(win);
    gray = white/2;

    % Set initial confidence levels
    leftConfidence = 0.5;  % Confidence for "Non-Animal"
    rightConfidence = 0.5; % Confidence for "Animal"

    % Define bar dimensions
    barWidth = 50;
    barMaxHeight = 300;
    barSpacing = 200;

    % Coordinates for left and right bars
    leftBarX = xCenter - barSpacing;
    rightBarX = xCenter + barSpacing;
    barYBottom = yCenter + 100;
    barYTop = yCenter - 200;

    % Reaction time measurement
    startTime = GetSecs;
    response = '';
    rt = 0;
    confidence = 0;

    % Main loop to display the decision screen and get input
    while isempty(response)
        % Draw background
        Screen('FillRect', win, gray);

        % Draw the bars
        % Left bar (Non-Animal)
        leftGreenHeight = leftConfidence * barMaxHeight;
        leftRedHeight = barMaxHeight - leftGreenHeight;
        Screen('FillRect', win, green, [leftBarX - barWidth/2, barYBottom - leftGreenHeight, leftBarX + barWidth/2, barYBottom]);
        Screen('FillRect', win, red, [leftBarX - barWidth/2, barYBottom - barMaxHeight, leftBarX + barWidth/2, barYBottom - leftGreenHeight]);

        % Right bar (Animal)
        rightGreenHeight = rightConfidence * barMaxHeight;
        rightRedHeight = barMaxHeight - rightGreenHeight;
        Screen('FillRect', win, green, [rightBarX - barWidth/2, barYBottom - rightGreenHeight, rightBarX + barWidth/2, barYBottom]);
        Screen('FillRect', win, red, [rightBarX - barWidth/2, barYBottom - barMaxHeight, rightBarX + barWidth/2, barYBottom - rightGreenHeight]);

        % Add labels above the bars
        DrawFormattedText(win, 'Non-Animal', leftBarX - 60, barYTop - 50, white);
        DrawFormattedText(win, 'Animal', rightBarX - 40, barYTop - 50, white);

        % Draw fixation cross
        DrawFormattedText(win, '+', 'center', 'center', white);

        % Flip the screen
        Screen('Flip', win);

        % Check for key presses
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(KbName('UpArrow'))
                % Increase confidence for both bars
                leftConfidence = min(leftConfidence + 0.05, 1);
                rightConfidence = min(rightConfidence + 0.05, 1);
            elseif keyCode(KbName('DownArrow'))
                % Decrease confidence for both bars
                leftConfidence = max(leftConfidence - 0.05, 0);
                rightConfidence = max(rightConfidence - 0.05, 0);
            elseif keyCode(KbName('LeftArrow'))
                % Select "Non-Animal"
                response = 'Non-Animal';
                rt = GetSecs - startTime;
                confidence = leftConfidence;
            elseif keyCode(KbName('RightArrow'))
                % Select "Animal"
                response = 'Animal';
                rt = GetSecs - startTime;
                confidence = rightConfidence;
            end
        end

        % Small delay to prevent excessive keypresses
        WaitSecs(0.1);
    end
end

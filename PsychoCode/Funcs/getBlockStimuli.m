function [blockStimuli, blockStimLabels] = getBlockStimuli(animalImages, nonAnimalImages, nTrialsPerBlock)
%GETBLOCKSTIMULI Distributes stimuli into blocks for experimental trials.
%
%   [blockStimuli, blockStimLabels] = GETBLOCKSTIMULI(animalImages, nonAnimalImages, nTrialsPerBlock)
%   combines animal and non-animal images, shuffles them, and distributes them into 5 blocks.
%
%   Inputs:
%       animalImages     - Structure containing animal images and filenames.
%                          Structure fields correspond to categories ('F', 'H', 'M', 'N').
%                          Each field is a 2-row cell array:
%                              Row 1: Image data.
%                              Row 2: Image filenames.
%       nonAnimalImages  - Structure containing non-animal images and filenames.
%                          Structure fields correspond to categories ('F', 'H', 'M', 'N').
%                          Each field is a 2-row cell array:
%                              Row 1: Image data.
%                              Row 2: Image filenames.
%       nTrialsPerBlock  - Number of trials (images) per block. For 5 blocks and 120 total images,
%                          nTrialsPerBlock should be 24.
%
%   Outputs:
%       blockStimuli     - 1x5 cell array. Each cell contains a 2-row cell array:
%                              Row 1: Image data.
%                              Row 2: Corresponding image filenames.
%       blockStimLabels  - 1x5 cell array. Each cell contains a numeric array of labels:
%                              1 for animal images.
%                              0 for non-animal images.
%
%   Example:
%       [animalImages, nonAnimalImages] = loadTrainingStimuli();
%       nTrialsPerBlock = 24;
%       [blockStimuli, blockStimLabels] = getBlockStimuli(animalImages, nonAnimalImages, nTrialsPerBlock);
%
%       % To access the first block:
%       firstBlockImages = blockStimuli{1}(1, :);       % Row 1: Images
%       firstBlockFilenames = blockStimuli{1}(2, :);    % Row 2: Filenames
%       firstBlockLabels = blockStimLabels{1};         % Labels
%
%       % Display the first 'F' animal image
%       imshow(firstBlockImages{1});
%       title(['Filename: ', firstBlockFilenames{1}, ', Label: ', num2str(firstBlockLabels(1))]);

    % Input Validation
        if nargin ~= 3
        error('Function requires exactly three inputs: animalImages, nonAnimalImages, nTrialsPerBlock.');
    end

    % Define the number of blocks
    totalBlocks = 5;

    % Calculate total number of images needed
    totalImagesNeeded = totalBlocks * nTrialsPerBlock;

    % Collect All Animal Images and Filenames
    [allAnimalImages, allAnimalFilenames] = collectImagesAndFilenames(animalImages);
    numAnimal = length(allAnimalImages);

    % Collect All Non-Animal Images and Filenames
    [allNonAnimalImages, allNonAnimalFilenames] = collectImagesAndFilenames(nonAnimalImages);
    numNonAnimal = length(allNonAnimalImages);

    % Combine Animal and Non-Animal Images
    combinedImages = [allAnimalImages, allNonAnimalImages];
    combinedFilenames = [allAnimalFilenames, allNonAnimalFilenames];
    combinedLabels = [ones(1, numAnimal), zeros(1, numNonAnimal)]; % 1: Animal, 0: Non-Animal

    % Check if Enough Images are Available
    totalAvailable = length(combinedImages);
    if totalAvailable < totalImagesNeeded
        error('Not enough images to fulfill the request. Required: %d, Available: %d.', totalImagesNeeded, totalAvailable);
    end

    % Shuffle the Combined Dataset
    rng('shuffle'); % Seed the random number generator based on current time
    shuffledIndices = randperm(totalAvailable);
    shuffledImages = combinedImages(shuffledIndices);
    shuffledFilenames = combinedFilenames(shuffledIndices);
    shuffledLabels = combinedLabels(shuffledIndices);

    % Select the Required Number of Images
    selectedImages = shuffledImages(1:totalImagesNeeded);
    selectedFilenames = shuffledFilenames(1:totalImagesNeeded);
    selectedLabels = shuffledLabels(1:totalImagesNeeded);

    % Divide into Blocks
    blockStimuli = cell(1, totalBlocks);
    blockStimLabels = cell(1, totalBlocks);

    for blk = 1:totalBlocks
        startIdx = (blk-1)*nTrialsPerBlock + 1;
        endIdx = blk * nTrialsPerBlock;
        
        blockStimuli{blk} = {selectedImages(startIdx:endIdx); selectedFilenames(startIdx:endIdx)};
        blockStimLabels{blk} = selectedLabels(startIdx:endIdx);
    end

    % Display a Summary
    fprintf('Stimuli have been distributed into %d blocks with %d trials each (Total: %d images).\n', ...
        totalBlocks, nTrialsPerBlock, totalImagesNeeded);

    for blk = 1:totalBlocks
        numAnimals = sum(blockStimLabels{blk} == 1);
        numNonAnimals = sum(blockStimLabels{blk} == 0);
        fprintf('  Block %d: %d Animal, %d Non-Animal images\n', blk, numAnimals, numNonAnimals);
    end

end

% Helper Function to Collect Images and Filenames
function [images, filenames] = collectImagesAndFilenames(imageStruct)
%COLLECTIMAGESANDFILENAMES Extracts images and filenames from the given structure.
%
%   [images, filenames] = COLLECTIMAGESANDFILENAMES(imageStruct)
%   iterates through each category in the structure and collects all images
%   and their corresponding filenames.
%
%   Inputs:
%       imageStruct - Structure with fields representing categories ('F', 'H', 'M', 'N').
%                     Each field is a 2-row cell array:
%                         Row 1: Image data.
%                         Row 2: Image filenames.
%
%   Outputs:
%       images      - 1xN cell array containing image data.
%       filenames   - 1xN cell array containing image filenames.

    categories = fieldnames(imageStruct);
    images = {};
    filenames = {};

    for i = 1:length(categories)
        cat = categories{i};
        catData = imageStruct.(cat);
        
        numImages = size(catData, 2);
        images = [images, catData(1, 1:numImages)];          %#ok<AGROW>
        filenames = [filenames, catData(2, 1:numImages)];    %#ok<AGROW>
    end
end

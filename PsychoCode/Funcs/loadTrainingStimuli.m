function [animalImages, nonAnimalImages] = loadTrainingStimuli()
%LOADTRAININGSTIMULI Loads and groups animal and non-animal training images.
%
%   [animalImages, nonAnimalImages] = LOADTRAININGSTIMULI() 
%   loads all images from the Dataset/Train/Train_Animals and 
%   Dataset/Train/Train_Non-Animals directories. The images are grouped 
%   based on their prefixes ('F', 'H', 'M', 'N') and stored in 
%   structures animalImages and nonAnimalImages respectively.
%
%   Each category within the structures is a 2-row cell array where:
%       Row 1: Image data
%       Row 2: Corresponding image filenames

    % Define the base folder path
    baseFolder = fullfile('Dataset', 'Train');

    % Define the categories based on prefixes
    categories = {'F', 'H', 'M', 'N'};

    % Initialize the animalImages structure with empty 2-row cell arrays
    animalImages = struct();
    for i = 1:length(categories)
        cat = categories{i};
        animalImages.(cat) = cell(2, 0); % Initialize with 2 rows and 0 columns
    end

    % Initialize the nonAnimalImages structure with empty 2-row cell arrays
    nonAnimalImages = struct();
    for i = 1:length(categories)
        cat = categories{i};
        nonAnimalImages.(cat) = cell(2, 0); % Initialize with 2 rows and 0 columns
    end

    % Load Animal Images
    % Define the path to the Train_Animals folder
    animalFolder = fullfile(baseFolder, 'Train_Animals');

    % Loop through each category and load corresponding images
    for i = 1:length(categories)
        cat = categories{i};
        % Create a pattern to match filenames like 'F_1_Train_Animal.jpg'
        pattern = sprintf('%s_*_Train_Animal.jpg', cat);
        % Get list of matching files
        files = dir(fullfile(animalFolder, pattern));
        
        % Loop through each file and read the image
        for j = 1:length(files)
            imgPath = fullfile(animalFolder, files(j).name);
            try
                img = imread(imgPath);
                % Append the image and filename to the respective category
                animalImages.(cat){1, end+1} = img;          % Row 1: Image
                animalImages.(cat){2, end} = files(j).name;  % Row 2: Filename
            catch ME
                warning('Failed to read image %s: %s', imgPath, ME.message);
            end
        end
    end

    % Load Non-Animal Images
    % Define the path to the Train_Non-Animals folder
    nonAnimalFolder = fullfile(baseFolder, 'Train_Non-Animals');

    % Loop through each category and load corresponding images
    for i = 1:length(categories)
        cat = categories{i};
        % Create a pattern to match filenames like 'F_1_Non-Animals_Train.jpg'
        % Adjust the pattern based on actual naming convention
        pattern = sprintf('%s_*_Train_Non-Animal.jpg', cat);
        files = dir(fullfile(nonAnimalFolder, pattern));
        
        % Loop through each file and read the image
        for j = 1:length(files)
            imgPath = fullfile(nonAnimalFolder, files(j).name);
            try
                img = imread(imgPath);
                % Append the image and filename to the respective category
                nonAnimalImages.(cat){1, end+1} = img;          % Row 1: Image
                nonAnimalImages.(cat){2, end} = files(j).name;  % Row 2: Filename
            catch ME
                warning('Failed to read image %s: %s', imgPath, ME.message);
            end
        end
    end

    % Display a summary of loaded images
    fprintf('Loaded Animal Images:\n');
    for i = 1:length(categories)
        cat = categories{i};
        count = size(animalImages.(cat), 2);
        fprintf('  %s: %d images\n', cat, count);
    end

    fprintf('Loaded Non-Animal Images:\n');
    for i = 1:length(categories)
        cat = categories{i};
        count = size(nonAnimalImages.(cat), 2);
        fprintf('  %s: %d images\n', cat, count);
    end
end

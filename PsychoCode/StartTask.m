clc; clear;
addpath('./Funcs');

% Get subject info
SubjectInfo = getSubjInfo();

% Define the folder name using SubjectInfo.ID
folderName = SubjectInfo.ID;

% Check if the folder exists, if not, create it
if ~exist(folderName, 'dir')
    mkdir(folderName);
end

% Save the SubjectInfo struct as a .mat file in the folder
save(fullfile(folderName, 'SubjectInfo.mat'), 'SubjectInfo');

% (Optional) Save as a .txt or .csv for easier inspection
% Convert struct to a table (if it is scalar)
if isscalar(SubjectInfo)
    SubjectInfoTable = struct2table(SubjectInfo);
    writetable(SubjectInfoTable, fullfile(folderName, 'SubjectInfo.csv'));
end

% (Optional) Display a message confirming the save
disp(['SubjectInfo saved in folder: ', folderName]);



% ----------------
% PARAMETERS
% ----------------
global nTrainingBlocks nTrialsPerBlock fixDuration ...
       stimDuration greyDuration maskDuration;

nTrainingBlocks  = 5;      % Number of training blocks
nTrialsPerBlock  = 120;    % Number of trials per block
fixDuration      = 0.5;    % Fixation cross duration (in seconds)
stimDuration     = 0.02;   % Stimulus duration (in seconds)
greyDuration     = 0.03;   % Gray screen / ISI (in seconds)
maskDuration     = 0.08;   % Mask duration (in seconds)

% fixDuration      = 1;    % Fixation cross duration (in seconds)
% stimDuration     = 2;   % Stimulus duration (in seconds)
% greyDuration     = 2;   % Gray screen / ISI (in seconds)
% maskDuration     = 1;   % Mask duration (in seconds)

% Init Screen
% PTB defaults and sync
Screen('Preference', 'SkipSyncTests', 1);  % For testing purposes only; remove in real experiments
PsychDefaultSetup(2);

% Open a window
screens = Screen('Screens');
screenNumber = max(screens);
[win, winRect] = PsychImaging('OpenWindow', screenNumber, [128 128 128]);
Screen('Flip', win);


subjID = folderName;

% % start training phase
% % training phase
% [win, winRect, trainResults] = trainSubj(true, win, winRect, subjID);
% 
% % Save train data as .mat file in the folder
% save(fullfile(folderName, 'trainResults.mat'), 'trainResults');
% 
% % Save as .csv file in the folder
% % Convert structure array to a table
% resultsTable = struct2table(trainResults);
% writetable(resultsTable, fullfile(folderName, 'trainResults.csv'));
% 
% disp(['Results saved in folder: ', folderName]);
% 
% % ----------------------------------
% % END OF TRAINING: TAKE A SHORT BREAK
% % ----------------------------------
% breakText = sprintf('End of Training Phase. Please rest.\nPress any key to continue...');
% DrawFormattedText(win, breakText, 'center', 'center', [0 0 0]);
% Screen('Flip', win);
% KbWait([], 2);

% testing phase
[win, winRect, testResults] = trainSubj(false, win, winRect, subjID);

% Save train data as .mat file in the folder
save(fullfile(folderName, 'testResults.mat'), 'testResults');

% Save as .csv file in the folder
% Convert structure array to a table
resultsTable = struct2table(testResults);
writetable(resultsTable, fullfile(folderName, 'testResults.csv'));

disp(['Results saved in folder: ', folderName]);

sca;
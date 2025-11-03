function showStimulusStep(win, img, stimDuration)
%SHOWSTIMULUSSTEP Displays the stimulus image for the current trial.
%
%   SHOWSTIMULUSSTEP(win, blockStimuli, trial, stimDuration) displays the
%   image corresponding to the current trial on the provided window for
%   stimDuration seconds.
%
%   Inputs:
%       win          - Psychtoolbox window pointer.
%       blockStimuli - 2-row cell array containing images and filenames.
%                       Row 1: Image data (already loaded into memory).
%                       Row 2: Image filenames or paths.
%       trial        - Current trial number.
%       stimDuration - Duration to display the stimulus (in seconds).
%
%   Example:
%       showStimulusStep(win, blockStimuli, 1, 1.0);

    white = WhiteIndex(win);      % White color based on screen

    Screen('FillRect', win, [white white white]);
    
    % Display the image
    Screen('PutImage', win, img);

    % Flip to the screen to show the stimulus
    Screen('Flip', win);

    % Wait for the stimulus duration
    WaitSecs(stimDuration);
end

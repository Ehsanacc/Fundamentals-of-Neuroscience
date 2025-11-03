function showFixationCross(win, xCenter, yCenter, fixDuration)
%SHOWFIXATIONCROSS Displays a fixation cross at the center of the screen.
%
%   SHOWFIXATIONCROSS(win, xCenter, yCenter, fixDuration) draws a white
%   fixation cross (+) at the specified center coordinates on the given
%   Psychtoolbox window and displays it for fixDuration seconds.
%
%   Inputs:
%       win         - Psychtoolbox window pointer.
%       xCenter     - X-coordinate of the screen center.
%       yCenter     - Y-coordinate of the screen center.
%       fixDuration - Duration to display the fixation cross (in seconds).
%
%   Example:
%       showFixationCross(win, xCenter, yCenter, 0.5);

    % Define Fixation Cross Parameters
    white = WhiteIndex(win);      % White color based on screen
    crossLength = 40;             % Length of each arm of the cross in pixels
    crossWidth = 5;               % Thickness of the cross lines in pixels

    % Calculate coordinates for horizontal line
    horizStart = [xCenter - crossLength, yCenter];
    horizEnd   = [xCenter + crossLength, yCenter];

    % Calculate coordinates for vertical line
    vertStart = [xCenter, yCenter - crossLength];
    vertEnd   = [xCenter, yCenter + crossLength];

%     Screen('FillRect', win, [128 128 128]);
    Screen('FillRect', win, [white/2 white/2 white/2]);

    % Draw horizontal line
    Screen('DrawLine', win, white, horizStart(1), horizStart(2), horizEnd(1), horizEnd(2), crossWidth);

    % Draw vertical line
    Screen('DrawLine', win, white, vertStart(1), vertStart(2), vertEnd(1), vertEnd(2), crossWidth);

    % Present the Fixation Cross
    Screen('Flip', win);

    % Wait for the specified duration
    WaitSecs(fixDuration);

    % (Optional) Clear the cross by flipping back to gray background
    % Screen('FillRect', win, [128 128 128]);  % Gray background
    % Screen('Flip', win);
end

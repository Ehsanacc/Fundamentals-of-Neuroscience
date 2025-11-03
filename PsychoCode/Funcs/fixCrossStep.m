function fixCrossStep(win, xCenter, yCenter)
    % Use the global variable for fixation duration
    global fixDuration

    % Draw and show the fixation cross
    DrawFixationCross(win, xCenter, yCenter);
    Screen('Flip', win);
    WaitSecs(fixDuration);
end

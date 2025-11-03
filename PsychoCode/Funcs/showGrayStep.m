function showGrayStep(win, greyDuration)
    white = WhiteIndex(win);      % White color based on screen

    % Fill the screen with a gray color [128 128 128]
    Screen('FillRect', win, [white/2 white/2 white/2]);

    % Flip (show) the gray screen
    Screen('Flip', win);

    % Keep it on screen for 'greyDuration' seconds
    WaitSecs(greyDuration);
end

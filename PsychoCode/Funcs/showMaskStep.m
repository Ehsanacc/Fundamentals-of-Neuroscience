function showMaskStep(win, img, maskDuration)
    %SHOWMASKSTEP Displays a masked (scrambled) version of the stimulus image.
    %
    %   SHOWMASKSTEP(win, img, maskDuration) creates a scrambled version
    %   of the original stimulus image and displays it on the given
    %   Psychtoolbox window for maskDuration seconds.
    %
    %   Inputs:
    %       win         - Psychtoolbox window pointer.
    %       img         - Original stimulus image data (RGB array).
    %       maskDuration - Duration to display the mask (in seconds).
    %
    %   Example:
    %       showMaskStep(win, originalImg, 0.08);
    
    % Create the masked image by scrambling the original image
    maskImg = makeMask(img);

    white = WhiteIndex(win);      % White color based on screen

    Screen('FillRect', win, [white white white]);
    
    % Convert the masked image to a Psychtoolbox texture
    textureMask = Screen('MakeTexture', win, maskImg);
    
    
    % Draw the mask texture to the window
    Screen('DrawTexture', win, textureMask, [], [], 0);
    
    % Present the mask on the screen
    Screen('Flip', win);
    
    % Keep the mask on screen for the specified duration
    WaitSecs(maskDuration);
    
    % Clear the mask texture from memory
    Screen('Close', textureMask);
end

function maskedImg = makeMask(img)
%MAKEMASK Scrambles the pixels of the original grayscale image to create a mask.
%
%   maskedImg = MAKEMASK(img) takes a grayscale image and returns a
%   scrambled version by randomly shuffling its pixels.
%
%   Inputs:
%       img - Original stimulus image data (256x256 grayscale array).
%
%   Outputs:
%       maskedImg - Scrambled (masked) image data (256x256 grayscale array).
%
%   Example:
%       maskedImg = makeMask(originalImg);

    % Validate that the input image is a 2D grayscale image
    if ndims(img) ~= 2
        error('Input image must be a 2D grayscale image.');
    end

    % Get the size of the image
    [height, width] = size(img);
    
    % Calculate the total number of pixels
    numPixels = height * width;
    
    % Generate a random permutation of pixel indices
    permutedIndices = randperm(numPixels);
    
    % Apply the permutation to scramble the pixels
    scrambledImg = img(:);               % Convert to a column vector
    scrambledImg = scrambledImg(permutedIndices);  % Shuffle pixels
    
    % Reshape the scrambled pixels back to the original image dimensions
    maskedImg = reshape(scrambledImg, height, width);
end

% Function that returns the segmented ROI of an input image.
% Input - RGB image.
% ROI - Region Of Interest (ROI) mask.

function ROI = segmentROI(input)
    % Image pre-processment that turns to gray scale, reduces noise and binarizes
    % the image it recieves as input.
    ROI_gray = rgb2gray(input);
    ROI_med = medfilt2(ROI_gray);
    ROI_bin = imbinarize(ROI_med);
    
    % This block of code uses the function imclose to join the most adjacent
    % lines together.
    % Vertical and horizontal lines are treated separately.
    SE_vertical = strel('line',50,90);
    SE_horizontal = strel('line',50,0);
    ROI_close = imclose(ROI_bin, SE_vertical);
    ROI_close = imclose(ROI_close, SE_horizontal);

    % We use the open operation to prevent eroding the width of the big lines, 
    % while eroding the thinner ones.
    SE = strel('disk', 17);
    ROI_open = imopen(ROI_close, SE);

    % Fills the big square.
    ROI_fill = imfill(ROI_open, 'holes');

    % Get the boundaries of the image.
    ROI_boundariesStruct = bwboundaries(ROI_fill);
    ROI_boundaries = ROI_boundariesStruct{1}; 
    % Get rows and columns of the previous array separately.
    x = ROI_boundaries(:, 2);
    y = ROI_boundaries(:, 1);

    % Search for the indexes of the first and last line of the square,
    % while going through the first column.
    topLineIndex = size(ROI_fill, 1);
    bottomLineIndex = 1;
    for i=1:length(y)
        if (y(i)==1)
            if (x(i)<topLineIndex)
                topLineIndex = x(i);
            elseif (x(i)>bottomLineIndex)
                bottomLineIndex = x(i);
            end
        end
    end

    % Search for the indexes of the left and right column of the square,
    % while going through the first line.
    leftColumnIndex = size(ROI_fill, 2);
    rightColumnIndex = 1;
    for i=1:length(x)
        if (x(i)==1)
            if (y(i)<leftColumnIndex)
                leftColumnIndex = y(i);
            elseif (y(i)>rightColumnIndex)
                rightColumnIndex = y(i);
            end
        end
    end
 
    % Cut the image according to the indexes in order to obtain the final
    % ROI.
    ROI = ROI_fill;
    ROI(1:leftColumnIndex,:) = 0;
    ROI(rightColumnIndex:end, :) = 0;
    ROI(:, 1:topLineIndex) = 0;
    ROI(:, bottomLineIndex:end) = 0;
end
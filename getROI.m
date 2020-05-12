% Function that returns the ROI of an input image, with the mask of
% coordinate i

function [ROI, topLine, leftColumn] = getROI(input, i)
    % Name of the directiory of the masks
    nameMaskDir = 'C:\Users\maria\Documents\GitHub\aibi-automated-cell-counting\train-images\train_ROI_images';
    maskFolderInfo = dir(nameMaskDir);
    % Get the mask of the corresponding index
    % Open respective mask and apply it
    nameMask = strcat(nameMaskDir,'\',maskFolderInfo(i).name);
    mask = im2double(imread(nameMask));
    overlay = input.*mask; 
    % Trace the exterior boundaries of the mask
    structBoundaries = bwboundaries(mask);
    % Get array of (x,y) coordinates of the boundaries
    xy = structBoundaries{1}; 
    % Get rows and columns of the array separately
    x = xy(:, 2);
    y = xy(:, 1);
    % Top line and bottom line are the minimum and maximum of the rows'
    % vector, respectivelly
    topLine = min(x);
    bottomLine = max(x);
    % Left column and right column are the minimum and maximum of the columns'
    % vector, respectivelly
    leftColumn = min(y);
    rightColumn = max(y);
    width = bottomLine - topLine + 1;
    height = rightColumn - leftColumn + 1;
    % Crop the image in order to obtain the desired ROI
    ROI = imcrop(overlay, [topLine, leftColumn, width, height]);
end
% Function that returns the ROI of an input image, with the mask of
% coordinate i.

function ROI = getROI(input, i)
    % Name of the directiory of the masks.
    nameMaskDir = 'test-images\test_ROI_images';
    maskFolderInfo = dir(nameMaskDir);
    
    % Get the mask of the corresponding index, open it and apply to the
    % image it recieves as input.
    nameMask = strcat(nameMaskDir,'\',maskFolderInfo(i).name);
    mask = im2double(imread(nameMask));
    ROI = input.*mask; 
end
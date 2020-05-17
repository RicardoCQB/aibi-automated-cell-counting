% Function that returns the ROI of an input image, with the mask of
% coordinate i

function ROI = getROI(input, i)
    % Name of the directiory of the masks
    nameMaskDir = 'train-images\train_ROI_images';
    maskFolderInfo = dir(nameMaskDir);
    
    % Get the mask of the corresponding index
    % Open respective mask and apply it
    nameMask = strcat(nameMaskDir,'\',maskFolderInfo(i).name);
    mask = im2double(imread(nameMask));
    ROI = input.*mask; 
end
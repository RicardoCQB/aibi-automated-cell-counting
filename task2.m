%% Cell segmentation and counting
% The goal is to segment the cells inside the ROI and count them.
% The obtained cells will be compared with the ground truth and evaluated
% using the number of counted cells, true positives, false positives, false
% negatives, recall, precision and F1-measure.

close all; clear all;
% Name of the directiory of the orignal images
nameOriginalDir = 'C:\Users\maria\Documents\GitHub\aibi-automated-cell-counting\train-images\train_images';
originalFolderInfo = dir(nameOriginalDir);
numImages = size(originalFolderInfo, 1);
nonImages = 0;
% Open and process the images sequentially
for i=1:numImages
    if (getfield(originalFolderInfo(i),'bytes')==0)
        nonImages = nonImages+1;
    else
        close all;
        % Open original image and get the respective ROI, displaying it
        nameImage = strcat(nameOriginalDir,'\',getfield(originalFolderInfo(i),'name'));
        input = im2double(imread(nameImage));
        input = rgb2gray(input);
        ROI = getROI(input, i);
        subplot(1,2,1)
        imshow(ROI), title("ROI " + (i-nonImages));
        pause;
    end
end
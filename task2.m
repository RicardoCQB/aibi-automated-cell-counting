%% Cell segmentation and counting
% The goal is to segment the cells inside the ROI and count them.
% The obtained cells will be compared with the ground truth and evaluated
% using the number of counted cells, true positives, false positives, false
% negatives, recall, precision and F1-measure.

close all; clear all;

% Name of the directiory of the orignal images
nameOriginalDir = 'train-images\train_images';
originalFolderInfo = dir(nameOriginalDir);
numImages = size(originalFolderInfo, 1);
nonImages = 0;

% Open and process the images sequentially
for i=1:5
    if ((originalFolderInfo(i).bytes)==0)
        nonImages = nonImages+1;
    else
        close all;
        
        % Open original image and get the respective ROI
        nameImage = strcat(nameOriginalDir,'\',originalFolderInfo(i).name);
        input = im2double(imread(nameImage));
        input = rgb2gray(input);
        [ROI, topLine, leftColumn] = getROI(input, i);
        figure, imshow(ROI), hold on;
        
        % Segment the cells in the ROI
        [centers, radii] = segmentCells(ROI);
        viscircles(centers, radii);
        numCells = size(centers, 1);
        plotGroundTruth(i, topLine, leftColumn);
        title("ROI " + (i-nonImages) + " - " + numCells + " cells");
        pause;
    end
end
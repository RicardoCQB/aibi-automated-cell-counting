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

% Set directory in which the results will be saved and the text file for
% the results
resultsDir = 'train-images\results_train_task2';

% Open and process the images sequentially
for i=1:50
    if ((originalFolderInfo(i).bytes)==0)
        nonImages = nonImages+1;
    else
        close all;
        
        % Open original image and get the respective ROI
        nameImage = strcat(nameOriginalDir,'\',originalFolderInfo(i).name);
        input = im2double(imread(nameImage));
        input = rgb2gray(input);
        ROI = getROI(input, i);
        figure, subplot(1,2,1)
        imshow(ROI), title("ROI " + (i-nonImages)), hold on;
        
        % Segment the cells and plot both the obtained results and the 
        % ground truth
        results_locations = segmentAndPlotCells(ROI);
        positive_locations = plotGroundTruth(i);
        
        % Save the information concerning the rectangle surrounding a cell
        % to .mat file
        fullFileName = strcat(resultsDir,'\',originalFolderInfo(i).name,'_result_locations.mat');
        fullFileName = erase(fullFileName,'.tiff');
        save(fullFileName, 'results_locations');
       
        % Evaluate the obtained segmenation
        [autoNumCells, manualNumCells, TP, FP, FN, R, P, F1] = evaluateSegmentation(results_locations, positive_locations);
        subplot(1,2,2)
        text(0.3, 1, "Automatic Counting: " + autoNumCells + " cells"); hold on;
        text(0.3, 0.9, "Manual Counting: " + manualNumCells + " cells"); hold on;
        text(0.3, 0.8, "True Positives: " + TP); hold on;
        text(0.3, 0.7, "False Positives: " + FP); hold on;
        text(0.3, 0.6, "False Negatives: " + FN); hold on;
        text(0.3, 0.5, "Recall: " + R); hold on;
        text(0.3, 0.4, "Precision: " + P); hold on;
        text(0.3, 0.3, "F-measure: " + F1); hold on;
        axis off;
        
        pause;
    end
end
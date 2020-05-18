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
resultsDir = 'train-images\results_task2';

% Open and process the images sequentially
for i=1:10
    if ((originalFolderInfo(i).bytes)==0)
        nonImages = nonImages+1;
    else
        close all;
        
        % Open original image and get the respective ROI
        nameImage = strcat(nameOriginalDir,'\',originalFolderInfo(i).name);
        input = im2double(imread(nameImage));
        input = rgb2gray(input);
        ROI = getROI(input, i);
        %figure, imshow(ROI), hold on;
        
        [bottom, right] = excludeBorders(ROI);
        
        % Segment the cells in the ROI
        %[centers, radii] = segmentCells(ROI);
        
        % Save the information concerning the rectangle surrounding a cell
        % to .mat file
        %for n=1:size(centers, 1)
        %    results_locations(n, 1) = centers(n, 1) - radii(n);
        %    results_locations(n, 2) = centers(n, 2) - radii(n);
        %    results_locations(n, 3) = radii(n)*2;
        %    results_locations(n, 4) = radii(n)*2;
        %end
        %fullFileName = strcat(resultsDir,'\',originalFolderInfo(i).name,'_result_locations.mat');
        %fullFileName = erase(fullFileName,'.tiff');
        %save(fullFileName, 'results_locations');
        
        % Plot both the obtained results and the ground truth
        %positive_locations = plotGroundTruth(i);
        %for m=1:size(results_locations, 1)
        %    rectangle('Position', [results_locations(m,1) results_locations(m,2) results_locations(m,3) results_locations(m,4)], 'EdgeColor', 'b', 'LineWidth', 1)
        %end
        %title("ROI " + (i-nonImages));
        
        % Evaluate the obtained segmenation
        % [numCells, TP, FP, FN, R, P, F1] = evaluateSegmentation(results_locations, positive_locations);
        
        pause;
    end
end
%% Cell segmentation and counting
% The goal is to segment the cells inside the ROI and count them.
% The obtained cells will be compared with the ground truth and evaluated
% using the number of counted cells, true positives, false positives, false
% negatives, recall, precision and F1-measure.
tic
% Name of the directiory of the orignal images.
nameOriginalDir = 'train-images\train_images';
originalFolderInfo = dir(nameOriginalDir);
numImages = size(originalFolderInfo, 1);
nonImages = 0; % PARA ELIMINAR

% Set directory in which the results will be saved and the text file for
% the results.
resultsDir = 'results\results_train_task2';
textFile = strcat(resultsDir, '\overall_results.txt');
fid = fopen(textFile, 'wt');
header = 'Original Image   |   True Positives   |   False Positives   |   False Negatives   |     Recall     |   Precision   |   F-measure';
fprintf(fid, '%s\n', header);

% Open and process the images sequentially.
for i=1:numImages
    if ((originalFolderInfo(i).bytes)==0) % POR COMO TASK 1
        nonImages = nonImages+1;
    else
        % Open original image and turn it to grayscale.
        nameImage = strcat(nameOriginalDir,'\',originalFolderInfo(i).name);
        input = im2double(imread(nameImage));
        input = rgb2gray(input);
        
        % Get the respective ROI.
        ROI = getROI(input, i);
        figure, subplot(1,2,1) % PARA ELIMINAR
        imshow(ROI), title("ROI " + (i-nonImages)), hold on; % PARA ELIMINAR
        
        % Segment the cells and plot both the obtained results and the 
        % ground truth.
        positive_locations = getGroundTruth(i);
        results_locations = segmentCells(ROI);        
        
        % Save the information concerning the rectangle surrounding a cell
        % to .mat file.
        fullFileName = strcat(resultsDir,'\',originalFolderInfo(i).name,'_result_locations.mat');
        fullFileName = erase(fullFileName,'.tiff');
        save(fullFileName, 'results_locations');
       
        % Evaluate the obtained segmenation.
        [autoNumCells, manualNumCells, TP, FP, FN, R, P, F1] = evaluateSegmentation(results_locations, positive_locations);
        fprintf(fid, '%s\t\t%i\t\t\t%i\t\t\t%i\t\t%2.4f\t\t%2.4f\t\t%2.4f\n', erase(originalFolderInfo(i).name, '.tiff'), TP, FP, FN, R, P, F1);
        subplot(1,2,2) % ELIMINAR
        text(0, 0.68, "Automatic Counting: " + autoNumCells + " cells"); hold on;
        text(0, 0.63, "Manual Counting: " + manualNumCells + " cells"); hold on;
        text(0, 0.58, "True Positives: " + TP); hold on;
        text(0, 0.53, "False Positives: " + FP); hold on;
        text(0, 0.48, "False Negatives: " + FN); hold on;
        text(0, 0.43, "Recall: " + R); hold on;
        text(0, 0.38, "Precision: " + P); hold on;
        text(0, 0.33, "F-measure: " + F1); hold on;
        axis off;
        
        pause; % ELIMINAR
    end
end

% Close the text file.
fclose(fid);

disp(toc)
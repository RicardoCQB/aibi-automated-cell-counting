%% Image Region of Interest (ROI) delineation 
% The goal is to delineate the rectangular region of the image where cells
% will be counted, called Region of Interest (ROI).
% The delineations made will be compared with a manual delineation (ground
% truth) and evaluated using the Jaccard Index and the maximum and mean
% values of the Euclidean distance between the vertices of the detected and
% GT ROIs.

% Open the directiory of the orignal images and get the number of images to
% be segmented.
nameDir = 'test-images\test_images';
folderInfo = dir(nameDir);
numImages = size(folderInfo, 1);

% Set directory in which the results will be saved and the text file for
% the results.
resultsDir = 'results\results_test_task1';
textFile = strcat(resultsDir, '\overall_results.txt');
fid = fopen(textFile, 'wt');
header = 'Original Image   |   Jaccard Index   |   Maximum Euclidean Distance   |   Mean Euclidean Distance';
fprintf(fid, '%s\n', header);

% Open and process the images sequentially.
for i=1:numImages
    if ((folderInfo(i).bytes)~=0)
        % Open the image.
        nameImage = strcat(nameDir,'\',folderInfo(i).name);
        input = im2double(imread(nameImage));
        
        % Segmentation of the image.
        ROI = segmentROI(input);
        figure, subplot(2,2,1)
%         imshow(labeloverlay(input, ROI)), title("Image " + (i-2) + " overlayed with segmented ROI");
%         subplot(2,2,2)
%         imshow(ROI), title('Segmented ROI');
        
        % Evaluation of the previous segmentation.
        [jaccard, max, mean] = evaluateROI(ROI, i);
%         subplot(2,2,[3 4])
%         text(0.3, 1, "Jaccard Index: " + jaccard); hold on;
%         text(0.2, 0.9, "Maximum Euclidean Distances: " + max); hold on;
%         text(0.21, 0.8, "Mean of Euclidean Distances: " + mean); hold on;
%         axis off;
        
        % Save the segmented image in the results' folder.
        fullFileName = strcat(resultsDir,'\',folderInfo(i).name,'_resultMask.png');
        fullFileName = erase(fullFileName,'.tiff');
        imwrite(ROI, fullFileName);
        
        % Write the obtained values in text file.
        fprintf(fid, '%s\t\t%2.4f\t\t\t%2.4f\t\t\t\t%2.4f\n', erase(folderInfo(i).name, '.tiff'), jaccard, max, mean);
    end
end

% Close the text file.
fclose(fid);
%% Image Region of Interest (ROI) delineation 
% The goal is to delineate the rectangular region of the image where cells
% will be counted, called Region of Interest (ROI).
% The delineations made will be compared with a manual delineation (ground
% truth) and evaluated using the Jaccard Index and the maximum and mean
% values of the Euclidean distance between the vertices of the detected and
% GT ROIs. 

close all; clear all;
% Open the directiory of the orignal images and get the number of images to
% be segmented
nameDir = 'C:\Users\maria\Documents\GitHub\aibi-automated-cell-counting\train-images\train_images';
folderInfo = dir(nameDir);
numImages = size(folderInfo, 1);
nonImages = 0;
% Open and process the images sequentially
for i=1:numImages
    if (getfield(folderInfo(i),'bytes')==0)
        nonImages = nonImages+1;
    else
        close all;
        nameImage = strcat(nameDir,'\',getfield(folderInfo(i),'name'));
        input = im2double(imread(nameImage));
        figure, imshow(input), title("Original Image " + (i-nonImages));
        pause;
    end
end
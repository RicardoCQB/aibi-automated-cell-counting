% Test task2 - Ricardo - RedChannel + preprocessment + multithresholding + topHat
% Test task2 - Ricardo
% Cenas a tentar:
% redChannel + multithresh + tophat
% gray + multithresh + topHat
% remover moldura com multithresh + top hat
% remover moldura da maneira da task1 + top hat
%


input = im2double(imread('train-images\train_images\20151115_172901.tiff'));

ROI = getROI(input, 3);
ROI_gray = rgb2gray(ROI);
ROI_med = medfilt2(ROI_gray);



% This part focuses on removing the grid

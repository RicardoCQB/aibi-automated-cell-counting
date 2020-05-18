% Test task2 - Ricardo 2

input = im2double(imread('train-images\train_images\20151115_172901.tiff'));

ROI = getROI(input, 3);
ROI_gray = rgb2gray(ROI);
ROI_med = medfilt2(ROI_gray);



% This part focuses on removing the grid

% Test task2 - Ricardo - RedChannel + preprocessment + multithresholding + topHat
% Test task2 - Ricardo
% Cenas a tentar:
% remover moldura da maneira da task1 + top hat%

function [centers, radii] = segmentCellsThreshold(input)
input = im2double(imread('train-images\train_images\20151115_172901.tiff'));

ROI = getROI(input, 3);
ROI_gray = rgb2gray(ROI);
ROI_med = medfilt2(ROI_gray);

se1 = strel('line', 30, 90);
se2 = strel('line', 30, 0);

ROI_open = imopen(ROI_med, se1);
ROI_open = imopen(ROI_open, se2);

figure, imshow(ROI_open);

thresholds = multithresh(ROI_open, 4);
ROI_bin = imbinarize(ROI_open, thresholds(4));
figure, imshow(ROI_bin);



% This part focuses on removing the grid

end



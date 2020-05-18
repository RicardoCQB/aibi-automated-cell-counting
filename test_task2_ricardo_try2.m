% Test task2 - Ricardo - RedChannel + preprocessment + multithresholding + topHat
% Test task2 - Ricardo
% Cenas a tentar:
% remover moldura da maneira da task1 + top hat%

function [centers, radii] = segmentCellsThreshold(input)
input = im2double(imread('train-images\train_images\20151115_172901.tiff'));

ROI = getROI(input, 3);
ROI_gray = rgb2gray(ROI);
ROI_med = medfilt2(ROI_gray);


thresholds = multithresh(ROI_med, 4);
ROI_bin = imbinarize(ROI_gray, thresholds(2));
figure, imshow(ROI_bin)

% This part focuses on removing the grid
se1 = strel('line', 5, 90);
se2 = strel('line', 5, 0);

ROI_open = imerode(ROI_bin, se1);
ROI_open = imerode(ROI_open, se2);

figure, imshow(ROI_open);

end



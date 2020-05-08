% This script tests the ROI_detection_hough function that detects lines in
% the microscopy image.

ROI_test = imread('train-images\train_images\20151115_172901.tiff');
ROI_test_doub = im2double(ROI_test);
ROI_test_gray = rgb2gray(ROI_test_doub);
ROI_test_med = medfilt2(ROI_test_gray);
ROI_test_bin = imbinarize(ROI_test_med);

ROI = edge(ROI_test_med, 'canny');
imshowpair(ROI_test_bin, ROI_test_med, 'montage');

%ROI = ROI_detection_hough(ROI_test);

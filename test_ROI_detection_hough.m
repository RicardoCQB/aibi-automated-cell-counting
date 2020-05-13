% This script tests the ROI_detection_hough function that detects lines in
% the microscopy image.

ROI_test = imread('train-images\train_images\20151115_172901.tiff');
ROI_test_doub = im2double(ROI_test);
ROI_test_gray = rgb2gray(ROI_test_doub);
ROI_test_med = medfilt2(ROI_test_gray);
ROI_test_bin = imbinarize(ROI_test_med);

lenH = 1600;
lenV = 1200;
%SE1 = strel('line',lenV,90);
%SE2 = strel('line',lenH,0);
SE3 = strel('line',50,90);
SE4 = strel('line',50,0);
%ROI_open1 = imopen(ROI_test_bin, SE1);
%ROI_open2 = imopen(ROI_test_bin, SE2);
ROI_close1 = imclose(ROI_test_bin, SE3);
ROI_close2 = imclose(ROI_test_bin, SE4);
ROI = edge(ROI_open, 'canny');

figure(1)
imshow(ROI_test_bin);
figure(2)
subplot(2,1,1)
imshow(ROI_close1);
subplot(2,1,2)
imshow(ROI_close2);
%ROI = ROI_detection_hough(ROI_test);

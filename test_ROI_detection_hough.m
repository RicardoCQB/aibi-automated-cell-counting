% This script tests the ROI_detection_hough function that detects lines in
% the microscopy image.

ROI_test = imread('train-images\train_images\20151115_183605.tiff');
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
ROI_close2 = imclose(ROI_close1, SE4);
SE5 = strel('disk', 10);
ROI_erode = imerode(ROI_close2, SE5);
ROI_fill = imfill(ROI_erode, 'holes');
SE6 = strel('disk', 30);
ROI_erode2 = imerode(ROI_fill, SE6);

figure(1)
imshow(ROI_test_bin);
figure(2)
imshow(ROI_close2);
%ROI = ROI_detection_hough(ROI_test);
figure(3)
imshow(ROI_erode);
figure(4)
imshow(ROI_fill);
figure(5)
imshow(ROI_erode2);

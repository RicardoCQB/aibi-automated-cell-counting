% This script tests the ROI_detection_hough function that detects lines in
% the microscopy image.

% Image Pre-processment that 
ROI_test = imread('train-images\train_images\20151115_183605.tiff');
ROI_test_doub = im2double(ROI_test);
ROI_test_gray = rgb2gray(ROI_test_doub);
ROI_test_med = medfilt2(ROI_test_gray);
ROI_test_bin = imbinarize(ROI_test_med);

% This block of code uses the function imclose to join the most adjacent
% lines together, vertically and horizontally.
SE_verticalLines = strel('line',50,90);
SE_horizontalLines = strel('line',50,0);
ROI_close1 = imclose(ROI_test_bin, SE_verticalLines);
ROI_close2 = imclose(ROI_close1, SE_horizontalLines);

% We use open prevent eroding the width of the big lines
SE5 = strel('disk', 10);
ROI_erode = imopen(ROI_close2, SE5);

ROI_fill = imfill(ROI_erode, 'holes');

ROI_water = watershed(ROI_fill);

ROI_boundariesStruct = bwboundaries(ROI_fill);
ROI_boundaries = ROI_boundariesStruct{1}; 
% Get rows and columns of the array separately
x = ROI_boundaries(:, 2);
y = ROI_boundaries(:, 1);

topLineIndex = min(x);
bottomLineIndex = max(x);
% Left column and right column are the minimum and maximum of the columns'
% vector, respectively
leftColumnIndex = min(y);
rightColumnIndex = max(y);
 
ROI_fill(1:topLineIndex,1:end) = 0;
ROI_fill(bottomLineIndex:end, 1:end) = 0;

ROI_fill(1:end, 1:leftColumnIndex) = 0;
ROI_fill(1:end, rightColumnIndex:end) = 0;

figure(1); imshow(ROI_test_bin);
figure(2); imshow(ROI_close2);
figure(3); imshow(ROI_erode);
figure(4); imshow(ROI_fill);
%figure(5); imshow(ROI_water);
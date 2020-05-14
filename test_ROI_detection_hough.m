% This script tests the ROI_detection_hough function that detects lines in
% the microscopy image.

% Image Pre-processment that 
ROI_test = imread('train-images\train_images\20151115_183605.tiff');
figure, imshow(ROI_test)
%%
ROI_test_doub = im2double(ROI_test);
ROI_test_gray = rgb2gray(ROI_test_doub);
ROI_test_med = medfilt2(ROI_test_gray);
ROI_test_bin = imbinarize(ROI_test_med);
figure, imshow(ROI_test_bin)
%%

% This block of code uses the function imclose to join the most adjacent
% lines together, vertically and horizontally.
SE_verticalLines = strel('line',50,90);
SE_horizontalLines = strel('line',50,0);
ROI_close1 = imclose(ROI_test_bin, SE_verticalLines);
ROI_close2 = imclose(ROI_close1, SE_horizontalLines);
figure, imshow(ROI_close2)
%%
% We use open prevent eroding the width of the big lines
SE5 = strel('disk', 17);
ROI_erode = imopen(ROI_close2, SE5);
figure, imshow(ROI_erode)
%%
ROI_fill = imfill(ROI_erode, 'holes');
figure, imshow(ROI_fill)
%%

ROI_boundariesStruct = bwboundaries(ROI_fill);
ROI_boundaries = ROI_boundariesStruct{1}; 
% Get rows and columns of the array separately
x = ROI_boundaries(:, 2);
y = ROI_boundaries(:, 1);


figure, imshow(ROI_fill)
hold on;
visboundaries(ROI_boundariesStruct)

topLineIndex = size(ROI_fill, 1);
bottomLineIndex = 1;

for i=1:length(y)
    if (y(i)==1)
        if (x(i)<topLineIndex)
            topLineIndex = x(i);
        elseif (x(i)>bottomLineIndex)
            bottomLineIndex = x(i);
        end
    end
end

leftColumnIndex = size(ROI_fill, 2);
rightColumnIndex = 1;

for i=1:length(x)
    if (x(i)==1)
        if (y(i)<leftColumnIndex)
            leftColumnIndex = y(i);
        elseif (y(i)>rightColumnIndex)
            rightColumnIndex = y(i);
        end
    end
end
 
ROI_fill(1:leftColumnIndex,:) = 0;
ROI_fill(rightColumnIndex:end, :) = 0;

ROI_fill(:, 1:topLineIndex) = 0;
ROI_fill(:, bottomLineIndex:end) = 0;
%%
%figure(1); imshow(ROI_test_bin);
%figure(2); imshow(ROI_close2);
%figure(3); imshow(ROI_erode);
figure(4); imshow(labeloverlay(ROI_test, ROI_fill));
%figure(5); imshow(ROI_water);
%%
gt = imread('train-images\train_ROI_images\20151115_183605_mask.png');
jaccard(ROI_fill, gt)
%%
% Get ROI vertices
    structBoundariesROI = bwboundaries(ROI_fill);
    boundariesROI = structBoundariesROI{1};
    x = boundariesROI(:, 2); y = boundariesROI(:, 1);
    topLineROI = min(x); bottomLineROI = max(x);
    leftColumnROI = min(y); rightColumnROI = max(y);
    verticesROI = [topLineROI leftColumnROI; topLineROI rightColumnROI; bottomLineROI leftColumnROI; bottomLineROI rightColumnROI];
    
    % Get ground truth vertices
    structBoundariesGT = bwboundaries(gt);
    boundariesGT = structBoundariesGT{1};
    x = boundariesGT(:, 2); y = boundariesGT(:, 1);
    topLineGT = min(x); bottomLineGT = max(x);
    leftColumnGT = min(y); rightColumnGT = max(y);
    verticesGT = [topLineGT leftColumnGT; topLineGT rightColumnGT; bottomLineGT leftColumnGT; bottomLineGT rightColumnGT];
    
    % Calculate the Euclidean distances
    for i=1:4
        euclidean(i)  = sqrt((verticesROI(i,1) - verticesGT(i,1))^ 2 + (verticesROI(i,2) - verticesGT(i,2))^ 2);
    end
    euclideanMax = max(euclidean);
    euclideanMean = mean(euclidean);
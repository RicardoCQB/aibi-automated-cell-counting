% This function tries to segment the cells using multithresholding of the
% grayscale and removing the grid of the image.
function [centers, radii] = segmentCellsMultiThresh(input)

gray = medfilt2(input);

% Upon testing three levels of thresholding was found to be appropriate
thresh = multithresh(gray,2);
disp(thresh)

% Used the 2 thresholds that were relevant, one that separated the grid and
% cells, and onde with the cells and the grid.
gray_lines = imbinarize(gray, thresh(3));
gray_cells = imbinarize(gray, thresh(2));
disp(thresh)
figure, subplot(1,3,1)
imshow(imbinarize(gray, thresh(1)))
figure, subplot(1,3,2)
imshow(imbinarize(gray, thresh(2)))
figure, subplot(1,3,3)
imshow(imbinarize(gray, thresh(3)))

% Subctracted the grid to the cells and binarized the image.
gray_cells = gray_cells - gray_lines;
gray_cells = medfilt2(gray_cells);
gray_cells = imbinarize(gray_cells);
figure, imshow(gray_cells);

[centers, radii] = imfindcircles (gray_cells, [14 100],'ObjectPolarity','dark', 'Sensitivity', 0.85, 'EdgeThreshold', 0.5);
viscircles(centers, radii);

end
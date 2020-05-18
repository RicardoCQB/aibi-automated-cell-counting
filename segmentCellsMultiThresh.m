% This function tries to segment the cells using multithresholding of the
% grayscale and removing the grid of the image.
function [centers, radii] = segmentCellsMultiThresh(input)

gray = medfilt2(input);

% Upon testing three levels of thresholding was found to be appropriate
thresh = multithresh(gray,3);

% Used the 2 thresholds that were relevant, one that separated the grid and
% cells, and onde with the cells and the grid.
gray_lines = imbinarize(gray, thresh(3));
gray_cells = imbinarize(gray, thresh(2));

% Subctracted the grid to the cells and binarized the image.
gray_cells = gray_cells - gray_lines;
gray_cells = medfilt2(gray_cells);
gray_cells = imbinarize(gray_cells);

SE1 = strel('disk', 3);
%gray_cells = imbothat(gray_cells, SE1);
figure, imshow(gray_cells);

[centers, radii] = imfindcircles (gray_cells, [14 100],'ObjectPolarity','dark', 'Sensitivity', 0.85, 'EdgeThreshold', 0.5);

end
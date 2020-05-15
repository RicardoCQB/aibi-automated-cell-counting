% Function that returns positions of the segmented cells in the image it
% recieves as input

function [centers, radii] = segmentCells(image)
    [Gmag, Gdir] = imgradient(image, 'sobel');
    bw = imbinarize(Gmag);
    [centers, radii] = imfindcircles (bw, [11 50]); 
end
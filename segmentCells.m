% Function that returns positions of the segmented cells in the image it
% recieves as input

function [centers, radii] = segmentCells(image)
    gray = medfilt2(image);
    figure, imshow(gray)
    
    thresh = multithresh(gray,3);
    gray_lines = imbinarize(gray, thresh(3));
    
    [Gmag, Gdir] = imgradient(image, 'sobel');
    figure, imshow(Gmag)
    bw = imbinarize(Gmag);
    figure, imshow(bw)
    
    bw = imsubtract(bw, gray_lines);
    figure, imshow(bw)
    bw = bwmorph(bw, 'close');
    figure, imshow(bw)
    
    [centers, radii] = imfindcircles (bw, [14 50], 'ObjectPolarity', 'dark'); 
end
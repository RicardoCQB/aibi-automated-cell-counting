% Function that returns positions of the segmented cells in the image it
% recieves as input

function [centers, radii] = segmentCells(image)
    % Reduce noise 
    med = medfilt2(image, [5 5]);
    figure, imshow(med)

    % Enhance contrast
    adapt = adapthisteq(med);
    figure, imshow(adapt)
    
    % Get the borders and turn the image into black and white
    [Gmag, Gdir] = imgradient(gray, 'sobel');
    figure, imshow(Gmag)
    bw = imbinarize(Gmag);
    figure, imshow(bw)
    
    % Identify circles
    [centers, radii] = imfindcircles (bw, [14 50], 'ObjectPolarity', 'dark'); 
    
    % Get the bottom and right lines from which the cells beyond them will
    % not be counted
    [bottom, right] = excludeBorders(image);
    
    % Eliminate the cells beyond these lines
    % POR FAZER
end
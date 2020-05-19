% Function that returns positions of the segmented cells in the image it
% recieves as input

function [centers, radii] = segmentCells(image)
    % Reduce noise 
    med = medfilt2(image, [5 5]);

    % Enhance contrast
    adapt = adapthisteq(med);
    
    % Get the borders and turn the image into black and white
    [Gmag, Gdir] = imgradient(adapt, 'sobel');
    bw = imbinarize(Gmag);
    figure, imshow(bw)
    
    % Identify circles
    [centersAux, radiiAux] = imfindcircles (bw, [14 50], 'ObjectPolarity', 'dark'); 
    
    % Get the bottom and right lines from which the cells beyond them will
    % not be counted
    [bottom, right] = excludeBorders(image);
    
    % Eliminate the cells beyond these lines
    n = 1;
    for i=1:size(centersAux,1)
        if (centersAux(i,2)<=bottom && centersAux(i,1)<=right)
            centers(n,2) = centersAux(i,2); centers(n,1) = centersAux(i,1);
            radii(n) = radiiAux(i);
            n = n+1;
        end
    end
end
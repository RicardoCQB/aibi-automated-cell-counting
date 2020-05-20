% Function that returns positions of the segmented cells in the image it
% recieves as input as a rectangle that surrounds it

function results_locations = segmentAndPlotCells(image)
    % Reduce noise 
    med = medfilt2(image, [5 5]);

    % Enhance contrast
    adapt = adapthisteq(med);
    
    % Get the borders and turn the image into black and white
    [Gmag, Gdir] = imgradient(adapt, 'sobel');
    bw = imbinarize(Gmag);
    
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
    
    % Obtain the surrounding rectangle
    results_locations = zeros(size(centers, 1), 4);
    for n=1:size(centers, 1)
        results_locations(n, 1) = centers(n, 1) - radii(n);
        results_locations(n, 2) = centers(n, 2) - radii(n);
        results_locations(n, 3) = radii(n)*2;
        results_locations(n, 4) = radii(n)*2;
    end
    
    % Plot the surrounding rectangle
    for m=1:size(results_locations, 1)
        rectangle('Position', [results_locations(m,1) results_locations(m,2) results_locations(m,3) results_locations(m,4)], 'EdgeColor', 'b', 'LineWidth', 1)
    end
end
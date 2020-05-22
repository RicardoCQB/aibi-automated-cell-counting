% Function that returns positions of the segmented cells in the image it
% receives as input as a rectangle that surrounds it.

function results_locations = segmentCells(image)
    % Reduce noise and enhance contrast.
    med = medfilt2(image, [5 5]);
    adapt = adapthisteq(med);
    
    % Enhance the borders with he gradient filter and turn the image into black and white.
    [Gmag, Gdir] = imgradient(adapt, 'sobel');
    bw = imbinarize(Gmag);
    
    % Identify circles.
    [centersAux_1, radiiAux_1] = imfindcircles(bw, [14 30], 'ObjectPolarity', 'dark'); 
    [centersAux_2, radiiAux_2] = imfindcircles(bw, [30 50], 'ObjectPolarity', 'dark');
    [centersAux_3, radiiAux_3] = imfindcircles(bw, [14 30]);
    [centersAux_4, radiiAux_4] = imfindcircles(bw, [30 50]);
    centersAux = cat(1, centersAux_1, centersAux_2, centersAux_3, centersAux_4);
    radiiAux = cat(1, radiiAux_1, radiiAux_2, radiiAux_3, radiiAux_4);
    centersAux = round(centersAux);
    radiiAux = ceil(radiiAux);
    
    % Get the bottom and right line coordinates of the squared grid.
    % These coordinates are used to exclude all the cells that are beyond these
    % borders.
    [bottom, right] = excludeBorders(image);
    
    % Eliminates the cells beyond the bottom and right lines of the grid.
    n = 1;
    for i=1:size(centersAux,1)
        if (centersAux(i,2)<=bottom && centersAux(i,1)<=right)
            centers(n,2) = centersAux(i,2); centers(n,1) = centersAux(i,1);
            radii(n) = radiiAux(i);
            n = n+1;
        end
    end

    % Obtain the surrounding rectangle of each cell and stores it in an array.
    % First and second column of the array reprents the x and y coordinate
    % of the rectangle's top left corner.
    % Third and second column represent the vertical and horizontal length
    % of each rectangle.
    results_locations = zeros(size(centers, 1), 4);
    for n=1:size(centers, 1)
        results_locations(n, 1) = centers(n, 1) - radii(n);
        results_locations(n, 2) = centers(n, 2) - radii(n);
        results_locations(n, 3) = radii(n)*2;
        results_locations(n, 4) = radii(n)*2;
    end

    % Eliminates cells that are segmented more than once.
    
    unique(results_locations,'rows');
    
    overlapRatio = bboxOverlapRatio(results_locations,results_locations,'min');
    overlapRatio = tril(overlapRatio);
    
    for a=1:size(overlapRatio,1)
        overlapRatio(a,a) = 0;
    end
    
    indexToErase = 1;
    [overlaprow, overlapcol] = find(overlapRatio>=0.5);
    for j=1:size(overlaprow)
        areaBBoxA = results_locations(overlaprow(j),3)^2;
        areaBBoxB = results_locations(overlapcol(j),3)^2;
        if (areaBBoxA<=areaBBoxB)
            eraseInd(indexToErase) = overlaprow(j);
            indexToErase = indexToErase+1;
        else
            eraseInd(indexToErase) = overlapcol(j);
            indexToErase = indexToErase+1;
        end
    end
    
    unique(eraseInd);
    results_locations(eraseInd,:)=[];
    
%     % Plot the surrounding rectangle.
%     for m=1:size(results_locations, 1)
%         rectangle('Position', [results_locations(m,1) results_locations(m,2) results_locations(m,3) results_locations(m,4)], 'EdgeColor', 'b', 'LineWidth', 1)
%     end
end
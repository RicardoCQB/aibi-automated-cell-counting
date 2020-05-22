% Function that returns positions of the segmented cells in the image it
% recieves as input as a rectangle that surrounds it.

function results_locations = segmentCells(image)
    % Reduce noise and enhance contrast.
    med = medfilt2(image, [5 5]);
    adapt = adapthisteq(med);
    
    % Get the borders and turn the image into black and white.
    [Gmag, Gdir] = imgradient(adapt, 'sobel');
    bw = imbinarize(Gmag);
    figure, imshow(bw), hold on;
    
    % Identify circles.
    [centersAux_1, radiiAux_1] = imfindcircles(bw, [15 30], 'ObjectPolarity', 'dark'); 
    [centersAux_2, radiiAux_2] = imfindcircles(bw, [30 50], 'ObjectPolarity', 'dark');
    [centersAux_3, radiiAux_3] = imfindcircles(bw, [15 30]);
    [centersAux_4, radiiAux_4] = imfindcircles(bw, [30 50]);
    centersAux = cat(1, centersAux_1, centersAux_2, centersAux_3, centersAux_4);
    radiiAux = cat(1, radiiAux_1, radiiAux_2, radiiAux_3, radiiAux_4);
    viscircles(centersAux,radiiAux)
%     % Eliminate repeated cells
%     auxC = centersAux; auxR = radiiAux;
%     for a=size(centersAux,1):-1:1
%         for b=size(centersAux, 1):-1:1
%             if (centersAux(a,1)>=auxC(b,1)-auxR(b) && centersAux(a,1)<=auxC(b,1)+auxR(b))
%                 centersAux(a,:)=[]; radiiAux(a)=[];
%                 auxC(a,:)=[]; auxR(a)=[];
%                 break
%             end
%         end
%     end
    
    % Get the bottom and right lines from which the cells beyond them will
    % not be counted.
    [bottom, right] = excludeBorders(image);
    
    % Eliminate the cells beyond these lines.
    n = 1;
    for i=1:size(centersAux,1)
        if (centersAux(i,2)<=bottom && centersAux(i,1)<=right)
            centers(n,2) = centersAux(i,2); centers(n,1) = centersAux(i,1);
            radii(n) = radiiAux(i);
            n = n+1;
        end
    end
    centers = round(centers);
    radii = ceil(radii);
    
    % Obtain the surrounding rectangle.
    results_locations = zeros(size(centers, 1), 4);
    for n=1:size(centers, 1)
        results_locations(n, 1) = centers(n, 1) - radii(n);
        results_locations(n, 2) = centers(n, 2) - radii(n);
        results_locations(n, 3) = radii(n)*2;
        results_locations(n, 4) = radii(n)*2;
    end

    %Erase repeated cells
    unique(results_locations,'rows');
    overlapRatio = bboxOverlapRatio(results_locations,results_locations,'min');
    overlapRatio=tril(overlapRatio);
    for a=1:size(overlapRatio,1)
            overlapRatio(a,a)=0;
    end
    
    %No longer symmetric
    indexToErase=1;
    [overlaprow overlapcol]=find(overlapRatio>=0.80);
    for j=1:size(overlaprow)
        areaBBoxA=results_locations(overlaprow(j),3)^2;
        areaBBoxB=results_locations(overlapcol(j),3)^2;
        if areaBBoxA<=areaBBoxB
            eraseInd(indexToErase)=overlaprow(j);
            indexToErase=indexToErase+1;
        else
            eraseInd(indexToErase)=overlapcol(j);
            indexToErase=indexToErase+1;
        end
    end
    unique(eraseInd)
    results_locations(eraseInd,:)=[];
    
    % Plot the surrounding rectangle. % ELIMINAR
    for m=1:size(results_locations, 1)
        rectangle('Position', [results_locations(m,1) results_locations(m,2) results_locations(m,3) results_locations(m,4)], 'EdgeColor', 'b', 'LineWidth', 1)
    end
end
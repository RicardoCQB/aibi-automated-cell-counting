% Function that gets the bottom and right lines from which the cells beyond
% them will not be counted

function [bottom, right] = excludeBorders(image)
    % Smooth the image and increase contrast
    image = medfilt2(image);
    image = adapthisteq(image);

    % Join the adjacent lines that delineate the ROI
    SE_vertical = strel('line',50,90);
    SE_horizontal = strel('line',50,0);
    ROI_close = imclose(image, SE_vertical);
    ROI_close = imclose(ROI_close, SE_horizontal);
    
    % Eliminate the other lines that form the grid
    SE = strel('disk', 17);
    ROI_open = imopen(ROI_close, SE);
    
    % Binarize only the adjacent lines
    Th = multithresh(ROI_open, 2);
    ROI_bin = imbinarize(ROI_open, Th(2));
    
    % Obtain the edges
    [Gmag Gdir] = imgradient(ROI_bin);

    % Find the lines that correspond to the edges
    [H,T,R] = hough(Gmag, 'RhoResolution', 0.1, 'Theta', [-90, 0, 89]);
    numLines = 30;
    peaks = houghpeaks(H,numLines, 'Threshold', 0.4*max(H(:)));
    lines = houghlines(Gmag,T,R,peaks, 'FillGap', 1000);
    
    % Get the bottom and right lines that form the exterior boundaries of
    % the ROI
    rightEnd = 0;
    bottomEnd = 0;
    for k = 1:length(lines)
        lines(k).rho =  abs(lines(k).rho);
        if (lines(k).theta == 0)
            if (lines(k).rho > rightEnd)
                rightEnd = lines(k).rho;
            end
        elseif (lines(k).theta == -90 || lines(k).theta==89)
            if (lines(k).rho>bottomEnd)
                bottomEnd = lines(k).rho;
            end
        end
    end
    
    % Get the bottom and right lines that form the interior boundaries of
    % the ROI
    right = 0;
    bottom = 0;
    for k=1:length(lines)
        if (lines(k).theta==0)
            if(lines(k).rho>right && lines(k).rho~=rightEnd)
                right = lines(k).rho; 
            end
        elseif (lines(k).theta==-90 || lines(k).theta==89)
            if(lines(k).rho>bottom && lines(k).rho~=bottomEnd)
                bottom = lines(k).rho; 
            end   
        end
    end
end
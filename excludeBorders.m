function [bottom, right] = excludeBorders(image)
    SE_vertical = strel('line',50,90);
    SE_horizontal = strel('line',50,0);
    ROI_close = imclose(image, SE_vertical);
    ROI_close = imclose(ROI_close, SE_horizontal);
    
    SE = strel('disk', 17);
    ROI_open = imopen(ROI_close, SE);
    
    Th = multithresh(ROI_open, 3);
    ROI_bin = imbinarize(ROI_open, Th(3));
    
    [H,T,R] = hough(ROI_bin, 'Theta', [-90, 0]);
    numLines = 8;
    peaks = houghpeaks(H,numLines, 'Threshold', 30);
    x = T(peaks(:,2));
    y = R(peaks(:,1));
    lines = houghlines(ROI_bin,T,R,peaks);
    figure,imshow(ROI_bin), hold on;
    for k = 1:length(lines)
        xy = [lines(k).point1;lines(k).point2];
        plot(xy(:,1),xy(:,2),'Color','green');
    end
    
    bottom = 0;
    right = 0;
end
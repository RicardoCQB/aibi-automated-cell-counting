function segmentROI(input)

        image = rgb2gray(input);
        SE = strel('disk', 5);
        image = imerode(image, SE);
        image = imbinarize(image);
        
        % Detetar linhas horizontais
        [Hh, Th, Rh] = hough(image,'RhoResolution', 0.01, 'Theta', -90:-80);
        peaksh = houghpeaks(Hh, 9);
        linesh = houghlines(image, Th, Rh, peaksh, 'FillGap', 300);
        for k=1:length(linesh)
            xy=[linesh(k).point1;linesh(k).point2];
            plot(xy(:,1),xy(:,2),'Color','blue', 'LineWidth', 2);
        end
      
        % Detetar linhas verticais
        [Hv, Tv, Rv] = hough(image, 'RhoResolution', 0.01, 'Theta', -10:0);
        peaksv = houghpeaks(Hv, 9);
        linesv = houghlines(image, Tv, Rv, peaksv, 'FillGap', 300);
        for k=1:length(linesv)
            xy=[linesv(k).point1;linesv(k).point2];
            plot(xy(:,1),xy(:,2),'Color','green', 'LineWidth', 2);
        end
end
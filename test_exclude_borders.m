close all;
input = im2double(imread('train-images\train_images\20151118_121152.tiff'));
ROI = getROI(input, 13);
ROI = rgb2gray(ROI);
figure, imshow(ROI)
%% 
SE_vertical = strel('line',40,90);
SE_horizontal = strel('line',40,0);
ROI_close = imclose(ROI, SE_vertical);
ROI_close = imclose(ROI_close, SE_horizontal);
figure, imshow(ROI_close)
    
%%
SE = strel('disk', 15);
ROI_open = imopen(ROI_close, SE);
figure, imshow(ROI_open)

%%
Th = multithresh(ROI_open, 2);
ROI_bin = imbinarize(ROI_open, Th(2));
figure, imshow(ROI_bin), hold on;

%%
[Gmag Gdir] = imgradient(ROI_bin);
figure, imshow(Gmag), hold on

%%
[H,T,R] = hough(Gmag, 'RhoResolution', 0.5, 'Theta', [-90, 0]);
numLines = 8;
peaks = houghpeaks(H,numLines);
x = T(peaks(:,2));
y = R(peaks(:,1));
lines = houghlines(Gmag,T,R,peaks, 'FillGap', 300);

%%
for k=1:length(lines)
    xy=[lines(k).point1;lines(k).point2];
    plot(xy(:,1),xy(:,2),'Color','green');
    pause;
end

%%
rightEnd = 0;
bottomEnd = 0;
for k = 1:length(lines)
    lines(k).rho =  abs(lines(k).rho);
    if (lines(k).theta == 0)
        if (lines(k).rho > rightEnd)
            rightEnd = lines(k).rho;
        end
    elseif (lines(k).theta == -90)
        if (lines(k).rho>bottomEnd)
            bottomEnd = lines(k).rho;
        end
    end
end
     
right = 0;
bottom = 0;
for k=1:length(lines)
    if (lines(k).theta==0)
        if(lines(k).rho>right && lines(k).rho~=rightEnd)
            right = lines(k).rho; 
        end
    elseif (lines(k).theta==-90)
         if(lines(k).rho>bottom && lines(k).rho~=bottomEnd)
            bottom = lines(k).rho; 
         end   
    end
end

close all; clear all;
% Obter ROI
input = im2double(imread('train-images\train_images\20151115_172901.tiff'));
ROI = getROI(input, 3);
figure, imshow(ROI)
%%
% Passar para cinza e suavização
gray = rgb2gray(ROI);
med = medfilt2(gray);
figure, imshow(med)
%%
% suavizar linhas ligeiramente
SE = strel('disk', 10);
open = imclose(med, SE);
figure, imshow(open)
figure, imhist(open)
%% 
sub = imsubtract(open, med);
sub = imadjust(sub);
figure, imshow(sub)
%%
% Obter gradiente
[Gmag, Gdir] = imgradient(sub, 'sobel');
figure, imshow(Gmag)

%%
bw = imbinarize(Gmag);
figure, imshow(bw)

%%
close all;
figure, imshowpair(ROI,bw,'montage')

[centersD, radiiD] = imfindcircles (bw, [11 60], 'ObjectPolarity', 'dark'); 
viscircles(centersD, radiiD, 'Color', 'b');
close all; clear all;
% Obter ROI
input = im2double(imread('train-images\train_images\20151118_121152.tiff'));
ROI = getROI(input, 13);
figure, imshow(ROI)
%%
% Passar para cinza e suavização
gray = rgb2gray(ROI);
med = medfilt2(gray);
figure, imshow(med)
%%
ths = multithresh(med, 3);
b = imquantize(med, ths);
RGB = label2rgb(b); 
figure, imshow(RGB)
%%
lines = imbinarize(med, ths(3));
figure, imshow(lines)
%%
% Obter gradiente
[Gmag, Gdir] = imgradient(med, 'sobel');
figure, imshow(Gmag)

%%
bw = imbinarize(Gmag);
figure, imshow(bw)

%%
sub = imsubtract(bw, lines);
figure, imshow(sub)
%%
close all;
figure, imshowpair(ROI,bw,'montage')

[centersD, radiiD] = imfindcircles (bw, [11 60], 'ObjectPolarity', 'dark'); 
viscircles(centersD, radiiD, 'Color', 'b');
% Test task2 - Ricardo

input = im2double(imread('train-images\train_images\20151115_172901.tiff'));
ROI = getROI(input, 3);
figure(1), imshow(ROI)

gray = rgb2gray(ROI);

%med = medfilt2(gray);
figure(2), imshow(gray);

%From now on we are using only the red channel to segment cells.
redChannel = ROI(:,:,1);
greenChannel = ROI(:,:,2);
blueChannel = ROI(:,:,3);
figure(3)
subplot(3,1,1), imshow(redChannel);
subplot(3,1,2), imshow(greenChannel);
subplot(3,1,3), imshow(blueChannel);


SE = strel('disk', 3);
redChannel = imopen(redChannel, SE);

figure(6), imshow(redChannel);

thresh = multithresh(redChannel,4);
seg_otsu = imquantize(redChannel, thresh(4));
rgb_otsu = label2rgb(seg_otsu);
figure(4), imshow(rgb_otsu);

figure(5)
subplot(1,3,1), imshow(rgb_otsu(:,:,1)); % This one might be useful.
subplot(1,3,2), imshow(rgb_otsu(:,:,2));
subplot(1,3,3), imshow(rgb_otsu(:,:,3)); % This one is the most useful.
%subplot(1,5,4), imshow(rgb_otsu(:,:,4));


useful = rgb_otsu(:,:,3);


%figure(6)
%imshow(useful)

[useful3grad, useful3dir] = imgradient(useful,'prewitt');
bw = imbinarize(useful);
h = fspecial('gaussian',7);
bw = imfilter(bw,h);

% Falta tratar o useful para o imfindcircles encontrar alguma coisa
figure(7)
imshow(bw);
[centersD, radiiD] = imfindcircles (bw, [11 70], 'Sensitivity', 0.85, 'EdgeThreshold', 0.5);
%[centersD2, radiiD2] = imfindcircles (bw, [25 60],'Sensitivity',0.5);
viscircles(centersD, radiiD, 'Color', 'b');
%viscircles(centersD2, radiiD2, 'Color', 'b');
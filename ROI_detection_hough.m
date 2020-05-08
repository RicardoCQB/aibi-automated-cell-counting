function [ROI] = ROI_detection_hough(I)
% This function detects the square delimited by three close consecutive
% lines present in the microscopy images. 
%This square represents our Region of Interest (ROI)
% I - Input image
% ROI - Region of interest of input image

[houghMatrix, theta, rho] = hough(I);


end


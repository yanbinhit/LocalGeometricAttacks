function directSmoothIterativeTest()
close all; clear;
window = 3;
level = 1;
debug = 1;
numIter = 3; % 30

imageFileIn = 'zhonglou512.bmp';
% imageFileIn = 'yifulou512gray.bmp';
% imageFileIn = 'yifulou.bmp';
%imageFileIn = '08.png';
% imageFileIn = 'DiagStripeImage.bmp';
% imageFileIn = 'VerticalStripes.jpg';

imageIn = imread(imageFileIn);
[attackedImg, Dx, Dy, DxHat, DyHat] = ...
    directSmoothIterative(imageIn, level, window, numIter, debug);

save('displacementField.mat', 'Dx', 'Dy', 'DxHat', 'DyHat');
%=======================================
% Perceptual quality evaluation 
%=======================================
 Gabor_metric(imageFileIn, Dx, Dy, 1)
 Gabor_metric(imageFileIn, DxHat, DyHat, 1)
 Gabor_metric(imageFileIn, zeros(size(imageIn,1),size(imageIn,2)),...
     zeros(size(imageIn,1), size(imageIn,2)), 1)
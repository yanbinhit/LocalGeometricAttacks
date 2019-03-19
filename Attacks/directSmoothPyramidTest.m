function directSmoothPyramidTest()
close all; clear;
% change working directory
prevDir = pwd;
[dir, dummy, dummy2] = fileparts(mfilename('fullpath'));
cd(dir); 

%imageFileIn = 'zhonglou512.bmp';
imageFileIn = 'yifulou512.bmp';
imageIn = imread(imageFileIn);
figure; imshow(imageIn,[]);  title('original image');drawnow;

%imageFileIn =  'zhonglou512gray.bmp';
%imageFileIn = 'VerticalStripes.jpg';
% imageFileIn = 'yifulou512gray.bmp'
debug = 1;
window = 9;
level = 5;
[attackedImg, Dx, Dy, DxFinal, DyFinal] = ...
    directSmoothPyramid(imageIn, level, window, debug);
figure; imshow(attackedImg,[]);title('attacked image'); drawnow; 

save('displacementFieldPyramid.mat', 'Dx', 'Dy', 'DxFinal', 'DyFinal');

% Gabor metric
 Gabor_metric(imageFileIn, Dx, Dy, 1)
 Gabor_metric(imageFileIn, DxFinal, DyFinal, 1)
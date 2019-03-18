% DWT_wateramrkingTest.m
clear; close all; 
prevDir = pwd;
[dir, dummy, dummy2] = fileparts(mfilename('fullpath'));
cd(dir); 


imgFile = '..\Images\yifulou512gray.bmp';
nb = 500; 
k = 2;
seedKey = 2;
DEBUG = 1;
figure; imshow(imread(imgFile),[]); title('Original image');
imgIn = imread(imgFile);
[imgWmed, bits] = DWT_embedding(imgIn, nb, k, seedKey, DEBUG);


fileTmp = imgFile;
sizeName = size(fileTmp, 2);
fileName = fileTmp(1:sizeName-3);
wmedImgFile =  [fileName 'DwtWmed' '.tif'];
wmedImg = imread(wmedImgFile);
bitErrRate = DWT_decoding(wmedImg, nb, k, seedKey, bits, DEBUG)
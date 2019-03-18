% DWT_embeddingTest.m
clear; close all; 
prevDir = pwd;
[dir, dummy, dummy2] = fileparts(mfilename('fullpath'));
cd(dir); 


imgFile = '..\Images\yifulou512gray.bmp';
nb = 50; 
k = 5;
seedKey = 2;
DEBUG = 0;
figure; imshow(imread(imgFile),[]); title('Original image');
imgIn = imread(imgFile);
[imgWmed, bits] = DWT_embedding(imgIn, nb, k, seedKey, DEBUG);
% DWT_embeddingTest.m
clear; close all; 
prevDir = pwd;
[dir, dummy, dummy2] = fileparts(mfilename('fullpath'));
cd(dir); cd ..;


imgFile = 'Images\yifulou512gray.bmp';
nb = 50; 
k = 5;
seedKey = 2;
DEBUG = 0;
figure; imshow(imread(imgFile),[]); title('Original image');
[imgWmed, bits] = DWT_embedding(imgFile, nb, k, seedKey, DEBUG);
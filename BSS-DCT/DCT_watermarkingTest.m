% DCT_wateramrkingTest.m
clear all; close all; 

imgFile = 'lena.tiff';
imgIn = imread(imgFile);
k = 2;
seedKey = round(unifrnd(1, 100));
L = 25000;
M = 16000;
DEBUG = 1;

numBits = [50, 100, 150, 200];
for i = 1:length(numBits);
    nb = numBits(i);
    [imgWmed, bits] = DCT_embedding(imgIn, nb, k, seedKey, L, M, DEBUG);
    figure; imshow(imgWmed); title(['watermarked image' '  nb = ' num2str(nb)]);
    bitErrRate = DCT_decoding(imgWmed, nb, k, seedKey, L, M, bits);
    bitErrRate
end
% DCT_embeddingTest.m
clear all; close all; 

imgFile = 'lena.tiff';
nb = 50; 
k = 5;
seedKey = 2;
L = 25000;
M = 16000;
imgIn = imread(imgFile);
DEBUG = 1;
[imgWMed, bits] = DCT_embedding(imgIn, nb, k, seedKey, L, M, DEBUG);

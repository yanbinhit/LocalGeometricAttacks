function testZigZag()
% test zigzag and InvZigZag

% I = [1 2 3 4;5 6 7 8;9 10 11 12]
% Izg = ZigZag(I)
% Icap = InvZigZag(Izg,3,4)
clear;close all;
I = imread('lena.tiff');
[M,N] = size(I);

Izg = ZigZag(I);
Icap = InvZigZag(Izg,M,N);
 
imshow(I,[]);

Icap = fix(Icap);
figure;
imshow(Icap,[]);


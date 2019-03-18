function [imgWmed, bits] = DWT_embedding(imgIn, nb, k, seedKey, DEBUG)
% DWT_embedding: Embed multiple bits into an image in DWT domain (one level Haar) 
% 
% <Inputs>
%   imgIn: input image matrix. each entry is of type uint8.
%   nb: number of bits embedded. The paper below uses 50-200 bits
%   k:  strength of the embedding
%   seedKey: secret key shared by watermark embedder and detectors. It is a
%       seed to a pseudo random number generator
%   DEBUG: if DEBUG = 1, then display some intermediate results.
% 
% <Outputs>
%   imgWmed: watermarked image (changed to uint8 format)
%   bits: The sequence of bits that has been embeded into the image. It is
%       useful when we want to compare the embedded bits and extracted bits in
%       Monte Carlo simultion
%
%   The watermarked image is saved as an image file with WMed
%   appended at the end of the name of the file
% 
% <Author>
%   Bin Yan, 2013.9.22. yanbinhit@hotmail.com
%
% <Note>
% This implementation is based on the pseudocodes in the following papers
% [1] Angela D' Angelo, Mauro Barni, and Neri Merhav, Stochastic Image Warping
%     for Improved Watermark Desynchronization. EURASIP Journal on Information
%     Security. vol. 2008 
% [2] Angela D' Angelo. Characterization and Quality Evaluation of
%     Geometric Distortion in Images with Applications to Digital Watermarking.
%     Ph.D. thesis. Universiy of Siena. 2009.
%==============================================================================

% Generate a random binary message
bits = normrnd(0,1,nb,1)>0;

% Read image and perform 1 level of Haar decomposition
imgIn = double(imgIn);
[r,c] = size(imgIn);
if (r<256) | ( c<256)
    error('The size of the image should be larger than 256x256');
end
[cA1, cH1, cV1, cD1] = dwt2(imgIn, 'db1'); % 'db1' is Haar wavelet

if DEBUG == 1 % Display the decomposition result.
    A1 = upcoef2('a', cA1, 'db1', 1);
    H1 = upcoef2('h', cH1, 'db1', 1);
    V1 = upcoef2('v', cV1, 'db1', 1);
    D1 = upcoef2('d', cD1, 'db1', 1);
    figure;
    subplot(2,2,1);imagesc(A1); colormap(gray); 
    subplot(2,2,2);imagesc(H1); colormap(gray);
    subplot(2,2,3);imagesc(V1); colormap(gray);
    subplot(2,2,4);imagesc(D1); colormap(gray);
end

T = [cH1(:); cV1(:); cD1(:)];  % put all coeff. into a vector
M = length(T);
T_hat = zeros(M, 1);   % watermarked coefficients
T_hat = T;

% Generate wateramrk pattern according to seedKey
rng(seedKey);
PN = 2 * (normrnd(0, 1, length(T_hat), 1)>0) - 1;   % sequence of +/- 1's

% Embed bits into coefficients
lenBit = floor(M/nb);   % The length of the subvector that is used to embedd one bit
for bIdx = 1 : nb
    lowerLimit = (bIdx-1)*lenBit + 1;      % lower and upper limit of each segment
    UpperLimit = (bIdx-1)*lenBit + lenBit;
    
    if bits(bIdx) == 0
       T_hat(lowerLimit: UpperLimit) = T(lowerLimit: UpperLimit) + k .* PN(lowerLimit: UpperLimit);
    else
       T_hat(lowerLimit: UpperLimit) = T(lowerLimit: UpperLimit) - k .* PN(lowerLimit: UpperLimit);
    end
        
end

% synthesize the watermarked image
[sizeCoefX,sizeCoefY] = size(cH1);
lengthCoef = sizeCoefX * sizeCoefY;
cH1Hat = reshape(T_hat(1:lengthCoef), sizeCoefX, sizeCoefY);
cV1Hat = reshape(T_hat((lengthCoef+1):(2*lengthCoef)), sizeCoefX, sizeCoefY);
cD1Hat = reshape(T_hat((2*lengthCoef+1):(3*lengthCoef)), sizeCoefX, sizeCoefY);
imgWmed = idwt2(cA1, cH1Hat, cV1Hat, cD1Hat, 'db1');

if DEBUG == 1
    figure; imshow(uint8(imgWmed),[]); title('Watermarked image');
end

% % Save the watermarked image and messages
% imgWmed = uint8(imgWmed);
% fileOutTmp = imgFile;
% sizeName = size(fileOutTmp, 2);
% fileOut = fileOutTmp(1:sizeName-3);
% f_out = [fileOut 'DwtWmed' '.tif'];
% imwrite(imgWmed, f_out, 'tif');

















function [imgWmed, bits] = DCT_embedding(imgIn, nb, k, seedKey, L, M, DEBUG)

% DCT_embedding: Embed multiple bits into and image in DCT domain 
% 
% <Inputs>
%   imgIn: Input image matrix.
%   nb: number of bits embedded. The paper below uses 50-200 bits
%   k:  strength of the embedding
%   seedKey: secret key shared by watermark embedder and detectors. It is a
%       seed to a pseudo random number generator
%   L:  the first L coefficient in the zig-zag scan of the full frame DCT
%       coefficients are skipped. 
%   M:  The M coefficients from L+1 to L+M are used to embed watermark bits
% 
% <Outputs>
%   bits: The sequence of bits that has been embeded into the image. It is
%       useful when we want to compare the embedded bits and extracted bits in
%       Monte Carlo simultion
%   imgWmed: watermarked image, converted to uint8. (to simulate quantization)
%
% 
% <Author>
%   Bin Yan, 2013.4.14. yanbinhit@hotmail.com
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

% setup default value for L and M
if nargin == 4
    L = 25000;  % this is the default used in the reference
    M = 16000;
end

% Generate a random binary message
bits = normrnd(0,1,nb,1)>0;

% Generate wateramrk pattern according to seedKey
rng(seedKey);
PN = 2 * (normrnd(0, 1, M, 1)>0) - 1;   % sequence of +/- 1's

% Read image and perform full-frame DCT
[r,c] = size(imgIn);
if (r<256) | ( c<256)
    error('The size of the image should be larger than 256x256');
end

dctMt = dct2(imgIn);

% Reorder the DCT coefficient in a zig-zag scan
T_total = ZigZag(dctMt);

T = T_total(L+1: L+M);
T_hat = zeros(M, 1);   % watermarked coefficients
T_hat = T;

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

% Reinsert the vector T_hat in the zig-zag scan
T_total( L+1 : L+M ) = T_hat;

% Perform inverse scan
dctMtWmed = InvZigZag(T_total, r, c);

% Perform inverse DCT
imgWmed = idct2(dctMtWmed);

% 'Save' the watermarked image and messages
imgWmed = uint8(imgWmed);

if DEBUG == 1
    figure; imshow(imgWmed,[]); title('Watermarked image(DCT domain)');
end

















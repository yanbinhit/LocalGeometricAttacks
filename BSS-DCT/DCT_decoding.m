function  bitErrRate = DCT_decoding(imgIn, nb, k, seedKey, L, M, bitsEmbedded)

% DCT_decoding: Decode multiple bits from a possibly watermarked image in DCT domain 
% 
% <Inputs>
%   img: input image matrix, uint8 format.
%   nb: number of bits embedded. The paper below uses 50-200 bits
%   k:  strength of the embedding
%   seedKey: secret key shared by watermark embedder and detectors. It is a
%       seed to a pseudo random number generator
%   L:  the first L coefficient in the zig-zag scan of the full frame DCT
%       coefficients are skipped. 
%   M:  The M coefficients from L+1 to L+M are used to embed watermark bits
%   bitsEmbedded:  the bits that was embedded into the image. Useful for
%       computing bitErrRate
% 
% <Outputs>
%   bitErrRate: bit error rate 
%
%   The watermarked image is saved as an image file with WMed
%   appended at the end of the name of the file
% 
% <Author>
%   Bin Yan, 2013.4.14. yanbinhit@hotmail.com
%
% <Note>
% This implementation is based on the pseudocodes in the following papers
%
% [1] Angela D' Angelo, Mauro Barni, and Neri Merhav, Stochastic Image Warping
%     for Improved Watermark Desynchronization. EURASIP Journal on Information
%     Security. vol. 2008 
% [2] Angela D' Angelo. Characterization and Quality Evaluation of
%     Geometric Distortion in Images with Applications to Digital Watermarking.
%     Ph.D. thesis. Universiy of Siena. 2009.
%==============================================================================


% Perform full frame DCT
dctMt = dct2(imgIn);

% Reorder the DCT coefficients into a zigzag scan and select middle
% frequency coefficients
T_total = ZigZag(dctMt);
T = T_total(L+1: L+M);

% Generate wateramrk pattern according to seedKey
rng(seedKey);
PN = 2 * (normrnd(0, 1, M, 1)>0) - 1;   % sequence of +/- 1's

% Calculate correlation coefficients for decoding
lenBit = floor(M/nb);   % The length of the subvector that is used to embedd one bit
corCoeff = zeros(nb, 1); 
for bIdx = 1 : nb
    lowerLimit = (bIdx-1)*lenBit + 1;      % lower and upper limit of each segment
    UpperLimit = (bIdx-1)*lenBit + lenBit;
    corCoeff(bIdx) = CalCorrCoeff( T(lowerLimit: UpperLimit), PN(lowerLimit: UpperLimit) );  
end

% decode bits according to the correlation coefficients
bitsDecoded = zeros(nb, 1);
for bIdx = 1 : nb
    if corCoeff(bIdx) > 0 
        bitsDecoded(bIdx) = 0;
    else
        bitsDecoded(bIdx) = 1;
    end
end

bitErrRate = sum(bitsEmbedded ~= bitsDecoded)/nb; 



%==========================================================================
% Calculate the correlation coefficients between two vectors a and b
%==========================================================================
function cc = CalCorrCoeff(a, b)
if length(a) ~= length(b)
    error('The length of the two vectors should be the same');
end
cc = 0;
for i=1:length(a)
    cc = cc + (a(i)-mean(a))*(b(i)-mean(b));
end
cc = cc/(std(a)*std(b));






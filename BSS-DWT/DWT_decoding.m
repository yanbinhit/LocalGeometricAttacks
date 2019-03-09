function bitErrRate = DWT_decoding(imgIn, nb, k, seedKey, bitsEmbedded, DEBUG)

% DWT_decoding: Decode multiple bits from a possibly watermarked image in DWT domain 
% 
% <Inputs>
%   imgIn:  input image matrix.
%   nb:     number of bits embedded. The paper below uses 50-200 bits
%   k:      strength of the embedding
%   seedKey:secret key shared by watermark embedder and detectors. It is a
%           seed to a pseudo random number generator
%   DEBUG:  if DEBUG = 1, then some figures are plotted to show intermediate
%           result.
%
% <Outputs>
%   bitErrRate: bit error rate 
%
% <Author>
%   Bin Yan, 2013.9.22. yanbinhit@hotmail.com
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


% Perform DWT decomposition
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

% Generate wateramrk pattern according to seedKey
rng(seedKey);
PN = 2 * (normrnd(0, 1, M, 1)>0.5) - 1;   % sequence of +/- 1's

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

% calculate and return bit error rate
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








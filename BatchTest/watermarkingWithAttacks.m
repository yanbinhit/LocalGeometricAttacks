function  [BER, Dx, Dy] = watermarkingWithAttacks(imageIn, ... 
                                        wmType,...     
                                        wmParas,...    
                                        attackType,...
                                        attackParas,...
                                        DEBUG)
% Watermark and attack an image (for nbits ranging from 50 to 200)
% <inputs>
%   imageIn: the image matrix to be watermarked and attacked
%   wmType:  can be 'dct', 'dwt'
%   wmParas: parameters needed to perform the watermark embedding and
%               detection
%   attackType: can be 'lpcd', 'clpcd', 'mrf', 'iterative', 'pyramid'
%   attackParas: parameters needed to perform the specified attacks
%   DEBUG: to show the intermediate results, set DEBUG = 1
% <output>
%   BER: bit error rate of the system

%-----------------------------------------------
% Embed watermark
%-----------------------------------------------
switch lower(wmType)
    case 'dct'
        k = wmParas.k;
        seedKey = wmParas.seedKey;
        L = wmParas.L;
        M = wmParas.M;
        nb = wmParas.nb;
        [imgWmed, bitsEmbedded] = DCT_embedding(imageIn, nb, k, seedKey, L, M, DEBUG);
    case 'dwt'
        k = wmParas.k;
        seedKey = wmParas.seedKey;
        nb = wmParas.nb;
        [imgWmed, bitsEmbedded] = DWT_embedding(imageIn, nb, k, seedKey, DEBUG);   
    otherwise
        disp('Unknown watermarking method');
end

%------------------------------------------------
% Geometric attacks
%------------------------------------------------
switch lower(attackType)
    case 'lpcd'
        windowLenLPCD = attackParas.windowLen;
        levelLPCD = attackParas.level;
        [imgAttacked, Dx, Dy, dxLow, dyLow] ...
            = LPCD_outputField( num2str(windowLenLPCD),num2str(levelLPCD),imgWmed,DEBUG);
    case 'clpcd'
        windowLenCLPCD = attackParas.windowLen;
        levelCLPCD = attackParas.level;
        [imgAttacked, Dx, Dy, dxLow, dyLow] ...
            = CLPCD_outputField( num2str(windowLenCLPCD),num2str(levelCLPCD),imgWmed,DEBUG);
    case 'mrf'
        level = num2str(attackParas.level);
        stdev = num2str(attackParas.stdev);
        [imgAttacked, Dx, Dy, dxLow, dyLow] = ...
                                MRF_mod(level, stdev, imgWmed, DEBUG);
    case 'iterative'
        level = attackParas.level;
        window = attackParas.window;
        numIter = attackParas.numIter;
        [imgAttacked,DxOrig, DyOrig, Dx, Dy] = ...
             directSmoothIterative(imgWmed, level, window, numIter, DEBUG);
    case 'pyramid'
        level = attackParas.level;
        window = attackParas.window;
        [imgAttacked, DxOrig, DyOrig, Dx, Dy] = ...
                        directSmoothPyramid(imgWmed, level, window, DEBUG);
    case 'pyramidmrfin'
        level = attackParas.level;
        sigma = attackParas.stdev;
        [imgAttacked, DxOrig, DyOrig, Dx, Dy] = ...
                        directSmoothPyramidMrfIn(imgWmed, level, sigma, DEBUG);
    otherwise
        disp('Unknown attacking method.');
end

%-----------------------------
% Decode watermark
%------------------------------
switch lower(wmType)
    case 'dct'
        k = wmParas.k;
        seedKey = wmParas.seedKey;
        L = wmParas.L;
        M = wmParas.M;
        nb = wmParas.nb;
        BER = DCT_decoding(imgAttacked, nb, k, seedKey, L, M, bitsEmbedded);
    case 'dwt'
        k = wmParas.k;
        seedKey = wmParas.seedKey;
        nb = wmParas.nb;
        BER = DWT_decoding(imgAttacked, nb, k, seedKey, bitsEmbedded, DEBUG);
    otherwise
        disp('Unknown watermarking method');
end


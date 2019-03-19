 %watermarkingWithAttacksTest.m
 close all; clear;
 prevDir = pwd;
[dir, dummy, dummy2] = fileparts(mfilename('fullpath'));
cd(dir); 
 
 imageFileIn = 'zhonglou512gray.bmp';
 imageIn =imread(imageFileIn);
 
 DEBUG = 0;
 wmType = 'dct';  % 'dct' or 'dwt'
 attackType = 'pyramid';   % 'lpcd', 'clpcd', 'mrf', 'iterative', 
                                %'pyramid', 'pyramidMrfIn'
 nb = [50 100 150 200];
 
 %----------------------------------------------
 % parameters for DCT embedding
 %----------------------------------------------
 wmParasDct.k = 5;
 wmParasDct.seedKey =  round(unifrnd(1, 100));
 wmParasDct.L = 25000;
 wmParasDct.M = 16000;
 %wmParasDct.nb will be specified in the loop
 
 %---------------------------------------------
 % Parameter for DWT embedding
 %---------------------------------------------
 wmParasDwt.k = 2;
 wmParasDwt.seedKey = round(unifrnd(1,100));
 %wmParasDwt.nb will be specified in the loop
 
 %---------------------------------------------
 % Parameter for lpcd attacks
 %---------------------------------------------
 attackParasLpcd.windowLen = 7;
 attackParasLpcd.level = 5;
 
 %---------------------------------------------
 % Parameter for clpcd attacks
 %---------------------------------------------
 attackParasClpcd.windowLen = 7;
 attackParasClpcd.level = 5;
 
 %---------------------------------------------
 % Parameter for MRF method
 %---------------------------------------------
 attackParasMrf.level = 6;  % c=(size of image)/(2^(level+1))
 attackParasMrf.stdev = 1;
 
 %----------------------------------------------
 % Parameter for 'iterative' smoothing (no pyramid)
 %-----------------------------------------------
 attackParasIterative.level = 1;
 attackParasIterative.window = 5;
 attackParasIterative.numIter = 20;
 
 %-----------------------------------------------
 % Parameter for 'pyramid' based smoothing
 %-----------------------------------------------
 attackParasPyramid.level = 5;
 attackParasPyramid.window = 5;
 
 
 for i = 1:length(nb)
     % load parameters 
     switch lower(wmType)
         case 'dct'
             wmParas = wmParasDct;
         case 'dwt'
             wmParas = wmParasDwt;
         otherwise
             disp('Unknown watermarking method.');
     end
     switch lower(attackType)
         case 'lpcd'
             attackParas = attackParasLpcd;
         case 'clpcd'
             attackParas = attackParasClpcd;
         case 'mrf'
             attackParas = attackParasMrf;
         case 'iterative'
             attackParas = attackParasIterative;
         case 'pyramid'
             attackParas = attackParasPyramid;
         case 'pyramidmrfin'
             attackParas = attackParasMrf;
         otherwise
             disp('Unknown attacking type.');
     end
     
     wmParas.nb = nb(i);   
     [BER, Dx, Dy]  = watermarkingWithAttacks(imageIn, ...
                                                wmType,...
                                                wmParas,...
                                                attackType,...
                                                attackParas,...
                                                DEBUG);
     ['# of bits = ', num2str(wmParas.nb),',  ', 'BER = ', num2str(BER)]
     
     Dlen = sqrt(Dx.^2 + Dy.^2);
     DlenAvg = mean(Dlen(:));
     DlenStd = std(Dlen(:));
     DlenMax = max(Dlen(:));
     ['average length: ', num2str(DlenAvg), ',  ', 'std: ', num2str(DlenStd),...
            ',  ', 'max: ', num2str(DlenMax)]
     figure; [Nd,Xd] = hist(Dlen(:), 30); bar(Xd, Nd);
 end
     
 


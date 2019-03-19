 %testAttackingEffectOnWatermark.m
 close all; clear;
 DEBUG = 0;
 
prevDir = pwd;
[dir, dummy, dummy2] = fileparts(mfilename('fullpath'));
cd(dir); 
 
% Testing images
addpath([dir  '\TestingImageSet']);
imgFiles{1}.name ='06.png';
imgFiles{2}.name ='07.png';
imgFiles{3}.name ='kejiyuan512.bmp';
imgFiles{4}.name ='roboticcenter512.bmp';
imgFiles{5}.name ='shanhaihuayuan512.bmp';
imgFiles{6}.name ='tushuguan512.bmp';
imgFiles{7}.name ='VerticalStripes.jpg';
imgFiles{8}.name ='yifulou512.bmp';
imgFiles{9}.name ='zhonglou512.bmp';
imgFiles{10}.name ='j1lou512.bmp';
imageFileIn = 'zhonglou512gray.bmp';


nb = [50 100 150 200];

%% DCT watermarking
wmType = 'dct';
resultFile = fopen('resultFileDCT.txt','w');
%----------------------------------------------
 % parameters for DCT embedding
 %----------------------------------------------
 wmParasDct.k = 5;
 wmParasDct.seedKey =  round(unifrnd(1, 100));
 wmParasDct.L = 25000;
 wmParasDct.M = 16000;
 %wmParasDct.nb will be specified in the loop
 
 
 % --------------------------------------------
 % DCT 1: Clpcd attacks
 % --------------------------------------------
 attackType = 'clpcd';
 clpcdParas = [6, 7; 6, 5; 5, 5];
 
 for i = 1:length(nb)
    
     wmParas = wmParasDct; % load parameters for watermarking system
     wmParas.nb = nb(i);
     
     for j = 1: size(clpcdParas,1)
         attackParasClpcd.windowLen = clpcdParas(j,2);
         attackParasClpcd.level = clpcdParas(j,1);
         attackParas = attackParasClpcd;
         
         for k = 1:10 % ten test images
             imageIn = imread(imgFiles{k}.name);
             if size(imageIn,3)>1
                 imageIn = double(rgb2gray(imageIn));
             else
                 imageIn = double(imageIn);
             end
             
             [BER(k), Dx, Dy]  = watermarkingWithAttacks(imageIn, ...
                 wmType,...
                 wmParas,...
                 attackType,...
                 attackParas,...
                 DEBUG);
             gaborMetric(k) = Gabor_metric(imageIn, Dx, Dy, 1);
         end
         
         berAvg = sum(BER)/10;
         gaborAvg = sum(gaborMetric)/10;
         ['nb: ' num2str(nb(i)) ', clpcd: L ' num2str(clpcdParas(j,1)) ', N ', num2str(clpcdParas(j,2)) ', ber ' num2str(berAvg) ', gabor metric ' num2str(gaborAvg)]
         fprintf(resultFile, '%s %d %s %s %d %s %d %s %d %s %d\n', ...
             'nb', nb(i), 'clpcd', 'L',attackParasClpcd.level,...
             'N', attackParasClpcd.windowLen,...
             'BER', berAvg,...
             'GaborMetric', gaborAvg);
     end
 end
 
 
 % --------------------------------------------
 % DCT 2: Attack using pyramid smoothed clpcd field
 % --------------------------------------------
 attackType = 'pyramid';
 clpcdParas = [6, 7; 6, 5; 5, 5];
 
 for i = 1:length(nb)
    
     wmParas = wmParasDct; % load parameters for watermarking system
     wmParas.nb = nb(i);
     
     for j = 1: size(clpcdParas,1)
         attackParasClpcd.window = clpcdParas(j,2);
         attackParasClpcd.level = clpcdParas(j,1);
         attackParas = attackParasClpcd;
         
         for k = 1:10 % ten test images
             imageIn = imread(imgFiles{k}.name);
             if size(imageIn,3)>1
                 imageIn = double(rgb2gray(imageIn));
             else
                 imageIn = double(imageIn);
             end
             
             [BER(k), Dx, Dy]  = watermarkingWithAttacks(imageIn, ...
                 wmType,...
                 wmParas,...
                 attackType,...
                 attackParas,...
                 DEBUG);
             gaborMetric(k) = Gabor_metric(imageIn, Dx, Dy, 1);
         end
         
         berAvg = sum(BER)/10;
         gaborAvg = sum(gaborMetric)/10;
         ['nb: ' num2str(nb(i)) ', pyramid:L ' num2str(clpcdParas(j,1)) ', N ', num2str(clpcdParas(j,2)) ', ber ' num2str(berAvg) ', gabor metric ' num2str(gaborAvg)]
         fprintf(resultFile, '%s %d %s %s %d %s %d %s %d %s %d\n', ...
             'nb', nb(i), 'pyramid', 'L',attackParasClpcd.level,...
             'N', attackParasClpcd.window,...
             'BER', berAvg,...
             'GaborMetric', gaborAvg);
     end
 end
 

 % --------------------------------------------
 % DCT 3: Attack using MRF generated fields
 % --------------------------------------------
 attackType = 'mrf';
 mrfParas = [ 6, 1; 5, 3];
    
 for i = 1:length(nb)
    
     wmParas = wmParasDct; % load parameters for watermarking system
     wmParas.nb = nb(i);
     
     for j = 1: size(mrfParas,1)
         attackParasMrf.stdev = mrfParas(j,2);
         attackParasMrf.level = mrfParas(j,1);
         attackParas = attackParasMrf;
         
         numImgs = 10
         for k = 1:numImgs % ten test images
             imageIn = imread(imgFiles{k}.name);
             if size(imageIn,3)>1
                 imageIn = double(rgb2gray(imageIn));
             else
                 imageIn = double(imageIn);
             end
             
             [BER(k), Dx, Dy]  = watermarkingWithAttacks(imageIn, ...
                 wmType,...
                 wmParas,...
                 attackType,...
                 attackParas,...
                 DEBUG);
             gaborMetric(k) = Gabor_metric(imageIn, Dx, Dy, 1);
         end
         
         berAvg = sum(BER)/numImgs;
         gaborAvg = sum(gaborMetric)/numImgs;
         ['nb: ' num2str(nb(i)) ', mrf:L ' num2str(mrfParas(j,1)) ',N ', num2str(mrfParas(j,2)) ', ber ' num2str(berAvg) ', gabor metric ' num2str(gaborAvg)]
         fprintf(resultFile, '%s %d %s %s %d %s %d %s %d %s %d\n', ...
             'nb', nb(i), 'mrf', 'L',attackParasMrf.level,...
             'stdev', attackParasMrf.stdev,...
             'BER', berAvg,...
             'GaborMetric', gaborAvg);
     end
 end
 
 % --------------------------------------------
 % DCT 4: Attack using pyramid smoothed MRF fields
 % --------------------------------------------
 attackType = 'pyramidMrfIn';
 mrfParas = [ 6, 1; 5, 3];
    
 for i = 1:length(nb)
    
     wmParas = wmParasDct; % load parameters for watermarking system
     wmParas.nb = nb(i);
     
     for j = 1: size(mrfParas,1)
         attackParasMrf.stdev = mrfParas(j,2);
         attackParasMrf.level = mrfParas(j,1);
         attackParas = attackParasMrf;
         
         for k = 1:10 % ten test images
             imageIn = imread(imgFiles{k}.name);
             if size(imageIn,3)>1
                 imageIn = double(rgb2gray(imageIn));
             else
                 imageIn = double(imageIn);
             end
             
             [BER(k), Dx, Dy]  = watermarkingWithAttacks(imageIn, ...
                 wmType,...
                 wmParas,...
                 attackType,...
                 attackParas,...
                 DEBUG);
             
             gaborMetric(k) = Gabor_metric(imageIn, Dx, Dy, 1);
         end
         
         berAvg = sum(BER)/10;
         gaborAvg = sum(gaborMetric)/10;
         ['nb: ' num2str(nb(i)) ', pyramidMrfIn: L ' num2str(mrfParas(j,1)) ', N ', num2str(mrfParas(j,2)) ', ber ' num2str(berAvg) ', gabor metric ' num2str(gaborAvg)]
         fprintf(resultFile, '%s %d %s %s %d %s %d %s %d %s %d\n', ...
             'nb', nb(i), 'pyramidMrfIn', 'L',attackParasMrf.level,...
             'stdev', attackParasMrf.stdev,...
             'BER', berAvg,...
             'GaborMetric', gaborAvg);
     end
 end
 
 fclose(resultFile); % close this file after testing DCT watermark
  
 

%===============================================================
% DWT watermarking
%================================================================
wmType = 'dwt';
resultFile = fopen('resultFileDWT.txt','w');
%---------------------------------------------
%Parameter for DWT embedding
%---------------------------------------------
 wmParasDwt.k = 2;
 wmParasDwt.seedKey = round(unifrnd(1,100));
 %wmParasDwt.nb will be specified in the loop
 
 % --------------------------------------------
 % DWT 1: Clpcd attacks
 % --------------------------------------------
 attackType = 'clpcd';
 clpcdParas = [6, 7; 6, 5; 5, 5]; 
 
 for i = 1:length(nb)
    
     wmParas = wmParasDwt; % load parameters for watermarking system
     wmParas.nb = nb(i);
     
     for j = 1: size(clpcdParas,1)
         attackParasClpcd.windowLen = clpcdParas(j,2);
         attackParasClpcd.level = clpcdParas(j,1);
         attackParas = attackParasClpcd;
         
         for k = 1:10 % ten test images
             imageIn = imread(imgFiles{k}.name);
             if size(imageIn,3)>1
                 imageIn = double(rgb2gray(imageIn));
             else
                 imageIn = double(imageIn);
             end
             
             [BER(k), Dx, Dy]  = watermarkingWithAttacks(imageIn, ...
                 wmType,...
                 wmParas,...
                 attackType,...
                 attackParas,...
                 DEBUG);
             gaborMetric(k) = Gabor_metric(imageIn, Dx, Dy, 1);
         end
         
         berAvg = sum(BER)/10;
         gaborAvg = sum(gaborMetric)/10;
         ['nb: ' num2str(nb(i)) ', clpcd: L ' num2str(clpcdParas(j,1)) ', N ', num2str(clpcdParas(j,2)) ', ber ' num2str(berAvg) ', gabor metric ' num2str(gaborAvg)]
         fprintf(resultFile, '%s %d %s %s %d %s %d %s %d %s %d\n', ...
             'nb', nb(i), 'clpcd', 'L',attackParasClpcd.level,...
             'N', attackParasClpcd.windowLen,...
             'BER', berAvg,...
             'GaborMetric', gaborAvg);
     end
 end
 
 
 % --------------------------------------------
 % DWT 2: Attack using pyramid smoothed clpcd field
 % --------------------------------------------
 attackType = 'pyramid';
 clpcdParas =[6, 7; 6, 5; 5, 5];
 
 for i = 1:length(nb)
    
     wmParas = wmParasDwt; % load parameters for watermarking system
     wmParas.nb = nb(i);
     
     for j = 1: size(clpcdParas,1)
         attackParasClpcd.window = clpcdParas(j,2);
         attackParasClpcd.level = clpcdParas(j,1);
         attackParas = attackParasClpcd;
         
         for k = 1:10 % ten test images
             imageIn = imread(imgFiles{k}.name);
             if size(imageIn,3)>1
                 imageIn = double(rgb2gray(imageIn));
             else
                 imageIn = double(imageIn);
             end
             
             [BER(k), Dx, Dy]  = watermarkingWithAttacks(imageIn, ...
                 wmType,...
                 wmParas,...
                 attackType,...
                 attackParas,...
                 DEBUG);
             gaborMetric(k) = Gabor_metric(imageIn, Dx, Dy, 1);
             %[BER(k) gaborMetric(k)]
         end
         
         berAvg = sum(BER)/10;
         gaborAvg = sum(gaborMetric)/10;
         ['nb: ' num2str(nb(i)) ', pyramid: L ' num2str(clpcdParas(j,1)) ', N ', num2str(clpcdParas(j,2)) ', ber ' num2str(berAvg) ', gabor metric ' num2str(gaborAvg)]
         fprintf(resultFile, '%s %d %s %s %d %s %d %s %d %s %d\n', ...
             'nb', nb(i), 'pyramid', 'L',attackParasClpcd.level,...
             'N', attackParasClpcd.window,...
             'BER', berAvg,...
             'GaborMetric', gaborAvg);
     end
 end
 
 

 % --------------------------------------------
 % DWT 3: Attack using MRF generated fields
 % --------------------------------------------
 attackType = 'mrf';
 mrfParas = [ 6, 1; 5, 3];
    
 for i = 1:length(nb)
    
     wmParas = wmParasDwt; % load parameters for watermarking system
     wmParas.nb = nb(i);
     
     for j = 1: size(mrfParas,1)
         attackParasMrf.stdev = mrfParas(j,2);
         attackParasMrf.level = mrfParas(j,1);
         attackParas = attackParasMrf;
         
         for k = 1:10 % ten test images
             imageIn = imread(imgFiles{k}.name);
             if size(imageIn,3)>1
                 imageIn = double(rgb2gray(imageIn));
             else
                 imageIn = double(imageIn);
             end
             
             [BER(k), Dx, Dy]  = watermarkingWithAttacks(imageIn, ...
                 wmType,...
                 wmParas,...
                 attackType,...
                 attackParas,...
                 DEBUG);
             gaborMetric(k) = Gabor_metric(imageIn, Dx, Dy, 1);
             %[BER(k) gaborMetric(k)]
         end
         
         berAvg = sum(BER)/10;
         gaborAvg = sum(gaborMetric)/10;
         ['nb: ' num2str(nb(i)) ', mrf: L ' num2str(mrfParas(j,1)) ', N ', num2str(mrfParas(j,2)) ', ber ' num2str(berAvg) ', gabor metric ' num2str(gaborAvg)]
         fprintf(resultFile, '%s %d %s %s %d %s %d %s %d %s %d\n', ...
             'nb', nb(i), 'mrf', 'L',attackParasMrf.level,...
             'stdev', attackParasMrf.stdev,...
             'BER', berAvg,...
             'GaborMetric', gaborAvg);
     end
 end
 
 % --------------------------------------------
 % DWT 4: Attack using pyramid smoothed MRF fields
 % --------------------------------------------
 attackType = 'pyramidMrfIn';
 mrfParas = [ 6, 1; 5, 3];
    
 for i = 1:length(nb)
    
     wmParas = wmParasDwt; % load parameters for watermarking system
     wmParas.nb = nb(i);
     
     for j = 1: size(mrfParas,1)
         attackParasMrf.stdev = mrfParas(j,2);
         attackParasMrf.level = mrfParas(j,1);
         attackParas = attackParasMrf;
         
         for k = 1:10 % ten test images
             imageIn = imread(imgFiles{k}.name);
             if size(imageIn,3)>1
                 imageIn = double(rgb2gray(imageIn));
             else
                 imageIn = double(imageIn);
             end
             
             [BER(k), Dx, Dy]  = watermarkingWithAttacks(imageIn, ...
                 wmType,...
                 wmParas,...
                 attackType,...
                 attackParas,...
                 DEBUG);
             gaborMetric(k) = Gabor_metric(imageIn, Dx, Dy, 1);
             [BER(k) gaborMetric(k)]
         end
         
         berAvg = sum(BER)/10;
         gaborAvg = sum(gaborMetric)/10;
         ['nb: ' num2str(nb(i)) ', pyramidMrfIn: L ' num2str(mrfParas(j,1)) ', N ', num2str(mrfParas(j,2)) ', ber ' num2str(berAvg) ', gabor metric ' num2str(gaborAvg)]
         fprintf(resultFile, '%s %d %s %s %d %s %d %s %d %s %d\n', ...
             'nb', nb(i), 'pyramidMrfIn', 'L',attackParasMrf.level,...
             'stdev', attackParasMrf.stdev,...
             'BER', berAvg,...
             'GaborMetric', gaborAvg);
     end
 end
 
 fclose(resultFile); % close this file after testing DWT watermark
  
 
% testAttackingEffectOnWatermarkPlotResult.m
% Plot the result of testAttackingEffectOnWatermark.m
close all; clear;
prevDir = pwd;
[dir, dummy, dummy2] = fileparts(mfilename('fullpath'));
cd(dir);  

nb = [50, 100, 150, 200];
%----------------------------------------------------
% For DCT watermarking, 
% plot two figures: BER before and after smoothing.
%----------------------------------------------------
resultFileDct = fopen('resultFileDCT_1.txt','r');
dataReadDct = textscan(resultFileDct, '%s %d %s %s %d %s %d %s %f %s %f');
fclose(resultFileDct);

%----------------no smoothing---------------------------------
%clpcd L = 6, N = 7
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'clpcd') & (dataReadDct{5}==6) & (dataReadDct{7}==7) )
metricClpcd67 = dataReadDct{11}(strcmp(dataReadDct{3},'clpcd') & (dataReadDct{5}==6) & (dataReadDct{7}==7) )
legend67 = strcat('CLPCD: L=6, W=7, Gabor=',num2str(mean(metricClpcd67)));
figure(1); subplot(1,2,1);
plot(nb, berClpcd, 'r-d', 'LineWidth', 2); hold on;
figure(11); hold on; scatter(metricClpcd67, berClpcd, 'rd');

% clpcd L = 6, N =5
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'clpcd') & (dataReadDct{5}==6) & (dataReadDct{7}==5) )
metricClpcd65 = dataReadDct{11}(strcmp(dataReadDct{3},'clpcd') & (dataReadDct{5}==6) & (dataReadDct{7}==5) )
legend65 = strcat('CLPCD: L=6, W=5, Gabor=',num2str(mean(metricClpcd65)));
figure(1); subplot(1,2,1);
plot(nb, berClpcd, 'b:d', 'LineWidth', 2); 
figure(11); hold on; scatter(metricClpcd65, berClpcd, 'bd');

% clpcd L = 5, N =5
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'clpcd') & (dataReadDct{5}==5) & (dataReadDct{7}==5) )
metricClpcd55 = dataReadDct{11}(strcmp(dataReadDct{3},'clpcd') & (dataReadDct{5}==5) & (dataReadDct{7}==5) )
legend55 = strcat('CLPCD: L=5, W=5, Gabor=',num2str(mean(metricClpcd55)));
figure(1); subplot(1,2,1);
plot(nb, berClpcd, 'k--d', 'LineWidth', 2); 
figure(11); hold on; scatter(metricClpcd55, berClpcd, 'kd');

% mrf: L= 6, sigma = 1
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'mrf') & (dataReadDct{5}==6) & (dataReadDct{7}==1) )
metricClpcd61 = dataReadDct{11}(strcmp(dataReadDct{3},'mrf') & (dataReadDct{5}==6) & (dataReadDct{7}==1) )
legend61 = strcat('MRF: L=6, \sigma=1, Gabor=',num2str(mean(metricClpcd61)));
figure(1); subplot(1,2,1);
plot(nb, berClpcd, 'k--*', 'LineWidth', 2); 
figure(11); hold on; scatter(metricClpcd61, berClpcd, 'k*')

% mrf: L= 5, sigma = 3
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'mrf') & (dataReadDct{5}==5) & (dataReadDct{7}==3) )
metricClpcd53 = dataReadDct{11}(strcmp(dataReadDct{3},'mrf') & (dataReadDct{5}==5) & (dataReadDct{7}==3) )
legend53 = strcat('MRF: L=5, \sigma=3, Gabor=',num2str(mean(metricClpcd53)));

figure(1); subplot(1,2,1);
plot(nb, berClpcd, 'b-*', 'LineWidth', 2); 
ylabel('BER');
xlabel('Number of embedded bits');
legend(legend67, legend65, legend55, legend61, legend53);
grid on;
ylim([10^-2, 1]);

figure(11); hold on; scatter(metricClpcd53, berClpcd, 'b*')
%-------------------after smoothing----------------------
%pyramid L = 6, N = 7
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'pyramid') & (dataReadDct{5}==6) & (dataReadDct{7}==7) )
metricClpcd67 = dataReadDct{11}(strcmp(dataReadDct{3},'pyramid') & (dataReadDct{5}==6) & (dataReadDct{7}==7) )
legend67 = strcat('CLPCD: L=6, W=7, Gabor=',num2str(mean(metricClpcd67)));

figure(1); subplot(1,2,2);
plot(nb, berClpcd, 'r-d', 'LineWidth', 2); hold on;
figure(11); hold on; scatter(metricClpcd67, berClpcd, 'rd');

% clpcd L = 6, N =5
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'pyramid') & (dataReadDct{5}==6) & (dataReadDct{7}==5) )
metricClpcd65 = dataReadDct{11}(strcmp(dataReadDct{3},'pyramid') & (dataReadDct{5}==6) & (dataReadDct{7}==5) )
legend65 = strcat('CLPCD: L=6, W=5, Gabor=',num2str(mean(metricClpcd65)));
figure(1); subplot(1,2,2);
plot(nb, berClpcd, 'b:d', 'LineWidth', 2); 
figure(11); hold on; scatter(metricClpcd65, berClpcd, 'bd');

% clpcd L = 5, N =5
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'pyramid') & (dataReadDct{5}==5) & (dataReadDct{7}==5) )
metricClpcd55 = dataReadDct{11}(strcmp(dataReadDct{3},'pyramid') & (dataReadDct{5}==5) & (dataReadDct{7}==5) )
legend55 = strcat('CLPCD: L=5, W=5, Gabor=',num2str(mean(metricClpcd55)));
figure(1); subplot(1,2,2);
plot(nb, berClpcd, 'k--d', 'LineWidth', 2); 
figure(11); hold on; scatter(metricClpcd55, berClpcd, 'kd');

% mrf: L= 6, sigma = 1
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'pyramidMrfIn') & (dataReadDct{5}==6) & (dataReadDct{7}==1) )
metricClpcd61 = dataReadDct{11}(strcmp(dataReadDct{3},'pyramidMrfIn') & (dataReadDct{5}==6) & (dataReadDct{7}==1) )
legend61 = strcat('MRF: L=6, \sigma=1, Gabor=',num2str(mean(metricClpcd61)));
figure(1); subplot(1,2,2);
plot(nb, berClpcd, 'k--*', 'LineWidth', 2); 
figure(11); hold on; scatter(metricClpcd61, berClpcd, 'k*');

% mrf: L= 5, sigma = 3
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'pyramidMrfIn') & (dataReadDct{5}==5) & (dataReadDct{7}==3) )
metricClpcd53 = dataReadDct{11}(strcmp(dataReadDct{3},'pyramidMrfIn') & (dataReadDct{5}==5) & (dataReadDct{7}==3) )
legend53 = strcat('MRF: L=5, \sigma=3, Gabor=',num2str(mean(metricClpcd53)));
figure(1); subplot(1,2,2);
plot(nb, berClpcd, 'b-*', 'LineWidth', 2); 
ylabel('BER');
xlabel('Number of embedded bits');
legend(legend67, legend65, legend55, legend61, legend53);
grid on;
ylim([10^-2, 1]);
figure(1); subplot(1,2,1);title('DCT');subplot(1,2,2);title('DCT');
figure(11); hold on; scatter(metricClpcd53, berClpcd, 'b*');

%-----------------------------------------------------
%----------------------------------------------------
% For DWT watermarking, 
% plot two figures: BER before and after smoothing.
%----------------------------------------------------
resultFileDct = fopen('resultFileDWT_1.txt','r');
dataReadDct = textscan(resultFileDct, '%s %d %s %s %d %s %d %s %f %s %f');
fclose(resultFileDct);

%----------------no smoothing---------------------------------
%clpcd L = 6, N = 7
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'clpcd') & (dataReadDct{5}==6) & (dataReadDct{7}==7) )
metricClpcd67 = dataReadDct{11}(strcmp(dataReadDct{3},'clpcd') & (dataReadDct{5}==6) & (dataReadDct{7}==7) )
legend67 = strcat('CLPCD: L=6, W=7, Gabor=',num2str(mean(metricClpcd67)));
figure(2); subplot(1,2,1);
plot(nb, berClpcd, 'r-d', 'LineWidth', 2); hold on;
figure(12); hold on; scatter(metricClpcd67, berClpcd, 'rd');

% clpcd L = 6, N =5
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'clpcd') & (dataReadDct{5}==6) & (dataReadDct{7}==5) )
metricClpcd65 = dataReadDct{11}(strcmp(dataReadDct{3},'clpcd') & (dataReadDct{5}==6) & (dataReadDct{7}==5) )
legend65 = strcat('CLPCD: L=6, W=5, Gabor=',num2str(mean(metricClpcd65)));
figure(2); subplot(1,2,1);
plot(nb, berClpcd, 'b:d', 'LineWidth', 2); 
figure(12); hold on; scatter(metricClpcd65, berClpcd, 'bd');

% clpcd L = 5, N =5
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'clpcd') & (dataReadDct{5}==5) & (dataReadDct{7}==5) )
metricClpcd55 = dataReadDct{11}(strcmp(dataReadDct{3},'clpcd') & (dataReadDct{5}==5) & (dataReadDct{7}==5) )
legend55 = strcat('CLPCD: L=5, W=5, Gabor=',num2str(mean(metricClpcd55)));
figure(2); subplot(1,2,1);
plot(nb, berClpcd, 'k--d', 'LineWidth', 2); 
figure(12); hold on; scatter(metricClpcd55, berClpcd, 'kd');

% mrf: L= 6, sigma = 1
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'mrf') & (dataReadDct{5}==6) & (dataReadDct{7}==1) )
metricClpcd61 = dataReadDct{11}(strcmp(dataReadDct{3},'mrf') & (dataReadDct{5}==6) & (dataReadDct{7}==1) )
legend61 = strcat('MRF: L=6, \sigma=1, Gabor=',num2str(mean(metricClpcd61)));
figure(2); subplot(1,2,1);
plot(nb, berClpcd, 'k--*', 'LineWidth', 2); 
figure(12); hold on; scatter(metricClpcd61, berClpcd, 'k*')

% mrf: L= 5, sigma = 3
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'mrf') & (dataReadDct{5}==5) & (dataReadDct{7}==3) )
metricClpcd53 = dataReadDct{11}(strcmp(dataReadDct{3},'mrf') & (dataReadDct{5}==5) & (dataReadDct{7}==3) )
legend53 = strcat('MRF: L=5, \sigma=3, Gabor=',num2str(mean(metricClpcd53)));

figure(2); subplot(1,2,1);
plot(nb, berClpcd, 'b-*', 'LineWidth', 2); 
ylabel('BER');
xlabel('Number of embedded bits');
legend(legend67, legend65, legend55, legend61, legend53);
grid on;
ylim([10^-2, 1]);

figure(12); hold on; scatter(metricClpcd53, berClpcd, 'b*')
%-------------------after smoothing----------------------
%pyramid L = 6, N = 7
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'pyramid') & (dataReadDct{5}==6) & (dataReadDct{7}==7) )
metricClpcd67 = dataReadDct{11}(strcmp(dataReadDct{3},'pyramid') & (dataReadDct{5}==6) & (dataReadDct{7}==7) )
legend67 = strcat('CLPCD: L=6, W=7, Gabor=',num2str(mean(metricClpcd67)));

figure(2); subplot(1,2,2);
plot(nb, berClpcd, 'r-d', 'LineWidth', 2); hold on;
figure(12); hold on; scatter(metricClpcd67, berClpcd, 'rd');

% clpcd L = 6, N =5
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'pyramid') & (dataReadDct{5}==6) & (dataReadDct{7}==5) )
metricClpcd65 = dataReadDct{11}(strcmp(dataReadDct{3},'pyramid') & (dataReadDct{5}==6) & (dataReadDct{7}==5) )
legend65 = strcat('CLPCD: L=6, W=5, Gabor=',num2str(mean(metricClpcd65)));
figure(2); subplot(1,2,2);
plot(nb, berClpcd, 'b:d', 'LineWidth', 2); 
figure(12); hold on; scatter(metricClpcd65, berClpcd, 'bd');

% clpcd L = 5, N =5
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'pyramid') & (dataReadDct{5}==5) & (dataReadDct{7}==5) )
metricClpcd55 = dataReadDct{11}(strcmp(dataReadDct{3},'pyramid') & (dataReadDct{5}==5) & (dataReadDct{7}==5) )
legend55 = strcat('CLPCD: L=5, W=5, Gabor=',num2str(mean(metricClpcd55)));
figure(2); subplot(1,2,2);
plot(nb, berClpcd, 'k--d', 'LineWidth', 2); 
figure(12); hold on; scatter(metricClpcd55, berClpcd, 'kd');

% mrf: L= 6, sigma = 1
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'pyramidMrfIn') & (dataReadDct{5}==6) & (dataReadDct{7}==1) )
metricClpcd61 = dataReadDct{11}(strcmp(dataReadDct{3},'pyramidMrfIn') & (dataReadDct{5}==6) & (dataReadDct{7}==1) )
legend61 = strcat('MRF: L=6, \sigma=1, Gabor=',num2str(mean(metricClpcd61)));
figure(2); subplot(1,2,2);
plot(nb, berClpcd, 'k--*', 'LineWidth', 2); 
figure(12); hold on; scatter(metricClpcd61, berClpcd, 'k*');

% mrf: L= 5, sigma = 3
berClpcd= dataReadDct{9}(strcmp(dataReadDct{3},'pyramidMrfIn') & (dataReadDct{5}==5) & (dataReadDct{7}==3) )
metricClpcd53 = dataReadDct{11}(strcmp(dataReadDct{3},'pyramidMrfIn') & (dataReadDct{5}==5) & (dataReadDct{7}==3) )
legend53 = strcat('MRF: L=5, \sigma=3, Gabor=',num2str(mean(metricClpcd53)));
figure(2); subplot(1,2,2);
plot(nb, berClpcd, 'b-*', 'LineWidth', 2); 
ylabel('BER');
xlabel('Number of embedded bits');
legend(legend67, legend65, legend55, legend61, legend53);
grid on;
ylim([10^-2, 1]);
figure(2); subplot(1,2,1);title('DWT');subplot(1,2,2);title('DWT');
figure(12); hold on; scatter(metricClpcd53, berClpcd, 'b*');

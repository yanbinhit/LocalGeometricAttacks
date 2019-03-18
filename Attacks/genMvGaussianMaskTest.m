function genMvGaussianMaskTest()
% Testing script for the function genMvGaussianMask


clear all; close all;
%===============================
%  Case #1
%===============================
% The weighting matrix is an identity matrix
winWidth = 10;
[px,py] = meshgrid(-winWidth:0.5:winWidth, -winWidth:0.5:winWidth);
mu = [0; 0];
varD = 9;
weightingMatrix = eye(2)* (1/varD);
mask = genMvGaussianMask(px, py, mu, weightingMatrix);
figure;
mesh(px, py, mask);
myColorMap = [0 0 0];
colormap(jet);
title('isotrpoic Gaussian mask')
figure;
[c,h] = contour(mask); clabel(c,h), colorbar;
title('isotrpoic Gaussian mask')

%=================================
% Case #2: anisotropic 
%=================================
% anisotropic structure tensor: tensor matrix is constructed from
% eigen-value decomposition
alpha = 8
D = [1/alpha,0;0,alpha];
varD = 1;
theta =  pi/4;      % angle degree = 45 w.r.t. the positive x direction
T_theta = [cos(theta), -sin(theta); sin(theta), cos(theta)];
weightingMatrix = T_theta * D * T_theta' .* 1/varD;
mu = [0 0]';
winWidth = 1;
[px,py] = meshgrid(-winWidth:0.1:winWidth, -winWidth:0.1:winWidth);
mask = genMvGaussianMask(px, py, mu, weightingMatrix);
figure;
mesh(px, py, mask);
myColorMap = [0 0 0];
colormap(jet);
title('Anisotrpoic Gaussian mask');
grid on;

figure;
[c,h] = contour(px, py, mask./(max(max(mask))), 5); clabel(c,h), colorbar;
title('Anisotrpoic Gaussian mask');
grid on;

% plot the sites
for i = -1 : 1
    for j = -1 : 1
        hold on; plot(i,j,'o','MarkerFaceColor','r');
    end
end
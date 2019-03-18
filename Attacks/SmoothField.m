function [DxHat, DyHat] = SmoothField(Dx, Dy, OrientMap, Coherence)
%===========================================================================
% Smooth the displacement field according to the orientation map. Smooth
% only the component along the edge direction ( the max eigenvalue
% direction )
% 
% <inputs>
%   Dx: Displacement field along the x direction (horizontal or first dim)
%   Dy: Displacement field along the y direction (vertical or second dim)
%   OrientMap: Orientation map obtained from the input image，
%       以方向向量表示，每个像素上的方向向量用一个复数表示，实部表示x分量，
%       虚部表示y分量。
%       指向灰度变化最大的方向（边缘方向）
%   Coherence: a quantity between 0 and 1, with 1 indicating coherence
%           local structure, ex. simple neighbourhood
%
% <outputs>
%   DxHat: Smoothed displacement field along the x direction
%   DyHat: Smoothed displacement field along the y direction
%
% <author>
%   Bin Yan. 2013.4.4  
%==========================================================================

% Important parameters
sigma = 2;   % sigma used in Gaussian filter kernel
sizeWin = 7; % should be an odd number, ex: 3, 5, 7, 9.
halfSizeWin = floor(sizeWin/2);

% check if the size of Dx, Dy and OrientMap are the same
% omitted for the moment

[nRows, nCols] = size(Dx);
% DxHat = zeros(nRows, nCols);
% DyHat = zeros(nRows, nCols);
% filterMask =  fspecial('gaussian', sizeWin, sigma);  % 各向同性高斯滤波器核
Dx = padarray(Dx, [halfSizeWin halfSizeWin], 'replicate', 'both');
Dy = padarray(Dy, [halfSizeWin halfSizeWin], 'replicate', 'both');
DxHat = zeros(size(Dx));
DyHat = zeros(size(Dy));

for i = (halfSizeWin+1) : (nRows+halfSizeWin)        
    for j = (halfSizeWin+1) : (nCols + halfSizeWin)    
        % 如果Dx， Dy方向都没有位移，则不必平滑，设为零
        if (abs(Dx(i,j)) < eps) &  (abs(Dy(i,j)) < eps)
            DxHat(i,j) = 0; 
            DyHat(i,j) = 0; 
        end
        
        % 以窗口中心(i,j)的局部方向为坐标轴，的将窗口内的位移矢量场沿两个方向
        % 分解，平滑沿边缘方向的分量
        
        % 取一个小窗口内的位移场。
        dxPatch = zeros(sizeWin, sizeWin);
        dyPatch = zeros(sizeWin, sizeWin);
        for k = -halfSizeWin: halfSizeWin
            for l = -halfSizeWin: halfSizeWin
                dxPatch(k+halfSizeWin+1, l+halfSizeWin+1) = Dx(i+k, j+l);
                dyPatch(k+halfSizeWin+1, l+halfSizeWin+1) = Dy(i+k, j+l);
            end
        end
        ip = i - halfSizeWin;
        jp = j - halfSizeWin;
        % 方向平滑
        filterMask = genAnisotropicGaussMask(sizeWin, sigma, ...
                                             OrientMap(ip,jp), Coherence(ip,jp)); 
                                                      % 产生各向异性高斯核
        [DxHat(i,j), DyHat(i,j)] = ...
            averageVecFieldDirection(dxPatch, dyPatch, OrientMap(ip,jp), ...
                                        Coherence(ip,jp), filterMask);
        
    end
end
DxHat = DxHat((halfSizeWin+1) : (nRows+halfSizeWin), (halfSizeWin+1) : (nCols + halfSizeWin));
DyHat = DyHat((halfSizeWin+1) : (nRows+halfSizeWin), (halfSizeWin+1) : (nCols + halfSizeWin));
end

%======================================================================
% 子程序：产生各向异性高斯核
%======================================================================
function mask = genAnisotropicGaussMask(sizeWin, sigma, orient, c)
% c: coherence
winSizeHalf = floor(sizeWin/2);
varD = sigma^2;
alpha = 1/3;  % alpha =1 将椭圆偏心率设为4，alpha = 1/2,将椭圆偏心率设为9.
ve = [ real(orient);imag(orient)]; % edge direction
if ve(2)<0    % 角度修正在［0, pi] 之间
    ve(1) = -ve(1);
    ve(2) = -ve(2);
end
vf = [-imag(orient); real(orient)];% flow direction
if vf(2) <0
    vf(1) = -vf(1);
    vf(2) = -vf(2);
end

Ad = (1/varD) .* [ve vf] * diag([((alpha+c)/alpha)^2, (alpha/(alpha+c))^2]) ...
    * [ve vf]';  % 加权矩阵 (not covariance matrix!!)
mu = [0; 0];
[px,py] = meshgrid(-winSizeHalf:1:winSizeHalf, -winSizeHalf:1:winSizeHalf);
mask = genMvGaussianMask(px, py, mu, Ad);
% normalize the mask
mask = mask ./(sum(sum(mask)));
end

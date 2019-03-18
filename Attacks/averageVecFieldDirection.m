function [DxHat, DyHat] = averageVecFieldDirection(Dx, Dy, Orient, Coherence, filterMask)
%===========================================================================================
% averageVecFildDirection: 使用滤波器filterMask 对沿着 Orient 方向的分量滤波， 
%                          保持垂直Orient方向的分量不变
% 返回：窗口中心值。
% 注： 本函数与SmoothField.m不同，本函数只针对一块（patch)数据。
%
% <inputs>
%   Dx: a patch of the displacement field along the x direction
%   Dy: a patch of the displacement field along the y direction
%   Orient: a complex number representing a unit vector, i.e., the
%       orientation vector (along the edge direction, i.e. the direction of
%       max change
%   filterMask: smoothing kernel used to smooth the displacement field
%          along the edge direction
%   Coherence: coherence measure of local neighbour, [0,1] 
%
% <outputs>
%   DxHat: smoothed displacement along x direction at the center of the
%           patch
%   DyHat: smoothed displacement along y direction at the center of the
%           patch
%
% <author>
%   Bin Yan, 2013. 4. 13 Created.
% 
% <modification>
%   1. (2013.4.20) 增加coherence，对于coherence 高的部分才需要平滑，coherence 低的部分暂不需要平滑
%============================================================================================
CoherenceThr = 0;  % 0: 不考虑一致性的影响， 0.5： 常用值，考虑一致性的影响。

patSize = size(filterMask, 1); % size of patch is =  patSize x patSize

% 如果coherence measure 较小，则本块不需要平滑，返回窗口中心处的位移向量
if Coherence <= CoherenceThr
    DxHat = Dx( floor(patSize/2)+1,floor(patSize/2)+1 );
    DyHat = Dy( floor(patSize/2)+1,floor(patSize/2)+1 );
    return;
end
%==========================================================================
% STEP#1: 将块中的每个displacement矢量分解为沿orient方向和垂直orient方向的分量
%==========================================================================
Dp = zeros(patSize, patSize);
Do = zeros(patSize, patSize);

Or = real(Orient); % 边缘的方向，将其修正为[0, pi]之间
Oi = imag(Orient);
if Oi < 0 
    Oi = -Oi;
    Or = -Or;
end

for i=1:patSize
    for j=1:patSize
        Dp(i,j) = Dx(i,j)* Or + Dy(i,j) * Oi;
        
        % 获得local orientation (v,u),i.e.,与Orient正交的方向(即：flow direction)
        % 并将夹角修正为[0, pi]之间。
        v = - Oi;
        u = Or;
        if (u<0)
            v = -v;
            u = -u;
        end
        
        Do(i,j) = Dx(i,j)* v + Dy(i,j) * u;
    end
end

%====================================================================
% STEP#2: 平滑Dp分量，即平滑沿着边缘方向的分量，对正交方向的分量不作变化
%====================================================================
filterMask = filterMask ./ (sum(sum(filterMask)));
DpHat = sum(sum(filterMask .* Dp));
%DpHat = 0; % 去掉边缘方向的位移。
DoHat = Do(floor(patSize/2)+1,floor(patSize/2)+1);

% % 调试用：不做任何平滑，分解后直接重建。
%  DpHat = Dp(floor(patSize/2)+1,floor(patSize/2)+1);
%  DoHat = Do(floor(patSize/2)+1,floor(patSize/2)+1);


%====================================================================
% STEP #3: 重构x方向和y方向的位移场
%====================================================================
DxHat = DpHat * Or + DoHat * v;
DyHat = DpHat * Oi + DoHat * u;

% % 调试用，不做平滑，直接用输入的位移场
% DxHat = Dx(floor(patSize/2)+1,floor(patSize/2)+1);
% DyHat = Dy(floor(patSize/2)+1,floor(patSize/2)+1);


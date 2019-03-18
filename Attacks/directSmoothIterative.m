function  [attackedImg,Dx, Dy, DxHat, DyHat] = ...
    directSmoothIterative(imageIn, level, window, numIter, debug)

downsmpFactor =1;   % 用于显示local orientation 用的下采样间隔

% Deal with color image.
if size(imageIn,3)>1
    imageInGray = double(rgb2gray(imageIn));
    imageInColor = imageIn;
else
    imageInGray = double(imageIn);
end

[attackedImageNoSmooth, Dx, Dy, DxLow, DyLow] ...
    = CLPCD_outputField(num2str(window),num2str(level),imageInGray, debug); % Produce attacked image and displacement field （before smoothing）.

% Generate low resolution image 
imgPyramid = genLowResolutionImg(imageInGray,level , [5 5], 1.6);
imgLow = imgPyramid(level+1).img;

% Obtain structure information
[OrientMap, Coherence] ...
    = BlkSVDOrientDense(imgLow, 1, debug);  % 估计edge direction (最大特征值方向）
[DxLowHat, DyLowHat] = SmoothField(DxLow, DyLow, OrientMap, Coherence); % 平滑偏移场
for kk = 1:numIter
    kk/numIter
    [DxLowHat, DyLowHat] = SmoothField(DxLowHat, DyLowHat, OrientMap, Coherence); % 平滑偏移场
end

% Show low resolution displacement field before/after smoothing
DxHat = (imresize(DxLowHat,(2^level),'bilinear'));  
DyHat = (imresize(DyLowHat,(2^level),'bilinear'));

% Show the non-smoothed displacement field
if debug == 1
    dispField = complex(Dx, Dy);
    dispFieldSmp ...
        = dispField(1:downsmpFactor:size(dispField,1), 1:downsmpFactor:size(dispField,2));
    ShowImgPlusVecField(dispFieldSmp, imageIn);
    title('Displacement field before smoothing');
end

% Show smoothed displacement Map overlapped with the original image before
% applying the distortion
if debug == 1
    dispFieldSmoothed = complex(DxHat, DyHat);
    dispFieldSmoothedSmp ...
        = dispFieldSmoothed(1:downsmpFactor:size(dispField,1), 1:downsmpFactor:size(dispField,2));
    ShowImgPlusVecField(dispFieldSmoothedSmp, imageIn);
    title('Displacement Field after smoothing');
    figure; imshow(imag(dispFieldSmoothedSmp),[]);
    
    temp1 = real(dispFieldSmoothed);
    hist(temp1(:), 30);
end

% Compare the displacement field before and after smoothing
if debug == 1
    vy = 1:size(dispFieldSmoothedSmp,1);
    vx = 1:size(dispFieldSmoothedSmp,2);
    [vvx, vvy] = meshgrid(vx, vy);
    figure; quiver(vvx, vvy, real(dispFieldSmoothedSmp), imag(dispFieldSmoothedSmp));
    hold on;
    quiver(vvx, vvy, real(dispFieldSmp), imag(dispFieldSmp), 'r');
    legend('smoothed', 'nonsmoothed');
end

% Apply to image (grayscale image or color image)
if size(imageIn,3)>1
    for ii = 1:3
        attackedImg(:,:,ii) = DistortImg(imageInColor(:,:,ii), DxHat, DyHat);
    end
else
    attackedImg = DistortImg(imageInGray, DxHat, DyHat);
end

% show 
if debug == 1
    figure;
    subplot(1,2,1); imshow(imageIn,[]); title('input image');
    subplot(1,2,2); imshow(attackedImg, []); title('attacked image');
        
    figure;
    imshow(attackedImg,[]); title('Attacked image using smoothed disp. field');
    ShowImgPlusVecField(dispFieldSmoothedSmp, attackedImg);
    title('Attacked image using smoothed disp. field');
    
    figure;
    imshow(attackedImageNoSmooth,[]);
    title('Attacked image using non-smoothed disp. field');
    ShowImgPlusVecField(dispFieldSmp, attackedImageNoSmooth);
    title('Attacked image using non-smoothed disp. field');
end

end 

%====================================================================
% generate low resolution image
%===================================================================
function imgOut = genLowResolutionImg(imgIn, level,sizeMask, sigma )
% Note: for output, the level starts from 1 ( 1 == original resolution)
filterMask = fspecial('gaussian',sizeMask,sigma);
for i = 0:level
    if i == 0
        imgOut(1).img = imgIn;
    else
        imgTemp =  imfilter(imgOut(i).img, filterMask,'symmetric', 'conv');
        [rows, cols] = size(imgTemp);
        imgOut(i+1).img = imgTemp(1:2:rows, 1:2:cols);
    end
end
end


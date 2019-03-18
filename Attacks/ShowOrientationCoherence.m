
function ShowOrientationCoherence(Orient,Coherence, image)
% Show orientation result, where the length of the orientation vector is
% weighted by coherence. So that for more coherent region, we use arrow
% with larger length (norm), while for less coherent region, we use arrows
% with smaller length. 
% 
% <Note>
% This code is modified from the code ShowOrientation.m as used in
% Xiao-Guang Feng. Analysis and Approaches to Image Local Orientation
% Estimation. Master Thesis, 2003, University of California.
%
% <History>
% Bin Yan, 2013. 5.25. Created.

figure;
imagesc(image);
colormap(gray);
axis image;
axis off;
hold on;
step1=size(image,1)/size(Orient,1);
step2=size(image,2)/size(Orient,2);
[x,y]=meshgrid(step1/2:step1:size(image,2),...
    step2/2:step2:size(image,1));
u=real(Orient)./abs(Orient);
v=-imag(Orient)./abs(Orient);
u = u.* Coherence;
v = v.* Coherence;
h=quiver(x,y,v,u);
set(h,'color','red');
    
 
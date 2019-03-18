function ShowImgPlusVecField(VecField,image)
% Show image with a vector field superimposed on it. The vector field
% maybe the local orientation field, or the displacement field. 
figure;
imagesc(image);
colormap(gray);
axis image;
axis off;
hold on;
step1=size(image,1)/size(VecField,1);
step2=size(image,2)/size(VecField,2);
[x,y]=meshgrid(step1/2:step1:size(image,1),...
    step2/2:step2:size(image,2));
v = real(VecField);
u = imag(VecField);
h=quiver(x,y,v,u);
set(h,'color','red');
    

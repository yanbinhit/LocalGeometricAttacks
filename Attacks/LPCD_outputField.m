%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LPCD attack 
% Author: Angela D'Angelo
% 
% INPUT arguments: window = size of the searching window
%                  level  = level of resolution
%                  image  = original image
% 
% If you use this code for your research please cite:
%
% "Expanding the class of watermark de-synchronization attacks "
% M. Barni, A. D'Angelo, N. Merhav
% ACM Multimedia and Security Workshop, Dallas (USA),  September 20-21 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 修改： 输出所用的 displacement field
% Dx: displacement field in x direction
% Dy: displacement field in y direction
% the input image is now a matrix instead of a file. the attacked image is as
% output of the function (uint8 format)

function [attacked_image, Dx, Dy, dxLow, dyLow] = LPCD_outputField(window,level,image,debug)


% level of resolution
L=str2double(level);

% size of the searching window
N=str2double(window);


% read image to which apply the distortion
im = image; 
dim_orig=size(im);

new=imresize(im,1/(2^L));  
dim=size(new);


% generate displacement field at level of resolution L
matrix_row=zeros(dim(1,1),dim(1,2));
matrix_column=zeros(dim(1,1),dim(1,2));
for i= 1 : dim(1)
    for j= 1 : dim(2)
        
        if (i<floor(N/2)+1)|| (j<floor(N/2)+1)
            max_size=min(i,j)-1;
        elseif (i>dim(1,1)-floor(N/2))|| (j>dim(1,1)-floor(N/2))
            max_size=(dim(1,1)-max(j,i));
        else
            max_size=floor(N/2);
        end
        
        W=(max_size*2)+1;
        perm=randperm(W^2);
        ind=perm(1,1);
        riga=ceil(ind/W);
        colonna=ind-((riga-1)*W);

        sx=-(floor(W/2)+1)+ riga;
        sy=-(floor(W/2)+1)+ colonna;

        matrix_row(i,j)=sx;
        matrix_column(i,j)=sy;


    end
end

% resize of the displacement field
Total_row = (imresize(matrix_row,(2^L),'bilinear'));  
Total_column = (imresize(matrix_column,(2^L),'bilinear'));
dxLow = matrix_row;
dyLow = matrix_column;

% displacement field applied to the image
row=zeros(dim_orig(1,1),dim_orig(1,2));
column=zeros(dim_orig(1,1),dim_orig(1,2));
for l=1:dim_orig(1)
    for m=1:dim_orig(2)
        row(l,m)=m + Total_row(l,m);
        column(l,m)=l + Total_column(l,m);
    end
end
att=interp2(double(im),row,column,'bicubic');
attacked_image=uint8(att);

% output displacement field
Dx = Total_row; %
Dy = Total_column; %

if debug == 1
    % show images
    figure;
    diff=uint8(im)-attacked_image;
    subplot(2,2,1),imshow(uint8(im)),title('Original image');
    subplot(2,2,2),imshow(attacked_image),title('Attacked image');
    subplot(2,2,3:4),imshow(diff),title('Differences');
end

end


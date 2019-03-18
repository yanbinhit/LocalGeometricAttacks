%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLPCD attack 
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
% Modification£º output also the displacement field
% Dx: displacement field in x direction
% Dy: displacement field in y direction
% image is now an image matrix instead of an image file.
% also accept and output color image now
% Bin Yan, yanbinhit@hotmail.com 2013
%==========================================================================

function  [attacked_image, Total_row, Total_column, dxLow, dyLow]...
    = CLPCD_outputField(window,level,image, debug)

% level of resolution
L=str2double(level);

% size of the searching window
N=str2double(window);

% read image to which apply the distortion
if size(image,3)>1
    im = double(rgb2gray(image));
else
    im = double(image);
end

dim_orig=size(im);

new=imresize(im,1/(2^L));  
dim=size(new);

% generate displacement field at level of resolution L
matrix_row=zeros(dim(1,1),dim(1,2));
matrix_column=zeros(dim(1,1),dim(1,2));

for i= 1 : dim(1,1)
    for j= 1 : dim(1,2)
        % on the border a plain LPCD is applied
        if (i<floor(N/2)+1)|| (j<floor(N/2)+1)
            max_size=min(i,j)-1;
            W=(max_size*2)+1;
            perm=randperm(W^2);
            ind=perm(1,1);
            riga=ceil(ind/W);
            colonna=ind-((riga-1)*W);
            sx=-(floor(W/2)+1)+ riga;
            sy=-(floor(W/2)+1)+ colonna;
        elseif (i>dim(1,1)-floor(N/2))|| (j>dim(1,1)-floor(N/2))
            W=(max_size*2)+1;
            perm=randperm(W^2);
            ind=perm(1,1);
            riga=ceil(ind/W);
            colonna=ind-((riga-1)*W);
            sx=-(floor(W/2)+1)+ riga;
            sy=-(floor(W/2)+1)+ colonna;
        else
            % C-LPCD: the displacement of each pixel depend on the displace
            % ment of its previous pixel
            Ix=[max(-floor(N/2),matrix_row(i,j-1)-1):floor(N/2)];
            p=zeros(1,length(Ix));
            p(1,2:end)=1/((2*floor(N/2))+1);
            p(1,1)=1 - (1/((2*floor(N/2))+1))*(length(Ix)-1);
            perm=rando(p);
            sx=Ix(1,perm);
            
            Iy=[max(-floor(N/2),matrix_column(i-1,j)-1):floor(N/2)];
            p=zeros(1,length(Iy));
            p(1,2:end)=1/((2*floor(N/2))+1);
            p(1,1)=1 - (1/((2*floor(N/2))+1))*(length(Iy)-1);
            perm=rando(p);
            sy=Iy(1,perm);
        end
        matrix_row(i,j)=sx;
        matrix_column(i,j)=sy;
    end
end

% resize of the displacemnt filed
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

if size(image,3)>1  % color image
    for kk = 1:3
        att(:,:,kk) = interp2(double(image(:,:,kk)),row,column,'bilinear');
    end
else  % graylevel image
    att=interp2(double(im),row,column,'bilinear');
end
attacked_image=uint8(att);

if debug == 1
    % show images
    figure;
    diff=uint8(image)-attacked_image;
    subplot(2,2,1),imshow(uint8(image)),title('Original image');
    subplot(2,2,2),imshow(attacked_image),title('Attacked image');
    subplot(2,2,3:4),imshow(diff),title('Differences');
end
    
end % end of function


       

      


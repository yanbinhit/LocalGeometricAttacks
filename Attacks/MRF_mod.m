%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Markov Random Field based attack 
% Author: Angela D'Angelo
% 
% INPUT arguments: stdev = standard deviation of the potential function
%                  level = level of resolution
%                  image = original image
% 
% If you use this code for your research please cite:
%
% "Expanding the class of watermark de-synchronization attacks "
% M. Barni, A. D'Angelo, N. Merhav
% ACM Multimedia and Security Workshop, Dallas (USA),  September 20-21 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Modification
% [2013] change Vtot to Wtot directly (two lines)
%   output lower resolution displacement field and
%   full resolution displacement field
% Bin Yan, yanbinhit@hotmail.com                                   

function [attacked_image, Dx, Dy, dxLow, dyLow] = ...
                                           MRF_mod(level,stdev,imageIn, DEBUG)

% read image to which apply the distortion
if size(imageIn,3)>1
    im = double(rgb2gray(imageIn));
else
    im = double(imageIn);
end
dim_orig=size(im);


% level of resolution
L=str2double(level);
dim=dim_orig(1,1)/(2^L);

% Modification (Bin Yan 2013)
vw = 'v'; % set this to 'w' if use the Wtot directly.
Nt = 20;

% parameters of the potential function (bivariate normal distribution)
std=str2double(stdev);
stdx=std;
stdy=std;
rho=0;

% initialization of the displacement fields matrices (increasing the value
% of c is possible to ontain a stronger displacement field)
c=dim/2;
% Init_x = randint(dim,dim,[-c,c]);  
% Init_y = randint(dim,dim,[-c,c]);
Init_x = randi([-c, c], dim, dim);
Init_y = randi([-c, c], dim, dim);
dim_init=size(Init_x);
dispLen = sqrt(Init_x.^2 + Init_y.^2);
meanLen = mean(mean(dispLen));

temp_x= Init_x;  
temp_y = Init_y ;
diff_x=zeros(dim,dim);
diff_y=zeros(dim,dim);
zed=zeros(dim,dim);
count=1;

totalEnergy = zeros(Nt, 1);
if DEBUG ==1
    hWait = waitbar(0, 'ICM...');
end
% iterated conditional mode (ICM)
% the value 10 is used to reduce the complexity 
%(ICM usually converger in 7-8 iterations).
for iter=1:Nt
    if DEBUG == 1
        waitbar((iter-1)/Nt, hWait);
    end
    row=randperm(dim);
    col=randperm(dim);
        
    for k=1:dim
        for h=1:dim

            i=row(1,k);
            j=col(1,h);


            sx_orig=Init_x(i,j);
            sy_orig=Init_y(i,j);
            if vw == 'v'
                Vtot_orig= Vtot(sx_orig,sy_orig,i,j,Init_x, Init_y,stdx,stdy,rho,dim);
            elseif vw == 'w'
                Vtot_orig= Wtot(sx_orig,sy_orig,i,j,Init_x, Init_y,stdx,stdy,rho,dim);
            end
            Vtemp=Vtot_orig;
            best_sx=sx_orig;
            best_sy=sy_orig;

            
            % the values 12 and -12 are used to reduce the complexity 
            %(the displacement never goes beyond 12 pixel!) 
            xmin=max((-j+1),-12);
            xmax=min((dim-j),12);
            ymin=max((-i+1),-12);
            ymax=min((dim-i),12);


            % loop to find the optimum displacement (the one minimizing the potential
            % function)
            for sx=xmin:xmax
                for sy=ymin:ymax

                    
                    if vw == 'v'
                        Vtot_sxsy= Vtot(sx,sy,i,j,Init_x, Init_y,stdx,stdy,rho,dim);
                    elseif vw == 'w'
                        Vtot_sxsy= Wtot(sx,sy,i,j,Init_x, Init_y,stdx,stdy,rho,dim);
                    end
                    if (Vtot_sxsy<Vtemp)
                        best_sx=sx;
                        best_sy=sy;
                        Vtemp=Vtot_sxsy;
                    end


                end
            end

            
            Init_x(i,j)=best_sx;
            Init_y(i,j)=best_sy;

            
            % to delete annoying border effects:
            if(j==1)&&(Init_x(i,j)<0)
                Init_x(i,j)=0;
            end
            if(j==dim)&&(Init_x(i,j)>0)
                Init_x(i,j)=0;
            end
            if(i==1)&&(Init_y(i,j)<0)
                Init_y(i,j)=0;
            end
            if(i==dim)&&(Init_y(i,j)>0)
                Init_y(i,j)=0;
            end


        end
    end
    
    % Modification: calculate the total energy (actually twice of the total energy)
    % Bin Yan, 2013
    % 增加部分：计算总能量
    for i = 1:dim
        for j = 1:dim
            totalEnergy(iter) = totalEnergy(iter) + Wtot(Init_x(i,j),Init_y(i,j),i,j,Init_x, Init_y,stdx,stdy,rho,dim);
        end
    end
    totalEnergy(iter) = totalEnergy(iter)/2;

    diff_x=temp_x-Init_x;
    diff_y=temp_y-Init_y;

    temp_x=Init_x;
    temp_y=Init_y;


    tf=isequal(diff_x,zed);
    tr=isequal(diff_y,zed);

    % 修改：去掉提前结束条件，让程序迭代固定的次数：Nt次。
    % ICM converges when no new modification is introduced for a whole
    % iteration
%     if (tf==1)&&(tr==1)
%         break;
%     end
    
    
end

if DEBUG == 1
    close(hWait);
end

dxLow = Init_x;
dyLow = Init_y;

% resize of the displacemnt field
Total_row = (imresize(Init_x, [dim_orig(1), dim_orig(2)],'bicubic'));  
Total_column = (imresize(Init_y, [dim_orig(1), dim_orig(2)],'bicubic'));

Dx = Total_row; % output full resolution displacement field
Dy = Total_column; %

% displacement field applied to the image
row=zeros(dim_orig(1,1),dim_orig(1,2));
column=zeros(dim_orig(1,1),dim_orig(1,2));
for l=1:dim_orig(1)
    for m=1:dim_orig(2)
        row(l,m)=m + Total_row(l,m);
        column(l,m)=l + Total_column(l,m);
    end
end

if size(im, 3)>1 % color image
    for ii = 1:3
        att(:,:,ii) = interp2(double(im(:,:,ii)),row,column,'bilinear');
    end
else
    att=interp2(double(im),row,column,'bilinear');
end

attacked_image=uint8(att);

if DEBUG == 1
    % show displacement fields
    figure;
    quiver(1:dim_orig(1), 1:dim_orig(2), Total_row, Total_column);
    title('Displacement field (full resolution).');
    figure;
    quiver(1:dim, 1:dim, Init_x, Init_y);
    title('Displacement field (low resolution).');

    % show images
    figure;
    diff=uint8(im)-attacked_image;
    imshow(im),title('Original image');
    hold on; quiver(1:dim_orig(1), 1:dim_orig(2), Total_row, Total_column);
    figure;
    imshow(attacked_image,[]),title('Attacked image');
    figure;
    imshow(uint8(diff),[]),title('Differences');
    
    % show energy evolution
    figure;
    plot(totalEnergy);
    title('Evolution of total energy w.r.t. iterations.');
end

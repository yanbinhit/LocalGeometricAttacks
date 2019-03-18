function score = Gabor_metric(Image, Disx, Disy, class)

%========================================================================
% Objective Metric for the quality assessment of geometric distortions in
% images based on Gabor filters (v 1.0)
% This code is tested on 512x512 pixel size images. A generic code will be
% provided soon.
%
% If you use this code for your research please cite:
%
% "Full-reference image quality assessment of geometric distortions in images"
% Angela D'Angelo, Li Zhaoping, Mauro Barni.
%
%----------------------------------------------------------------------
% USAGE (please refer to the paper for more details):
% Input : (1) Image:Reference image
%         (2) Disx: matrix of the displacement field in the x direction
%         (3) Disy: matrix of the displacement field in the y direction
%         (4) class: defines the class of image
%             1= house image
%             2= natural image
%             3= face image
%             4= generic image
%
%
% Output: (1) score: numerical value from 1 to 5 quantifying the quality
%             of the distorted images using the following scale:
%             1= Bad quality
%             2= Poor quality
%             3= Fair quality
%             4= Good quality
%             5= Excellent quality
%
%========================================================================
% Modification:
%    Add several lines to change color image to grayscale if the input is color

% if (size(Disx,1)&&size(Disx,2)&&size(Disy,1)&&size(Disy,2)==512)==0
%     error('this code is tested on 512x512 size images');
% end

if (class~=1)&&(class~=2)&&(class~=3)&&(class~=4)
    error('class must be an integer number from 1 to 4');
end



%--- read reference image 
% modification: Bin Yan, can accept both image file name and image matrix now
if (isnumeric(Image))
    OriginalImage = Image;
else
    OriginalImage=imread(Image);
end
if size(OriginalImage,3)>1
    OriginalImage = rgb2gray(OriginalImage);
end

%--- number of orientations
NoF=2;

TotalScores=zeros(1,NoF);
theta=0;



for i=1:NoF

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %--- Gabor filters parameters

    gamma=0.5; % aspect ratio
    psi=0;     % phase offset
    scale=10;  % size of the filter

    if class==4
        lambda=9; % wavelenght
    elseif class==1
        lambda=10;
    elseif class==2
        lambda=6;
    else
        lambda=8;
    end

    [GaborFilterBar,GaborFilterEdge]=gabor_fn(scale,theta,lambda,psi,gamma);


    %--- filtering the original image by Gabor filters.
    FilteredImage1 = filter2(double(GaborFilterBar), double(OriginalImage), 'valid');
    FilteredImage2 = filter2(GaborFilterEdge, OriginalImage, 'valid');
    FilteredImageSquared = (((FilteredImage1).^2 + (FilteredImage2).^2));



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %--- displacement evaluation

    [Dis_theta] = direction(Disx, Disy, theta);
    ChangeSquared= sqrt(Dis_theta.^2);


    [size1, size2] = size(ChangeSquared);
    [sizeUsed1, sizeUsed2] = size(FilteredImageSquared);
    Sp1 = ceil((size1-sizeUsed1)/2);
    Sp2 = ceil((size2-sizeUsed2)/2);
    UsedChangeSquared = ChangeSquared(Sp1+1:Sp1+sizeUsed1, Sp2+1:Sp2+sizeUsed2);

    %--- get the score along this direction only
    c=3;
    d=1;
    ScoreEachPixeltheta = ((UsedChangeSquared.^c).*(FilteredImageSquared.^d));

    %--- total score normalized with respect to the image size
    TotalScoretheta = sum(sum(ScoreEachPixeltheta))/(size(OriginalImage,1)*size(OriginalImage,2));
    TotalScores(1,i)=TotalScoretheta;

    theta=theta+pi/NoF;

end

% normalization respect the number of orientations and image size
Metric=(sum(TotalScores)./NoF)./(size(OriginalImage,1)*size(OriginalImage,2));


% weibull function (equation .. )
if class==1
    b=0.00212;
    k=0.4061;
elseif class==2
    b=0.001152;
    k=0.2927;
elseif class==3
    b=0.01002;
    k=0.2286;
elseif class==4
    b=0.00229;
    k=0.3529;
end


% objective metric
score=-4*(1-exp(-(Metric./b).^k))+5;
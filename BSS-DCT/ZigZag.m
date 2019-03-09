function   Izg = ZigZag ( I )

%
% 将矩阵I的元素按照 zigzag 方式生成一维向量 Izg
%
% <inputs>
%           I: matirx, usually the DCT coefficients of image
% <outputs>
%           Izg: vector, the result of zigzag scanning of matrix I
% <author>  
%           Bin Yan, Signal processing lab, Research institute of automatic test and control
%                       Harbin Institute of technology, Harbin ,china
%                       yanbin@dsp.hit.edu.cn

% % testing data
% I = imread('lena.bmp');
% I = dct2(I);

[M,N] = size(I);

Izg = zeros(M*N,1);
i = 1;
j = 1;
nextState = 'h'; % 'h':horizontal, 'v' vertical, 'ld': left down, 'ru': right up --indication of direction
k = 1;
Izg(k) = I(1,1);
k = k+1;
while (i<M) | (j<N)
    if nextState == 'h'
        j = j+1;
        Izg(k) = I(i,j);
        k = k+1;
        if i ==1
            nextState = 'ld';
        else
            nextState = 'ru';
        end
    elseif nextState == 'ld'
        while (i<M) & (j>1)
            j = j-1;
            i = i+1;
            Izg(k) = I(i,j);
            k = k+1;
        end
        if i==M 
            nextState = 'h';
        else
            nextState = 'v';
        end
    elseif nextState == 'v'
        i = i+1;
        Izg(k) = I(i,j);
        k = k+1;
        if j ==1
            nextState = 'ru';
        else 
            nextState = 'ld';
        end
    elseif nextState == 'ru'
        while (i>1) & (j<N)
            i = i-1;
            j = j+1;
            Izg(k) = I(i,j);
            k = k+1;
        end
        if j == N
            nextState = 'v';
        else
            nextState = 'h';
        end
    end
end %end of while
    
  
 function   I = InvZigZag ( Izg, M, N)

%
% 将zigzag生成的一维向量变为矩阵形式
%
% <inputs>
%           Izg: vector, which is generated from matrix by zigzag scanning
%           M: number of rows of target matrix
%           N: number of columns of target matrix
% <outputs>
%           I: Output matrix,M by N.
% <author>  
%           Bin Yan, Signal processing lab, Research institute of automatic test and control
%                       Harbin Institute of technology, Harbin ,china
%                       yanbin@dsp.hit.edu.cn

% % testing data
% I = imread('lena.bmp');
% I = dct2(I);



I = zeros(M,N);
i = 1;
j = 1;
nextState = 'h'; % 'h':horizontal, 'v' vertical, 'ld': left down, 'ru': right up --indication of direction
k = 1;
I(1,1) = Izg(k);
k = k+1;
while (i<M) | (j<N)
    if nextState == 'h'
        j = j+1;
        I(i,j) = Izg(k) ;
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
            I(i,j) = Izg(k) ;
            k = k+1;
        end
        if i==M 
            nextState = 'h';
        else
            nextState = 'v';
        end
    elseif nextState == 'v'
        i = i+1;
        I(i,j) = Izg(k) ;
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
            I(i,j) = Izg(k) ;
            k = k+1;
        end
        if j == N
            nextState = 'v';
        else
            nextState = 'h';
        end
    end
end %end of while
    
  
function attackedImg = DistortImg(imgIn, Dx, Dy)
%==========================================================================
% 使用给定的displacement field： Dx 和 Dy 来攻击图像imgIn 。
%==========================================================================

[nRows, nCols] = size(imgIn);

% 检查 imgIn, Dx, Dy 三者的尺寸是否一致.
% 以后增加
maxD = ceil(max([max(Dx(:)), max(Dy(:))]));
for i = 1 : nRows
    for j = 1 : nCols
        rowIdx(i,j) = j + Dx(i,j);
        colIdx(i,j) = i + Dy(i,j);
    end
end
%imgIn = padarray(imgIn, [maxD maxD], 'replicate','both');
att = interp2(double(imgIn),rowIdx,colIdx, 'bicubic');
attackedImg = uint8(att);
function mask = genMvGaussianMask(px,py, mu, weightingMatrix)
% genMvGaussianMask: Generate multivariate Gaussian mask for a set of
%   vectors.
% <inputs>
%   px, py: [px, py] are the points to evaluate the mask. px and py should
%       have the same size.       
%   mu: mean vector
%   weightingMatrix: weighting matrix used to penalize different position 
%       (vector).
%
% <outputs>
%   mask: The output Gaussian mask.
%
% The size of y is the same as the size of p. If p is a matrix of vectors
% then y is a matrix of values.
%

if (size(px) ~= size(py))
    error('px and py should have the same size');
end
[nRows, nCols] = size(px);
C = weightingMatrix;
nElements = nRows * nCols;

maskVect = zeros(nElements, 1);
pxVect = reshape(px, 1, []);
pyVect = reshape(py, 1, []);
pVect = [pxVect; pyVect];    % each column corresponds to one point (vector)
xVect = pVect - [ones(1,nElements)*mu(1); ones(1, nElements)*mu(2)];
maskVector =sqrt(det(C))/(2*pi) *  exp(-1/2 * sum((xVect'* C)' .* xVect)); 
mask = reshape(maskVector, nRows, nCols);


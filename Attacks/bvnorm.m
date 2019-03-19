% bivariate normal distribution

function [value]=bvnorm(x,y,meanx, meany, stdx, stdy, rho)

Q = ( ((x-meanx).^2)./(stdx^2)-(2*rho*(x-meanx).*(y-meany))./(stdx*stdy)+((y-meany).^2)./(stdy^2))./( 1 - rho^2 );
value = exp( -0.5*Q ) ./ ( 2*pi*stdx*stdy*sqrt(1-rho^2) );

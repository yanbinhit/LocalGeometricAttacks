function [gbar,gedge]=gabor_fn(scale,theta,lambda,psi,gamma)

%========================================================================
% This function returns the Gabor Bar and Gabor Edge filters
%========================================================================


sigma_x=0.56*lambda;
sigma_y=0.56*lambda;

sz_x=fix(scale*sigma_x);
if mod(sz_x,2)==0, sz_x=sz_x+1;end
        

sz_y=fix(scale*sigma_y);
if mod(sz_y,2)==0, sz_y=sz_y+1;end

[x y]=meshgrid(-fix(sz_x/2):fix(sz_x/2),fix(-sz_y/2):fix(sz_y/2));

x_theta=x*cos(theta)+y*sin(theta);
y_theta=-x*sin(theta)+y*cos(theta);

bar=exp(-.5*(x_theta.^2/sigma_x^2+gamma^2*y_theta.^2/sigma_y^2)).*cos(2*pi/lambda*x_theta+psi);
gedge=exp(-.5*(x_theta.^2/sigma_x^2+gamma^2*y_theta.^2/sigma_y^2)).*sin(2*pi/lambda*x_theta+psi);

gbar=bar - (mean(mean(bar)));

function [Dis_theta] = direction(Dis_x,Dis_y,theta)


Gradxx=(gradient(Dis_y'))';
Gradyx=(gradient(Dis_x'))';

Gradxy=gradient(Dis_y);
Gradyy=gradient(Dis_x);

Dis_theta=sin(theta).*((Gradxx.*cos(theta))+(Gradyx.*sin(theta)))+ ...
    cos(theta).*((Gradxy.*cos(theta))+(Gradyy.*sin(theta)));

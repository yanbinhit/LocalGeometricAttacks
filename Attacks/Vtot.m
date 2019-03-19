% This function returns the potential function of the chosen neighborhood
% system (the sum of the potentials  of the pair-site cliques)

function [Vtotal]=Vtot(sx,sy,p,q,Init_x, Init_y,stdx,stdy,rho,a)

level=size(Init_x);
use=level(1);

Wtot_pq=Wtot(sx,sy,p,q,Init_x, Init_y,stdx,stdy,rho,a);
if (p==1)
    Wtot_a=0;
else
    Wtot_a=Wtot(sx,sy,p-1,q,Init_x, Init_y,stdx,stdy,rho,a);
end
if (p==use)
    Wtot_b=0; 
else
    Wtot_b=Wtot(sx,sy,p+1,q,Init_x, Init_y,stdx,stdy,rho,a);
end
if (q==use)
    Wtot_d=0; 
else
    Wtot_d=Wtot(sx,sy,p,q+1,Init_x, Init_y,stdx,stdy,rho,a);
end
if (q==1)
    Wtot_c=0;  
else
    Wtot_c=Wtot(sx,sy,p,q-1,Init_x, Init_y,stdx,stdy,rho,a);
end    



Vtotal=Wtot_pq + Wtot_a + Wtot_b + Wtot_c + Wtot_d;




        

% This function returns the Gibbs potential of the chosen neighborhood
% system (the sum of the potentials  of the pair-site cliques)

function [w_totale]=Wtot(sx,sy,l,m, Init_x, Init_y, stdx, stdy,rho,a)


t=size(Init_x);
w=t(1);

y=(a+1)-(l-sy);
x=m+sx;

%Va->(l-1,m)
if(l-1<=0)
    Va=0;
else
meanxA=(m)+Init_x(l-1,m);
meanyA=(a+1)-(l-Init_y(l-1,m)); 
Va=-(bvnorm(x, y, meanxA, meanyA, stdx, stdy, rho));
end

%Vb->(l+1,m)
if(l+1>=w+1)
     Vb=0;
else
meanxB=(m)+Init_x(l+1,m);
meanyB=(a+1)-((l)-Init_y(l+1,m)); 
Vb=-(bvnorm(x, y, meanxB, meanyB, stdx, stdy, rho)) ;
end

%Vc->(l,m+1)
if(m+1>=w+1)
    Vc=0;
else
meanxC=(m)+Init_x(l,m+1);
meanyC=(a+1)-((l)-Init_y(l,m+1)); 
Vc=-(bvnorm(x, y, meanxC, meanyC, stdx, stdy, rho)) ;
end


%Vd->(l,m-1)
if(m-1<=0)
     Vd=0;
else
meanxD=(m)+Init_x(l,m-1);
meanyD=(a+1)-((l)-Init_y(l,m-1)); 
Vd=- (bvnorm(x, y, meanxD, meanyD, stdx, stdy, rho))  ;
end

% potential due to sx,sy displacements
w_totale= Va + Vb + Vc + Vd;    
 
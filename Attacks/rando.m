
%  rando.m generates a random variable in 1, 2, ..., n given a distribution 
%  vector p . 


function [index] = rando(p)


u = rand;
i = 1;
s = p(1);


while ((u > s) & (i < length(p))),
  i=i+1;
  s=s+p(i);
end

index=i;


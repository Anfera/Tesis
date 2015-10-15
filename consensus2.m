%% Second order consensus
clear all
clc

L = [1 -1 0 0 0;
    -1 2 -1 0 0;
    0 -1 2 -1 0;
    0 0 -1 2 -1;
    0 0 0 -1 1];

L2 = [eye(5) eye(5);
      -L -(L+eye(5)) + eye(5)];
  
x = [1 2 3 4 5]';

mu = [x; x./0.01];

for i = 1:500
    mu(:,i+1) = mu(:,i) + 0.01*L2*mu(:,i);
end

plot(mu(1:5,:)')
%% Consensus algorithm
% Va a ser util mas adelante...creo...
% De nuevo supongamos integradores por simplicidad
clear all
clc

dt = 0.01;

x = rand(5,1);
L = [1 -1 0;-1 2 -1;0 -1 1];
Q = [1 -1 0 0 0;
    -1 2 -1 0 0;
     0 -1 2 -1 0;
     0 0 -1 2 -1;
     0 0 0 -1 1];
 
omega = [0 0.5 0 0.5 0;
        0 0 0.5 0.5 0;
        0 1 0 0 0;
        0 0 0 0 1;
        0.5 0.5 0 0 0];

for i = 1:1000
      x(:,i+1) = x(:,i) - dt*Q*x(:,i);
end

plot(x')

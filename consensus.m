%% Consensus algorithm
% Va a ser util mas adelante...creo...
% De nuevo supongamos integradores por simplicidad
clear all
clc

dt = 0.01;

x = [1;3;2];
L = [1 -1 0;-1 2 -1;0 -1 1];

for i = 1:600
      x(:,i+1) = x(:,i) - dt*L*x(:,i);
end

plot(x')
legend('1','2','3')
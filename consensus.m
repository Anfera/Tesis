%% Consensus algorithm
% Va a ser util mas adelante...creo...
% De nuevo supongamos integradores por simplicidad

dt = 0.01;

x = [2;1;3];

for i = 1:600
    x(1,i+1) = x(1,i) + dt*(x(2,i) - x(1,i));
    x(2,i+1) = x(2,i) + dt*((x(1,i) - x(2,i)) + (x(3,i) - x(2,i)));
    x(3,i+1) = x(3,i) + dt*(x(2,i) - x(3,i));
end

plot(x')
legend('1','2','3')
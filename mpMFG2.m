%% Multi-population MFG
%% Vamos a probar el MFG explicito!
% La clave estaba en ACC! tener un estado no controlado...

yalmip('clear')
clear all
% Model data
A = [1 0; 0 1];
B = [0.01; 0];
nx = size(A,1); % Number of states
nu = size(B,2); % Number of inputs
Q = [1 -1;-1 1];

% Prediction horizon
N = 4;
% States x(k), ..., x(k+N)
x = sdpvar(repmat(nx,1,N),repmat(1,1,N));
% Inputs u(k), ..., u(k+N) (last one not used)
u = sdpvar(repmat(nu,1,N),repmat(1,1,N));

J{N} = 0;

for k = N-1:-1:1    

    % Feasible region
    constraints = [-5 <= x{k}     <= 5,
                   -5 <= x{k+1}   <= 5];

    % Dynamics
    constraints = [constraints, x{k+1} == A*x{k}+B*u{k}];

    % Cost in value iteration
    %objective = norm(x{k},1) + norm(u{k},1) + J{k+1}
    objective = 50*(x{k})'*Q*(x{k}) + (u{k})'*(u{k}) + J{k+1};

    % Solve one-step problem    
    [sol{k},dgn{k},Uz{k},J{k},uopt{k}] = solvemp(constraints,objective,[],x{k},u{k});
end

%% closed loop simulation

agentes1 = zeros(100,400);
agentes2 = zeros(100,400);
agentes3 = zeros(100,400);
agentes4 = zeros(100,400);
agentes5 = zeros(100,400);

Q = [1 -1 0 0 0;
    -1 2 -1 0 0;
    0 -1 2 -1 0;
    0 0 -1 2 -1;
    0 0 0 -1 1];

agentes1(:,1) = random('norm',-6,0.5,100,1); %Distribución inicial
agentes2(:,1) = random('norm',-3,0.5,100,1);
agentes3(:,1) = random('norm',0,0.5,100,1);
agentes4(:,1) = random('norm',3,0.5,100,1);
agentes5(:,1) = random('norm',6,0.5,100,1);

p = [agentes1(:,1) agentes2(:,1) agentes3(:,1) agentes4(:,1) agentes5(:,1)];
p = mean(p)';

for k = 1:400 %tiempo
    for i = 1:100 %agentes
        p(:,k+1) = p(:,k) - 0.01*Q*p(:,k);
        
        agentes1(i,k+1) = agentes1(i,k) + B(1,1)*(p(1,k) - agentes1(i,k));
        
        agentes2(i,k+1) = agentes2(i,k) + B(1,1)*(p(2,k) - agentes2(i,k));
        
        agentes3(i,k+1) = agentes3(i,k) + B(1,1)*(p(3,k) - agentes3(i,k));
        
        agentes4(i,k+1) = agentes4(i,k) + B(1,1)*(p(4,k) - agentes4(i,k));
        
        agentes5(i,k+1) = agentes5(i,k) + B(1,1)*(p(5,k) - agentes5(i,k));
    end
    [k,400]
end

plot(agentes1')
hold on
plot(agentes2')
hold on
plot(agentes3')
hold on
plot(agentes4')
hold on
plot(agentes5')
hold on

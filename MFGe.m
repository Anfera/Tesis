%% Vamos a probar el MFG explicito!
% La clave estaba en ACC! tener un estado no controlado...

yalmip('clear')
clear all
% Model data
A = [1 0; 0 1];
B = [-0.01; 0];
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
    constraints = [-20 <= x{k}     <= 20,
                   -20 <= x{k+1}   <= 20];

    % Dynamics
    constraints = [constraints, x{k+1} == A*x{k}+B*u{k}];

    % Cost in value iteration
    %objective = norm(x{k},1) + norm(u{k},1) + J{k+1}
    objective = 50*(x{k})'*Q*(x{k}) + (u{k})'*(u{k}) + J{k+1};

    % Solve one-step problem    
    [sol{k},dgn{k},Uz{k},J{k},uopt{k}] = solvemp(constraints,objective,[],x{k},u{k});
end

%% closed loop simulation

agentes = zeros(100,400); %500 agentes en 100 intervalos de tiempo
dist = zeros(100,400);
dist(1:50,150) = 0;

agentes(:,1) = random('norm',1,0.5,100,1); %Distribución inicial

for i = 1:400 %tiempo
    for j = 1:100 %agentes
        assign(x{1},[agentes(j,i); mean(agentes(:,i))]);
        u_ = value(uopt{1});
        agentes(j,i+1) = agentes(j,i) + B(1,1)*u_ + dist(j,i);
    end
    [i,400]
end

plot(agentes')

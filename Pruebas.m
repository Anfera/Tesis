%% Prueba de la tesis
% Vamos a intentar el multipopulation MFG, pero primero...
% probamos el gurobi
yalmip('clear')
clear all
% Model data
A = [1];
B = [0.1];
C = [1];
nx = 1; % Number of states
nu = 1; % Number of inputs
ref = 1;

% Prediction horizon
N = 4;
% States x(k), ..., x(k+N)
x = sdpvar(repmat(nx,1,N),repmat(1,1,N));
% Inputs u(k), ..., u(k+N) (last one not used)
u = sdpvar(repmat(nu,1,N),repmat(1,1,N));

J{N} = 0;

options = sdpsettings('solver','gurobi');

for k = N-1:-1:1    

    % Feasible region
    constraints = [-5 <= x{k}     <= 5,
                   -5 <= x{k+1}   <= 5];

    % Dynamics
    constraints = [constraints, x{k+1} == A*x{k}+B*u{k}];

    % Cost in value iteration
    %objective = norm(x{k},1) + norm(u{k},1) + J{k+1}
    objective = (x{k} - ref)'*(x{k}-ref) + (u{k})'*(u{k}) + J{k+1};

    % Solve one-step problem    
    [sol{k},dgn{k},Uz{k},J{k},uopt{k}] = solvemp(constraints,objective,[],x{k},u{k});
end

%% closed loop simulation

o = 0;

for i = 1:400
    assign(x{1},o(i))
    o(i+1) = A*o(i) + B*value(uopt{1});
end

plot(o)
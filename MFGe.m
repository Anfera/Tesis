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

agentes = zeros(500,400); %500 agentes en 100 intervalos de tiempo
dist = zeros(500,400);
dist(100:105,150) = 1;

agentes(:,1) = random('norm',1,0.5,500,1); %Distribución inicial
tic
for i = 1:400 %tiempo
    for j = 1:500 %agentes
        assign(x{1},[agentes(j,i);mean(agentes(:,i))]);
        u_ = value(uopt{1});
        agentes(j,i+1) = agentes(j,i) + B(1,1)*u_ + dist(j,i);
    end
    [i,400]
end
toc
plot(agentes')

% o = 0;
% 
% for i = 1:30
%     assign(x{1},[o(i);1])
%     o(i+1) = A(1,1)*o(i) + B(1,1)*value(uopt{1});
% end
% 
% plot(o)
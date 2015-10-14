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

agentes1(:,1) = random('norm',-2,0.5,100,1); %Distribución inicial
agentes2(:,1) = random('norm',-1,0.5,100,1);
agentes3(:,1) = random('norm',0,0.5,100,1);
agentes4(:,1) = random('norm',1,0.5,100,1);
agentes5(:,1) = random('norm',2,0.5,100,1);
p = [agentes1(:,1) agentes2(:,1) agentes3(:,1) agentes4(:,1) agentes5(:,1)];
p = mean(p)';

tic
for k = 1:400 %tiempo
    for i = 1:100 %agentes
        p(:,k+1) = p(:,k) - 0.01*Q*p(:,k);
        
        assign(x{1},[agentes1(i,k); p(1,k)]);
        u_ = value(uopt{1});
        agentes1(i,k+1) = agentes1(i,k) + B(1,1)*u_;
        
        assign(x{1},[agentes2(i,k); p(2,k)]);
        u_ = value(uopt{1});
        agentes2(i,k+1) = agentes2(i,k) + B(1,1)*u_;
        
        assign(x{1},[agentes3(i,k); p(3,k)]);
        u_ = value(uopt{1});
        agentes3(i,k+1) = agentes3(i,k) + B(1,1)*u_;
        
        assign(x{1},[agentes4(i,k); p(4,k)]);
        u_ = value(uopt{1});
        agentes4(i,k+1) = agentes4(i,k) + B(1,1)*u_;
        
        assign(x{1},[agentes5(i,k); p(5,k)]);
        u_ = value(uopt{1});
        agentes5(i,k+1) = agentes5(i,k) + B(1,1)*u_;
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
toc



% o = 0;
% 
% for i = 1:30
%     assign(x{1},[o(i);1])
%     o(i+1) = A(1,1)*o(i) + B(1,1)*value(uopt{1});
% end
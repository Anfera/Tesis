%% Prueba de MFG con Barcelona
yalmip('clear')
clear all
clc

Episodis = [ {'15-08-2006'} %  6 overflows
    {'17-09-2002'} %  3 overflows
    {'09-10-2002'} %  9 overflows
    {'30-07-2011'} % NO overflows
    {'05-01-2002'}
    {'31-07-2002'}
    {'12-09-2002'}
    ];

episodi = Episodis{6};

% Cargamos los datos de la red
eval(sprintf('load Bernat/Dades/%s.mat',episodi));
load('Bernat/Topologia.mat')

%% Empezamos el MFG
% Model data
A = [1 0; 0 1];
B = [-1; 0];
nx = size(A,1); % Number of states
nu = size(B,2); % Number of inputs
Q = [1 -1;-1 1];

% Prediction horizon
N = 10;
% States x(k), ..., x(k+N)
x = sdpvar(repmat(nx,1,N),repmat(1,1,N));
% Inputs u(k), ..., u(k+N) (last one not used)
u = sdpvar(repmat(nu,1,N),repmat(1,1,N));

J{N} = 0;

for k = N-1:-1:1    

    % Feasible region
    constraints = [-100 <= x{k}     <= 100,
                   -100 <= x{k+1}   <= 100];

    % Dynamics
    constraints = [constraints, x{k+1} == A*x{k}+B*u{k}];

    % Cost in value iteration
    %objective = norm(x{k},1) + norm(u{k},1) + J{k+1}
    objective = 100*(x{k})'*Q*(x{k}) + (u{k})'*(u{k}) + J{k+1};

    % Solve one-step problem    
    [sol{k},dgn{k},Uz{k},J{k},uopt{k}] = solvemp(constraints,objective,[],x{k},u{k});
end

%% Iteramos el lazo cerrado
load('Bernat/Topologia.mat')

v = zeros(size(A,2),1);
lluvia = Ac*CAT;
u = [];
for i = 1:size(CAT,2)-1 %tiempo
    for j = 1:length(A) %agentes
        assign(x{1},[v(j,i); mean(v(:,i))]);
        %assign(x{1},[v(j,i); 0]);
        u(j,:) = max(0,value(uopt{1}));
    end
    v(:,i+1) = v(:,i) +(A- eye(length(A)))*u + lluvia(:,i)./60;
    [v(:,i+1) u]
    [i size(CAT,2)-1]
end
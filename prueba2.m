N = 5;
A = [1];
B = [0.1];
C = [1];
[H,S] = create_CHS(A,B,C,N);
x = sdpvar(2,1);
U = sdpvar(N,1);

Y = H*(x(1)-x(2))+S*U;

objective = Y'*Y+U'*U;

F = [1 >= U >= -1];
F = [F, 1 >= Y(N) >= -1]; 

F = [F, 5 >= x(1) >= -5];

[sol,diagnostics,aux,Valuefunction,Optimizer] = solvemp(F,objective,[],x,U(1));
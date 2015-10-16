clear all
close all
clc

N = 30; % Prediction Horizon

tini = clock;
t0   = clock;

%% Dades B�siques: topologia, model, episodi, objectiu.

load Topologia.mat;

ind1 = 139;

load ParametresRieraBlanca.mat
load Matrius.mat

model_diposits = false;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
Episodis = [ {'15-08-2006'} %  6 overflows
    {'17-09-2002'} %  3 overflows
    {'09-10-2002'} %  9 overflows
    {'30-07-2011'} % NO overflows
    {'05-01-2002'}
    {'31-07-2002'}
    {'12-09-2002'}
    ];

Objectiu = [{'Flood'} {'WWTP'} {'CSO'} {'Obj1'} {'Obj2'}];

episodi = Episodis{6};
obj = Objectiu{5};

dt = 60;
T  = 10;

eval(sprintf('load Dades/%s.mat',episodi));
%eval(sprintf('load ResultatsSimulacio/%s.mat',episodi));

CAT = 1.*CAT;
CAT = [CAT 0*CAT];

%% Dades OCP: dimensions, horitz�

%N = 20;
%N = 10;

nn  = (N-1) + N;
nfc = 2;% f_c, \delta_{f_c}
nx  = nv + nl + 2*nw + 5*nf + nn + nfc + ng;

neq   = nl + nv + nf + nn;      % # de restriccions d'igualtat
nineq = 6*nw + 6*nf + 6*nf + 6; % # de restriccions de desigualtat

H    = length(CAT(1,:));
Hsim = H;
%Hmpc = H-30;
%H    = 30;
Hmpc = H-40;
H    = 40;

fprintf('\n\n                   H = %d                   \n\n\n',H);

vmax = [102524 54918];
vfcmax = 0.9*6.4490e4; %vfcmax = 5.2730e4;

Val   = zeros(Hmpc,2);
X     = zeros(nx*Hmpc,1);
X0    = zeros(nx*(T+1),1);
Xinit = zeros(nx*H,1);
XH    = zeros(nx*H,Hmpc/5);
qmax  = 100*ones(1,nl);
aw(1) = 1;
Qw(1) = 100;


%% Matrius

run('MPC1TD/Matrius1TD'); 
run('MPC1TD/MatriusOverflowCollector');
run('MPC1TD/MatriusOpt.m');
run('MPC1TD/Ms.m');
run('MPC1TD/Ns.m');
run('MPC1TD/Rs.m');
run('MPC1TD/Ss.m');
run('MPC1TD/GateBounds.m');
run('MPC1TD/Gates5min.m');


%% Problema d'optimitzaci�: determinaci� dels valors de G

Eq   = [  Mx1 ;  Rx1 ; MG ];
Ineq = [  Nx1 ;  Sx1 ; DG ];


wmax = 40*ones(size(wmax));

lb = zeros(1,nv+nl+2*nw+5*nf);
ub = [ vmax qmax wmax' ones(1,nw) fmax' ...
    ones(1,nf) vtmax' qtmax' ones(1,nf) ];

run('MPC1TD/Inicialitzacions.m');

%% CPLEX

%options = cplexoptimset('cplex');
%options.mip.tolerances.absmipgap = 0;
%options.mip.tolerances.mipgap = 0;
%options.MaxTime = 5*60; % this means the time limit is 30 sec.

%% Guarda les Matrius per usar en el Closed Loop

%break

save                   MatriusOCP.mat f Eq Ineq Mx1 Mx2 Mx3 Rx1 Rx2 Rx3 Nx1 Nx2 Nx3 Sx1 Sx2 Sx3 LB UB CTYPE nx  nx nv nl nw nf ng nn T  links weirs gates catchments tanks dt Bg Qw Qf b aw af neq nineq Rc req dgmin dgmax mg B Efc Efcv Efcq Efcg Efcd Efcc vfcmax ub lb gmax dgmax N ctype;
%save ../ClosedLoop1TD/MatriusOCP.mat f Eq Ineq Mx1 Mx2 Mx3 Rx1 Rx2 Rx3 Nx1 Nx2 Nx3 Sx1 Sx2 Sx3 LB UB CTYPE nx  nx nv nl nw nf ng nn T  links weirs gates catchments tanks dt Bg Qw Qf b aw af neq nineq Rc req dgmin dgmax mg B Efc Efcv Efcq Efcg Efcd Efcc vfcmax ub lb gmax dgmax N ctype;

%save ../Observador/MatriusOCP.mat f Eq Ineq Mx1 Mx2 Mx3 Rx1 Rx2 Rx3 Nx1 Nx2 Nx3 Sx1 Sx2 Sx3 LB UB CTYPE nx  nx nv nl nw nf ng nn T  links weirs gates catchments tanks dt Bg Qw Qf b aw af neq nineq Rc req dgmin dgmax mg B Efc Efcv Efcq Efcg Efcd Efcc vfcmax ub lb  gmax dgmax N ctype;
%save ../Observador2/MatriusObs.mat N M0 M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 N0 N1 N2 N3 N4 N5 N6 N7 N8 N9 N10 N11 R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 R10 S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 Efc Efcv Efcq Efcg Efcd Efcc Rc vfcmax lb ub ctype zq_ind p_model;
%save ../Observador2/MatriusObs.mat

%system('copy Matrius.mat "..\ClosedLoop1TD\Matrius.mat"');
%system('copy Matrius.mat "..\Observador\Matrius.mat"');

fprintf('Matrius calculades!!\n\n');

break

fprintf('Sq(3,ind(1)) = 1;\n');
fprintf('Sq(3,ind(2)) = 1;\n\n');

%Hmpc = 400;
Hmpc = 100;

Xmpc = zeros(Hmpc/5,nx*H);
X00  = zeros(Hmpc/5,T*nx+nx);

for ii = 1:Hmpc/5
    
    t = (ii-1)*5;
    
    run MPC1TD/Actualitza.m % Actulitza els termes independents en funci� de X0 i CAT
    
    eq   = [ -Mx2*X0 + Mx3 ; -Rx2*X0 + Rx3 ; mg ];
    ineq = [ -Nx2*X0 + Nx3 ; -Sx2*X0 + Sx3 ; dg ];
    
    %% OCP!
    
    % whos f Ineq ineq Eq eq LB UB CTYPE Xinit
    [XX,fval,exitflag,output]  = cplexmilp(f,Ineq,ineq,Eq,eq,[],[],[],LB,UB,CTYPE,Xinit,options);
    
    fprintf('%2d) %d (t=%d) %f\n',ii,exitflag,t,output.time);
    
    if exitflag < 0
        
        %XX,fval,exitflag,output]  = cplexmilp(f,Ineq,ineq,Eq,eq,[],[],[],LB1,UB,CTYPE,Xinit,options);
        %X(nx*(Hmpc-5*ii)+1:nx*(Hmpc-5*(ii-1))) = XX(nx*(H-5)+1:nx*H);
        
        disp(output)
        EditSol;
        error('INFEASIBLE!!!')
        
    end
    
    Xmpc(ii,:) = XX';
    
    EditSolAux;
    
    %fprintf('%f\t%f\t%f\t%f\t%f\n',fval,ffc*XX,fof*XX,fcso*XX,fwwtp*XX);
    %fprintf('%f\t%f\t%f\t%f\t%f\n\n', 10*(sum(full(fc)))+sum(sum(full(F)))+sum(full(Q(143,:)+Q(144,:)))-1e-1*sum(full(Q(145,:))), ...
    %                                  10*(sum(full(fc))),sum(sum(full(F))),sum(full(Q(143,:)+Q(144,:))),-1e-1*sum(full(Q(145,:))));
    
    
    
    Xaux = XX;
    XH(:,ii) = XX;
    
    X(nx*(Hmpc-5*ii)+1:nx*(Hmpc-5*(ii-1))) = XX(nx*(H-5)+1:nx*H);
    
    X0 = [ XX((H-5)*nx+1:H*nx) ; X0(1:nx*(T-4)) ];
    X00(ii,:) = X0;
    
    Xinit = [ XX(1:nx) ; XX(1:nx*(H-1)) ];
    
end

%%
EditSol;
CalculaQout;

break

%%
eval(sprintf('save ResultatsMPC1TD/N%02d-%s.mat',N,episodi));





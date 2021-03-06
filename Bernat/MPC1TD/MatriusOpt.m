CondicionsInicials;

%% Matrius MILP

aux = AQ1*Q1 + AQ2*Q2 + AQ3*Q3 + AQ4*Q4   + AQ5*Q5 + AQ6*Q6 + ... 
      AQ7*Q7 + AQ8*Q8 + AQ9*Q9 + AQ10*Q10 + AC*C0;


Aeq = [ eye(nv) zeros(nv,nl+2*nw+2*nf) zeros(nv,3*nf+nn+nfc) ;
        zeros(nl,nv) eye(nl) -AW  zeros(nl,nw) -AF zeros(nl,2*nf) -AT zeros(nl,nf+nn+nfc) ;
        zeros(nf,nv+nl+2*nw+2*nf) eye(nf) zeros(nf,2*nf+nn+nfc);
        zeros(N,nv+nl+2*nw+5*nf) MV0 zeros(N,nfc) ;
        zeros(N-1,nv+nl+2*nw+5*nf) MQ0 zeros(N-1,nfc) ];
    
%%

Aineq = [ zeros(6*nw,nv) EZw*Sw*A*A0 EW+EZw*Sw*max(0,Aw) EDw zeros(6*nw,3*nf) EZw*Sw*At zeros(6*nw,nf+nn+nfc) ;
          zeros(6*nf,nv) EZf*Sf*A*A0    EZf*Sf*max(0,Aw) zeros(6*nf,nw) EF EDf zeros(6*nf,nf) EZf*Sf*At zeros(6*nf,nf+nn+nfc) ;
          zeros(6*nf,nv) EZt*Sf*A*A0    EZt*Sf*max(0,Aw) zeros(6*nf,nw) EFt zeros(6*nf,nf) EVt-1/dt*EQt EQt+EZt*Sf*At EDt zeros(6*nf,nn+nfc);
          zeros(6,nv)    Efcq    zeros(6,2*nw+5*nf) [zeros(6,N-1) Efcv] Efc Efcd];

%%

Aeq   = sparse(Aeq);
Aineq = sparse(Aineq);

%% Tipus de variable: 'C' = cont�nua, 'B' = booleana.

for i = 1:nx
    
    ctype(i) = 'C';
    
end

for i = [ [nv+nl+nw+1:1:nv+nl+2*nw] [nv+nl+2*nw+nf+1:nv+nl+2*nw+2*nf] [nv+nl+2*nw+4*nf+1:nv+nl+2*nw+5*nf] ]
    
    ctype(i) = 'B';
    
end

% dfc
ctype(nv+nl+2*nw+5*nf+nn+nfc) = 'B';


seq = 5;

Sg = sparse(seq,ng);
Sv = sparse(seq,nv);
Sww = sparse(seq,nw);
Sq = sparse(seq,nl);
Sn = sparse(seq,nn);

% Ineq 1: g9 <= w3
Sg(1,9) = 1;
Sww(1,3) = 1;
%Sq(1,68) = 1; 

% Ineq 2: g3 + g6 <= v2/dt
% Sg(2,3) = 1;
% Sg(2,6) = 1;
% Sv(2,2) = 1/dt;

% Ineq 3: g8 <= q50 + q56;
ind = strmatch(gates(8,2),links(:,3),'exact');
Sg(3,8)  = 1;
%Sq(3,50) = 1;
%Sq(3,56) = 1;
Sq(3,ind(1)) = 1;
Sq(3,ind(2)) = 1;

% Ineq 4: g4 + g5 <= v1/dt
% Sg(4,4) = 1;
% Sg(4,5) = 1;
% Sv(4,1) = 1/dt;

% Ineq 5: sum(Vc) < vfcmax
Sn(5,(N-1)+1:(N-1)+N) = ones(1,N);

S0 = [ -Sv -Sq*A0 -Sww zeros(seq,nw+5*nf) Sn zeros(seq,nfc) Sg ];

for k = 1:T
   
    eval(sprintf('S%d = [ zeros(seq,nv) -Sq*A%d zeros(seq,2*nw + 5*nf + nn + nfc + ng) ];',k,k))
   
end

Sx0 = sparse(seq*H,nx*(H+T+1));

for j = 1:T+1 % i.e. 0 .. T
    
    eval(sprintf('Saux = S%d;',j-1));
    
    for i = 1:H
        
        Sx0( seq*(i-1)+1:seq*i, nx*(i-1)+nx*(j-1)+1:nx*i+nx*(j-1) ) = Saux; 
        
    end
    
end

Sx1 = Sx0(:,1:nx*H);
Sx2 = Sx0(:,nx*H+1:nx*(H+T+1));

%Sx3 = zeros(seq*H,1);
sx3 = zeros(seq,1);
sx3(5) = vfcmax;
Sx3 = repmat(sx3,H,1);



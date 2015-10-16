%req = 2;
req = 1;

Rg = sparse(req,ng);
Rq = sparse(req,nl);
Rc = sparse(req,nc);

% Equació 1
ind = strmatch(gates(1,2),links(:,3),'exact');
%Rq(1,28)  = 1;
%Rq(1,39)  = 1;
Rq(1,ind(1)) = 1;
Rq(1,ind(2)) = 1;
Rg(1,1)      = 1;
Rg(1,2)      = 1;
Rc(1,67)     = 1;

% Equació 2
%ind = strmatch(gates(10,2),links(:,3),'exact');
%Rq(2,146) = 1;
%Rq(2,ind) = 1;
%Rg(2,10) = 1;

R0 = [ zeros(req,nv) -Rq*A0 zeros(req,2*nw+5*nf+nn+nfc) Rg ];

for k = 1:T
   
    eval(sprintf('R%d = [ zeros(req,nv) -Rq*A%d zeros(req,2*nw + 5*nf + nn + nfc + ng) ];',k,k))
   
end

Rx0 = sparse(req*H,nx*(H+T+1));

for j = 1:T+1 % i.e. 0 .. T
    
    eval(sprintf('Raux = R%d;',j-1));
    
    for i = 1:H
        
   
        Rx0( req*(i-1)+1:req*i, nx*(i-1)+nx*(j-1)+1:nx*i+nx*(j-1) ) = Raux; 
        
    end
    
end

Rx1 = Rx0(:,1:nx*H);
Rx2 = Rx0(:,nx*H+1:nx*(H+T+1));
Rx3 = zeros(req*H,1);



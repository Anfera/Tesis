N0 = [ Aineq [ EZw*Sw*max(0,Ag) ; EZf*Sf*max(0,Ag) ; EZt*Sf*max(0,Ag) ; Efcg ]];

for k=1:T

    eval(sprintf('N%d = sparse( - [ zeros(6*nw,nv) -EZw*Sw*A*A%d zeros(6*nw,2*nw+5*nf+nn+nfc+ng) ; zeros(6*nf,nv) -EZf*Sf*A*A%d zeros(6*nf,2*nw+5*nf+nn+nfc+ng) ; zeros(6*nf,nv) -EZt*Sf*A*A%d zeros(6*nf,2*nw+5*nf+nn+nfc+ng) ; zeros(6,nx) ] );',k,k,k,k));

end

N11 = sparse(nineq,nx);

Nx0 = sparse(nineq*H,nx*(H+T+1));

for j = 1:T+2 % i.e. 0 .. T
    
    eval(sprintf('Naux = N%d;',j-1));
    
    for i = 1:H
   
        Nx0( nineq*(i-1)+1:nineq*i, nx*(i-1)+nx*(j-1)+1:nx*i+nx*(j-1) ) = Naux; 
        
    end
    
end

Nx1 = Nx0(:,1:nx*H);
Nx2 = Nx0(:,nx*H+1:nx*(H+T+1));
Nx3 = zeros(nineq*H,1);




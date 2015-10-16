M0 = [ Aeq [zeros(nv,ng) ; -AG ; zeros(nf+nn,ng)] ];

% M1 = sparse(-[ eye(nv) dt*Bq*A0 zeros(nv,2*nw + 5*nf + ng) ;
%                zeros(nl,nv) AQ1 zeros(nl,2*nw + 5*nf + ng) ;
%                zeros(nf,nv+nl+2*nw) dt*eye(nf) zeros(nf,nf) eye(nf) -dt*eye(nf) zeros(nf,nf+ng) ]);

M1 = sparse(-[ eye(nv) dt*Bq*A0 zeros(nv,2*nw + 5*nf+nn+nfc) dt*Bg ;
               zeros(nl,nv) AQ1 zeros(nl,2*nw + 5*nf + nn + nfc + ng) ;
               zeros(nf,nv+nl+2*nw) dt*eye(nf) zeros(nf,nf) eye(nf) -dt*eye(nf) zeros(nf,nf+nn+nfc+ng);
               zeros(N,nv) Kq139 zeros(N,2*nw+5*nf) -MV1 Kf zeros(N,1) Kg7;
               zeros(N-1,nx)]);

%M2 = [ zeros(nv,nv) dt*Bq*A1 zeros(nv,2*nw + 5*nf + ng) ;
%       zeros(nl,nv)      AQ2 zeros(nl,2*nw + 5*nf + ng) ;
%       zeros(nf,nv+nl+2*nw+5*nf+ng) ];

for k = 2:T
   
    eval(sprintf('M%d = sparse(-[ zeros(nv,nv) dt*Bq*A%d zeros(nv,2*nw + 5*nf + nn + nfc + ng) ; zeros(nl,nv) AQ%d zeros(nl,2*nw + 5*nf + nn + nfc + ng) ; zeros(nf,nv+nl+2*nw+5*nf+nn+nfc+ng) ; zeros(nn,nv+nl+2*nw+5*nf+nn+nfc+ng)]);',k,k-1,k))
   
end

M11 = sparse(-[ zeros(nv,nv) dt*Bq*A10 zeros(nv,2*nw + 5*nf + nn + nfc + ng) ;
                zeros(nl,nv+nl+2*nw+5*nf+nn+nfc+ng) ;
                zeros(nf,nv+nl+2*nw+5*nf+nn+nfc+ng) ;
                zeros(nn,nv+nl+2*nw+5*nf+nn+nfc+ng) ]);
          
Mx1 = sparse(neq*H,nx*H);
Mx2 = sparse(neq*H,nx*(T+1));
Mx0 = sparse(neq*H,nx*(H+T+1));

for j = 1:T+2 % i.e. 0 .. T+1
    
    eval(sprintf('Maux = M%d;',j-1));
        
    for i = 1:H
           
        Mx0( neq*(i-1)+1:neq*i , nx*(i-1)+nx*(j-1)+1:nx*i+nx*(j-1) ) = Maux; 
        
    end
    
end

Mx1 = Mx0(:,1:nx*H);
Mx2 = Mx0(:,nx*H+1:nx*(H+T+1));
Mx3 = zeros(neq*H,1);



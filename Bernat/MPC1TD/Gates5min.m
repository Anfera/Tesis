%% Gates Constants Cada 5 min

n_block = 5;

mg = sparse(ng,nx);
Mg = sparse((n_block-1)*ng,n_block*nx);
MG = sparse((n_block-1)*H/n_block*ng,H*nx);

% g1 i g2 no compleixen la restricció
%mg(:,nx-ng+1:end) = diag([0 0 1 1 1 1 1 1 1 1]);%eye(ng);
mg(:,nx-ng+1:end) = diag([1 0 1 1 1 1 1 0 1 1]);%eye(ng);



for i = 1:n_block-1
    
    Mg((i-1)*ng+1:i*ng,(i-1)*nx+1:(i-1)*nx+2*nx) = [mg -mg];
    
end

for i = 1:H/n_block
   
    MG((i-1)*(n_block-1)*ng+1:i*(n_block-1)*ng , (i-1)*n_block*nx+1:i*n_block*nx) = Mg;
    
end

mg = zeros((n_block-1)*H/n_block*ng,1);




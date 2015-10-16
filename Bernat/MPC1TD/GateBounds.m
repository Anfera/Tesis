dgmax = 10*ones(ng,1);

dgmax(1) = 5;
dgmax(2) = 15;
dgmax(3) = 2;
dgmax(4) = 2;
dgmax(5) = 2;
dgmax(6) = 2;
dgmax(7) = 15;%4;
dgmax(8) = 2;

dgmin = -dgmax;
dgmin(7) = -5;%4;

B = sparse([zeros(ng,nv+nl+2*nw+5*nf+nn+nfc) eye(ng)]);

BB = [ B -B ; -B B ];

DG = sparse(2*ng*H,nx*H);

for i = 1:H-1
    
    DG( 1+(i-1)*2*ng:i*2*ng , 1+(i-1)*nx:i*nx+nx) = BB;
    
end

DG(2*ng*(H-1)+1:2*ng*H,nx*(H-1)+1:nx*H) = [B;-B];






VCmax    = 100*dt*ones(N,1);
VCmax(N) = vfcmax;
QCmax    = 1e2*ones(N-1,1);

%% Matrius Volum

Kq  = zeros(N,N-1);
Kf  = zeros(N,1);  Kf(1)  = -dt; %Kf(N)  = -dt;

for j = 1:N-1
    
    Kq(j:j+1,j) = dt*[-1 1]';
    
end

%% M's

 % Xc = [ Qc Vc fc dc ];

MV0 = sparse([ zeros(N,N-1) eye(N)]);
MV1 = sparse([ -Kq -eye(N)]);

MQ0 = sparse([ eye(N-1) -1/dt*[eye(N-1) zeros(N-1,1)] ]);

%%

Kq139 = zeros(N,nl); Kq139(1,139) = dt;
Kg7   = zeros(N,ng); Kg7(N,7) = -dt;

%%

ubC = [ QCmax' VCmax' 1e2 1 ];
lbC = zeros(1,nn+nfc);



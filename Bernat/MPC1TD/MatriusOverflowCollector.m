epsilon = 1e-10;

% % L'entrada a l'últim dipòsit Vc(N,:) és Qc(N-1,:)
% PqN = zeros(1,N-1);
% PqN(N-1) = 1;

% L'entrada al primer dipòsit Vc(1,:) és Q(139,:)
Pq139 = zeros(1,nl);
Pq139(139) = 1;

%PvN = zeros(1,N);
%PvN(N) = 1;
PvN = ones(1,N);

Pg7 = zeros(1,ng);
Pg7(7) = 1;

mfc = -gmax(7) - vfcmax/dt;
Mfc = qmax(139);

Efc  = [ 0 0 1 -1 1 -1 ]';

Efcv = 1/dt*[ -1 1 0 0 -1 1 ]'*PvN;

Efcq = [ -1 1 0 0 -1 1 ]'*Pq139;

Efcg = [ 1 -1 0 0 1 -1 ]'*Pg7;

Efcd = [ -mfc -Mfc-epsilon -Mfc mfc -mfc Mfc ]';

Efcc = [ vfcmax/dt+mfc epsilon-vfcmax/dt 0 0 vfcmax/dt+mfc -Mfc-vfcmax/dt ]';

break

%%

plot([fc 1/dt*max( 0 , sum(Vc)' + dt*Q(139,:)'-dt*G(7,:)'-vfcmax)]);






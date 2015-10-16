%% Condicions inicials

for j = 1:T+2
    
    eval(sprintf('Q%d  = zeros(nl,1);',j-1));
    
end

W0  = zeros(nw,1);
G0  = zeros(ng,1);
G1  = zeros(ng,1);
C0  = zeros(nc,1);
V1  = zeros(nv,1);

F1  = zeros(nf,1);
Qt1 = zeros(nf,1);
Vt1 = zeros(nf,1);

Qn1 = zeros(nn,1);




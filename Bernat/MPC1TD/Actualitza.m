t = t+5;

%% M's

for i = 1:H
    
    Mx3((i-1)*neq+1:i*neq) = sparse([ zeros(nv,1) ; AC*CAT(:,t+H-i+1) ; zeros(nf+nn,1)]);
    C(:,i)  = CAT(:,t+i);

end

%% N's

for i = 1:H
    
    Nx3((i-1)*nineq+1:i*nineq) = sparse([ -EZw*Sw*Ac*CAT(:,t+H-i+1)-Ecw ; ...
                                          -EZf*Sf*Ac*CAT(:,t+H-i+1)-Ecf ; ...
                                          -EZt*Sf*Ac*CAT(:,t+H-i+1)-Ect ;
                                                                   -Efcc]);
    
end


%% R's

for i = 1:H
    
    Rx3((i-1)*req+1:i*req) = Rc*CAT(:,t+H-i+1);
    
end

%% S's

% No hi ha terme independent en 't'

%% Gate Bounds

dg = repmat([dgmax;-dgmin],H,1);
dg(2*ng*(H-1)+1:2*ng*H) = dg(2*ng*(H-1)+1:2*ng*H) - [-B;B]*X0(1:nx);

%% Gates5min

% No hi ha terme independent en 't'





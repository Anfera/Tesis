%obj = 'Flood';
c = zeros(1,nx);
cfc = zeros(1,nx);
cof = zeros(1,nx);
ccso = zeros(1,nx);
cwwtp = zeros(1,nx);

c(nv+139) = .05;

%% Overflow Col.lector

c(nv+nl+2*nw+5*nf+nn+1) = 10;

%% Minimització d'Overflws
if strcmp(obj,'Flood')

c(nv+nl+2*nw+1:nv+nl+2*nw+nf) = ones(1,nf);


%% Minimització de CSO
elseif strcmp(obj,'CSO')

c(nv+143) = 1;
c(nv+144) = 1;


%% Maximització de WWTP
elseif strcmp(obj,'WWTP')

c(nv+145) = -1e-1;


%% Minimització d'Overflws + CSO
elseif strcmp(obj,'Obj1')

% Overflows
c(nv+nl+2*nw+1:nv+nl+2*nw+nf) = ones(1,nf);

% CSO
c(nv+143) = 1;
c(nv+144) = 1;


%% Minimització d'Overflows + CSO & Maximització WWTP
elseif strcmp(obj,'Obj2')

% Overflows
c(nv+nl+2*nw+1:nv+nl+2*nw+nf) = ones(1,nf);

% CSO
c(nv+143) = 1;
c(nv+144) = 1;

% WWTP
c(nv+145) = -1e-1;

end


%% f's mono-objectiu

cfc(nv+nl+2*nw+5*nf+nn+1) = 10;
cof(nv+nl+2*nw+1:nv+nl+2*nw+nf) = ones(1,nf);
ccso(nv+143) = 1;
ccso(nv+144) = 1;
cwwtp(nv+145) = -1e-1;

ffc = repmat(cfc,1,H);
fof = repmat(cof,1,H);
fcso = repmat(ccso,1,H);
fwwtp = repmat(cwwtp,1,H);

cg7 = zeros(1,nx);
cg7(nv+nl+2*nw+5*nf+nn+nfc+7) = -1;
fg7 = repmat(cg7,1,H);



gmax = 30*ones(1,ng);
gmax(10) = 2;
gmax(7)  = 50;
%gmax(2)  = 100;
gmax(1)  = 15;
gmax(2)  = 15;
%gmax(1)  = 30;
%gmax(2)  = 30;

gmax(3) = 10;
gmax(4) = 10;
gmax(5) = 10;
gmax(6) = 10;

gmin = zeros(1,ng);

ub = [ub ubC gmax];
lb = [lb lbC gmin];

UB = sparse(repmat(ub,1,H));
LB = sparse(repmat(lb,1,H));
CTYPE = repmat(ctype,1,H);

Objectius;

f = repmat(c,1,H);

Xinit = sparse(nx*H,1);

UB = full(UB);
LB = full(LB);


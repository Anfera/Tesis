% %%
% 
% Bn = [0 0;1 1];
% 
% bn = zeros(nn,nl);
% bn(:,ind1) = [ dt ; 0 ];
% 
% bg = zeros(nn,ng);
% bg(:,7) = [ 0 ; -dt ];

%%

Bn = 1;

bn = zeros(nn,nl);
bn(ind1) = dt;

bg = zeros(nn,ng);
bg(7) = -dt;


return

%%

v(:,1) = [ 0 ; 0 ];

for i = 1:H-1
   
    v(:,i+1) = Bn*v(:,i)+bn*Q(:,i)+bg*G(:,i);
        
end

plot(v'-Qn');

%%

plot(dt*cumsum(Q(141,:)))

%%

%plot([dt*cumsum(beta(1)*Qn(1,:)'-G(8,:)') Qn(2,:)'])
plot([cumsum(Qn(1,:)'-dt*G(7,:)') Qn(2,:)'])

%%
plot([G(7,:)' -  Q(142,:)'])



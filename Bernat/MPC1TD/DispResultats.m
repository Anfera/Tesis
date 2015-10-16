eval(sprintf('fid = fopen(''../ResultatsMPC-Diposits/%s-%s.txt'',''w'')',episodi,obj));

%%
fprintf('----------------------------------------------\n');
fprintf('\t\t  %s (H = %d) %s\n',episodi,Hmpc,obj);
fprintf('----------------------------------------------\n');
fprintf('\nVariables contínues: %d\n',(nv+nl+nw+3*nf)*H);
fprintf('Variables enteres: %d\n',(nw+2*nf)*H);
fprintf('\nRestriccions d''igualtat: %d\n',neq*H);
fprintf('Restriccions de desigualtat: %d + %d = %d\n',nineq*H,2*nx*H,nineq*H+2*nx*H);
%fprintf('\nFunció objectiu: %f\n',fval);
fprintf('\nTemps total: %f\n\n',etime(clock,t0));
fprintf('----------------------------------------------\n\t');
fprintf('%s\n',output.message);
fprintf('----------------------------------------------\n');
fprintf('\nVolum overflow: %f',dt*full(sum(sum(F))));
fprintf('\nVolum overflow (NO CONTROL): %f\n',dt*sum(sum(Fsim(:,1:Hsim))));
fprintf('\nVolum CSO: %5.2f\n',dt*full(sum(Q(145,:)+Q(146,:))));
fprintf('Volum CSO (NO CONTROL): %5.2f\n', dt*full(sum( QIN(145,1:Hsim) + QIN(146,1:Hsim) + max(2,QIN(147,1:Hsim))-2 )) );
fprintf('\nVolum WWTP: %f\n',dt*full(sum(Q(147,:))));
fprintf('Volum WWTP (NO CONTROL): %5.2f\n\n',dt*sum(min(2,QIN(147,1:Hsim))));
fprintf('Mass Balance: IN=%f\tOUT=%f\n',sum(sum(CAT(:,1:5*ii))),sum(full(Q(145,1:ii*5)+Q(146,1:ii*5)+Q(147,1:ii*5)))+sum(full(Vt(:,end)))/dt+V(1,ii*5)/dt+V(2,ii*5)/dt);

fprintf(fid,'----------------------------------------------\n');
fprintf(fid,'\t\t  %s (H = %d) %s\n',episodi,Hmpc,obj);
fprintf(fid,'----------------------------------------------\n');
fprintf(fid,'\nVariables contínues: %d\n',(nv+nl+nw+3*nf)*H);
fprintf(fid,'Variables enteres: %d\n',(nw+2*nf)*H);
fprintf(fid,'\nRestriccions d''igualtat: %d\n',neq*H);
fprintf(fid,'Restriccions de desigualtat: %d + %d = %d\n',nineq*H,2*nx*H,nineq*H+2*nx*H);
%fprintf(fid,'\nFunció objectiu: %f\n',fval);
fprintf(fid,'\nTemps total: %f\n\n',etime(clock,t0));
fprintf(fid,'----------------------------------------------\n\t');
fprintf(fid,'%s\n',output.message);
fprintf(fid,'----------------------------------------------\n');
fprintf(fid,'\nVolum overflow: %f',dt*full(sum(sum(F))));
fprintf(fid,'\nVolum overflow (NO CONTROL): %f\n',dt*sum(sum(Fsim(:,1:Hsim))));
fprintf(fid,'\nVolum CSO: %5.2f\n',dt*full(sum(Q(145,:)+Q(146,:))));
fprintf(fid,'Volum CSO (NO CONTROL): %5.2f\n', dt*full(sum( QIN(145,1:Hsim) + QIN(146,1:Hsim) + max(2,QIN(147,1:Hsim))-2 )) );
fprintf(fid,'\nVolum WWTP: %f\n',dt*full(sum(Q(147,:))));
fprintf(fid,'Volum WWTP (NO CONTROL): %5.2f\n\n',dt*sum(min(2,QIN(147,1:Hsim))));
fprintf(fid,'Mass Balance: IN=%f\tOUT=%f\n',sum(sum(CAT(:,1:5*ii))),sum(full(Q(145,1:ii*5)+Q(146,1:ii*5)+Q(147,1:ii*5)))+sum(full(Vt(:,end)))/dt+V(1,ii*5)/dt+V(2,ii*5)/dt);

eval(sprintf('save MPC-%s(Hmpc=%d)%sLLARG.mat;',episodi,Hmpc,obj));

fclose(fid);

fprintf('TEMPS TOTAL: %f\n',etime(clock,tini));
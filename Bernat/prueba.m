%% Prueba
clear all
clc

load('Topologia.mat')
load('Dades/15-08-2006.mat')
aux = [];

for i = 1:size(links,1)
    for j = 1:size(links,2)
        for k = 1:length(catchments)
            if strcmp(links(i,j),catchments(k))
                aux = [aux;links(i,j)];
            end
        end
    end
end

aux = unique(aux);

size(aux);

aux2 = unique(catchments);

size(aux2);

for i = 1:length(catchments)
    for j = 1:length(catchments)
        if (i ~= j && strcmp(catchments(i),catchments(j)))
            [i,j];
        end
    end
end

%%
flujo = Ac*CAT;

aux3 = sum(flujo,2);

aux4 = double(aux3 ~= 0);

sum(aux4)

hola = zeros(145,1);

for i = 1:length(flujo)
    hola(:,i+1) = hola(:,i) + (A)*flujo(:,i);
end

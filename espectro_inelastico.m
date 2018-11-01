function [t, sax, say] = espectro_inelastico(categoria, zona, suelo, tx, ty, r0, tmax, doplot, tmaxplot)
%ESPECTRO_INELASTICO Genera el espectro inelastico.
%
%   [t, sax, say] = espectro_inelastico(categoria, zona, suelo, tx, ty, r0)
%   [t, sax, say] = espectro_inelastico(categoria, zona, suelo, tx, ty, r0, tmax)
%   [t, sax, say] = espectro_inelastico(categoria, zona, suelo, tx, ty, r0, tmax, doplot)
%   [t, sax, say] = espectro_inelastico(categoria, zona, suelo, tx, ty, r0, tmax, doplot, tmaxplot)
%
% En donde:
%   categoria       Categoria (1, 2, 3, 4) o (i, ii, iii,iv)
%   zona            Zona sismica (1, 2, 3)
%   suelo           Tipo suelo (A, B, C, D, E)
%   tx              Periodo fundamental de la estructura en eje x
%   ty              Periodo fundamental de la estructura en eje y
%   r0              Valor de la estructura obtenido de la norma
%   tmax            Periodo maximo
%   doplot          Indica si grafica o no
%   tmaxplot        Periodo maximo a graficar
%
% Ejemplos de uso:
%   [t, sax, say] = espectro_inelastico(1, 3, 'c', 0.077, 0.044, 11, 10, true);

%% Inicia variables
if ~exist('tmax', 'var')
    tmax = 10.0;
end
if ~exist('doplot', 'var')
    doplot = false;
end
if ~exist('tmaxplot', 'var')
    tmaxplot = 3.0;
end

%% Calcula espectro elastico
[t, sa] = espectro_elastico(categoria, zona, suelo, tmax, doplot, tmaxplot, false);
maxelems = length(t);

%% Obtiene parametros del suelo
[~, t0, ~, ~, ~] = sparam(suelo);

%% Calcula factor reduccion R*
rx = 1 + tx / (0.1 * t0 + tx / r0);
ry = 1 + ty / (0.1 * t0 + ty / r0);
fprintf('Rx*: %.4f\n', rx);
fprintf('Ry*: %.4f\n', ry);

%% Calcula espectros reducidos
sax = sa ./ rx;
say = sa ./ ry;

%% Grafica
if doplot
    hold on;
    plot(t, sax, 'LineWidth', 1);
    plot(t, say, 'LineWidth', 1);
    legend({'Espectro elástico', 'Espectro inelastico x', 'Espectro inelastico y'}, ...
        'location', 'northeast');
end

%% Guarda los resultados
fileID = fopen('esp-x.txt', 'w');
for i = 1:maxelems
    fprintf(fileID, '%f\t%f', t(i), sax(i));
    if i < maxelems
        fprintf(fileID, '\n');
    end
end
fclose(fileID);
fileID = fopen('esp-y.txt', 'w');
for i = 1:maxelems
    fprintf(fileID, '%f\t%f', t(i), say(i));
    if i < maxelems
        fprintf(fileID, '\n');
    end
end
fclose(fileID);

end
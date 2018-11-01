function [t, sa] = espectro_elastico(categoria, zona, suelo, tmax, doplot, tmaxplot, savef)
%ESPECTRO_ELASTICO Calcula el espectro elastico.
%
%   [t, sa] = espectro_elastico(categoria, zona, suelo);
%   [t, sa] = espectro_elastico(categoria, zona, suelo, tmax);
%   [t, sa] = espectro_elastico(categoria, zona, suelo, tmax, doplot);
%   [t, sa] = espectro_elastico(categoria, zona, suelo, tmax, doplot, tmaxplot);
%   [t, sa] = espectro_elastico(categoria, zona, suelo, tmax, doplot, tmaxplot, savef);
%
% En donde:
%   categoria       Categoria (1, 2, 3, 4) o (i, ii, iii,iv)
%   zona            Zona sismica (1, 2, 3)
%   suelo           Tipo suelo (A, B, C, D, E)
%   tmax            Periodo maximo
%   doplot          Indica si grafica o no
%   tmaxplot        Periodo maximo a graficar
%   savef           Guarda un archivo
%
% Ejemplo:
%   [t, sa] = espectro_elastico(1, 3, 'c', 10, true);

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
if ~exist('savef', 'var')
    savef = false;
end

%% Obtiene categoria (importancia)
categoria = lower(categoria);
if categoria == 1 || categoria == 'i'
    imp = 0.6;
elseif categoria == 2 || categoria == 'ii' %#ok<BDSCA>
    imp = 1.0;
elseif categoria == 3 || categoria == 'iii' %#ok<BDSCA>
    imp = 1.2;
elseif categoria == 4 || categoria == 'iv' %#ok<BDSCA>
    imp = 1.2;
else
    error('Categoria desconocida');
end

%% Obtiene aceleracion
zona = lower(zona);
if zona == 1
    a0 = 0.2;
elseif zona == 2
    a0 = 0.3;
elseif zona == 3
    a0 = 0.4;
else
    error('Zona sismica desconocida');
end
a0 = a0 * 9.80665;

%% Obtiene parametro de suelo
[s, t0, ~, ~, p] = sparam(suelo);

%% Genera arreglo de periodo
maxelems = 1000;
t = linspace(0, tmax, maxelems)';
sa = zeros(1, maxelems)';

%% Calcula el espectro
for i = 1:maxelems
    sa(i) = s * a0 * imp * (1 + 4.5 * (t(i) / t0)^p) / (1 + (t(i) / t0)^3);
end

%% Grafica el espectro
if doplot
    plot(t, sa, 'k', 'LineWidth', 1.0);
    title('Espectro de Diseño Nch433 DS.61');
    xlabel('Periodo T [s]', 'interpreter', 'latex');
    ylabel('Aceleracion Espectral ($m/s^2$)', 'interpreter', 'latex');
    grid on;
    grid minor;
    xlim([0, tmaxplot]);
    legend({'Espectro elástico'}, 'location', 'northeast');
end

%% Guarda los resultados
if savef
    fileID = fopen('esp-el.txt', 'w');
    for i = 1:maxelems
        fprintf(fileID, '%f\t%f', t(i), sa(i));
        if i < maxelems
            fprintf(fileID, '\n');
        end
    end
    fclose(fileID);
end

end
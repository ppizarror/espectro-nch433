function [s, t0, t, n, p] = sparam(t)
%SPARAM Retorna los parametros segun el tipo de suelo, parametros validos:
%   [s, t0, t, n, p] = sparam(t);
%
% En donde p: A, B, C, D, E

%% Convierte a lowercase
t = lower(t);

%% Retorna segun tipo de suelo
if t == 'a'
    s = 0.90;
    t0 = 0.15;
    t = 0.20;
    n = 1.0;
    p = 2.0;
elseif t == 'b'
    s = 1.0;
    t0 = 0.30;
    t = 0.35;
    n = 1.33;
    p = 1.5;
elseif t == 'c'
    s = 1.05;
    t0 = 0.40;
    t = 0.45;
    n = 1.40;
    p = 1.6;
elseif t == 'd'
    s = 1.20;
    t0 = 0.75;
    t = 0.85;
    n = 1.80;
    p = 1.0;
elseif t == 'e'
    s = 1.30;
    t0 = 1.20;
    t = 1.35;
    n = 1.80;
    p = 1.0;
else
    error('Tipo de suelo desconocido o no soportado');
end

end
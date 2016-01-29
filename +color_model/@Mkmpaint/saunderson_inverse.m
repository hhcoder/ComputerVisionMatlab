function [ret] = saunderson_inverse( src )
K1 = 0.01;
K2 = 0.4;
ret = K1 + ((1-K1)*(1-K2)*src) ./ ( 1 - K2*src );
end
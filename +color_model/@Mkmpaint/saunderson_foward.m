function [ret] = saunderson_foward( src )
    ref = src / max(max(src));
    K1 = 0.01;
    K2 = 0.4;
    ret = ( ref  - K1 ) ./ ( 1 - K1 - K2 + K2.*ref  );
end
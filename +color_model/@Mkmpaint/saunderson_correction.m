function [ret] = saunderson_correction( src )
    K1 = 0.04;
    K2 = 0.4;
    ret = ( src - K1 ) ./ ( 1 - K1 - K2 + K2.*src );
    larger_than_zero = ret > 0;
    ret = ret .* larger_than_zero;
end

function [ret] = saunderson_inverse( src )

end
function [ret] = ref2KS( src )
    ret = ( (1 - src) .^ 2 ) ./ ( 2 .* src );
end
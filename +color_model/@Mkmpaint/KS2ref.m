function [ret] = KS2ref( KS )
    ret = 1.0 + (KS) - sqrt( (KS).^2 + 2*(KS) );
end
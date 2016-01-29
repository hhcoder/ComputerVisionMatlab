function [ret] = KS2reflectance( KS )
    ref = 1.0 + (KS) - sqrt( (KS).^2 + 2*(KS) );
    ret = scale_to_one(ref);
end
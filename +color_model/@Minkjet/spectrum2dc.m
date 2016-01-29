function mreturn = spectrum2dc( obj, in_spectrum, ctrl )

    if nargin < 3
        ctrl = obj.spectrum2area_guess( in_spectrum );
    end

    areas = obj.spectrum2area( in_spectrum, ctrl );
    mreturn = obj.area2dc( areas );
    
end
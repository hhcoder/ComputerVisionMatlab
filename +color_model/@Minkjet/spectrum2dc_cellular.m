function mreturn = spectrum2dc_cellular( obj, in_spectrum, area_guess )

    if nargin < 3
        ctrl = obj.spectrum2area_guess( in_spectrum );
    end

    areas = obj.spectrum2area_cellular( in_spectrum, area_guess );
    mreturn = obj.area2dc( areas );
    
end
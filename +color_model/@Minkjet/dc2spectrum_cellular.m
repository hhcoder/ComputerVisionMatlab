function mreturn = dc2spectrum_cellular( obj, in_dcs )
    in_areas = obj.dc2area( in_dcs );
    mreturn = obj.area2spectrum_cellular( in_areas );
end


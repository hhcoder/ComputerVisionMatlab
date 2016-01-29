function mreturn = dc2spectrum( obj, in_dcs )
    in_areas = obj.dc2area( in_dcs );
    mreturn = obj.area2spectrum( in_areas );
end


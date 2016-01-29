function mreturn = ref2srgb( ref, cmf, illum )
    xyz = color_tool.ref2xyz(ref, cmf, illum );
    x = xyz(1)./sum(xyz);
    y = xyz(2)./sum(xyz);
    z = 1 - x - y;

    xyz_new = [x; y; z ];

    cfsrgb = makecform( 'xyz2srgb' );
    srgbnew = applycform( xyz_new', cfsrgb );
    
    mreturn = srgbnew;
end
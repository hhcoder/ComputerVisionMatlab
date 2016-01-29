function mreturn = ref2xy( ref, cmf, illum )
    xyz = color_tool.ref2xyz( ref, cmf, illum );
    mreturn = color_tool.xyz2xy(xyz);
end
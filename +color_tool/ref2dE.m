function ret = ref2dE(ref1, ref2, cmf1, cmf2, illum1, illum2 )
    XYZ1 = color_tool.ref2xyz( ref1, cmf1, illum1 );
    XYZ2 = color_tool.ref2xyz( ref2, cmf2, illum2 );
    
    ret = color_tool.xyz2dE( XYZ1, XYZ2 );
end
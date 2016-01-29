function xyz = srgb2xyz(srgb)
    cfsrgb2xyz = makecform('srgb2xyz');
    xyz = applycform(srgb,cfsrgb2xyz);
end
function lab = ref2lab( ref, cmf, illum, wp )
    xyz = color_tool.ref2xyz(ref, cmf, illum );
    lab = color_tool.xyz2lab( xyz, wp );
end
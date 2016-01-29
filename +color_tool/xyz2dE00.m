function dE00 = xyz2dE00( xyz1, xyz2, wp )
    lab1 = color_tool.xyz2lab( xyz1, wp );
    lab2 = color_tool.xyz2lab( xyz2, wp );
    
    dE00 = color_tool.deltaE00(lab1, lab2);
end
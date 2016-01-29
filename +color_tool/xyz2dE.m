function dE = xyz2dE( xyz1, xyz2, wp )
    lab1 = color_tool.xyz2lab( xyz1, wp );
    lab2 = color_tool.xyz2lab( xyz2, wp );
    
    dE = sqrt( sum( (lab1-lab2).^2 ) );
end
% XYZ2LMS - transform the XYZ triplet values to LMS cone responses 
% 
% Usage: imlms = xyz2lms( imxyz )
% 
% Arguments:
%    imxyz - the xyz triplet values
%
% Returns:
%    imlms - the lms triplet values
function imlms = xyz2lms( imxyz )
    Mhpe = [ 0.38971, 0.68898, -0.07868;...
            -0.22981, 1.18340,  0.04641;...
             0.00000, 0.00000,  1.00000 ];

    imlms = color_tool.im2matrix( imxyz, Mhpe );
end
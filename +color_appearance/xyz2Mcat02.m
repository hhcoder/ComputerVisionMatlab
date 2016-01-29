% XYZ2MCAT02 - transform the XYZ triplet values to MCAT02 adapted triplet
% values 
%
% Usage: imcat = xyz2Mcat02( imxyz )
%
% Argument:
%    imxyz - input XYZ triplet values
%
% Returns:
%    imcat - resultant adapted triplet values

function imcat = xyz2Mcat02( imxyz )
    Mcat02 = [  0.7382 0.4296 -1.624; ...
               -0.7036 1.6975 0.0061; ...
                0.0030 0.0136 0.9834 ];

    imcat = color_tool.im2matrix( imxyz, Mcat02 );
end
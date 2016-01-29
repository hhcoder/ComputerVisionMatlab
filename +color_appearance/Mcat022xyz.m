% MCAT022XYZ - transform the MCAT02 adapted triplet values back to XYZ
%
% Usage: imxyz = Mcat022xyz( imcat )
%
% Argument:
%    imcat - input triplet values
%
% Returns:
%    imxyz - resultant XYZ triplet values

function imxyz = Mcat022xyz( imcat )
    Mcat02 = [  0.7382 0.4296 -1.624; ...
               -0.7036 1.6975 0.0061; ...
                0.0030 0.0136 0.9834 ];
            
	invMcat02 = inv(Mcat02);
    
    imxyz = color_tool.im2matrix( imcat, invMcat02 );

end
% LMS2XYZ - transform the LMS cone responses back to XYZ space
% 
% Usage: imxyz = lms2xyz( imlms )
% 
% Arguments:
%    imlms - the lms triplet values
%
% Returns:
%    imxyz - the resultant xyz triplet values
function imxyz = lms2xyz( imlms )
    Mhpe = [ 0.38971, 0.68898, -0.07868;...
            -0.22981, 1.18340,  0.04641;...
             0.00000, 0.00000,  1.00000 ];
            
	invMhpe = inv(Mhpe);
    
    imxyz = color_tool.im2matrix( imlms, invMhpe );

end
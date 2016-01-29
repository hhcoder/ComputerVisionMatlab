% SRGB2LABETA - transform SRGB values to the adapted triplet values
% 
% For the labeta color space, please refer to ref1, it is introduced in the
% first or second chapter about human visual system.
%
% Usage: imlabeta = srgb2labeta( imsrgb )
%
% Arguments:
%    imsrgb - the input srgb triplet values
%
% Returns:
%    imlabeta - the resultant adapted triplet values
%
% Reference:
% [1] Eric Reinhard, Greg Ward, Sumanta Pattanaik, and Paul Debevec (August 2005). 
%  High Dynamic Range Imaging: Acquisition, Display, and Image-Based Lighting. 
%  Westport, Connecticut: Morgan Kaufmann. ISBN 0125852630., 

function imlabeta = srgb2labeta( imsrgb )
    imxyz = color_tool.srgb2xyz( imsrgb );
    imlms = color_appearance.xyz2lms( imxyz );
    
    A = [ 1./sqrt(3) 0 0;...
          0 1./sqrt(6) 0;...
          0 0 1./sqrt(2); ];
    B = [ 1  1  1;...
          1  1 -2;...
          1 -1  0; ];
    M2labeta = A * B;
    
    imlabeta = color_tool.im2matrix( imlms, M2labeta );
    
end
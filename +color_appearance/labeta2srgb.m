% LABETA2SRGB - transform the adapted triplet values to SRGB values
%
% For the labeta color space, please refer to ref1, it is introduced in the
% first or second chapter about human visual system.
% 
% Usage: imsrgb = labeta2srgb( imlabeta )
% 
% Arguments:
%    imlabeta - the input adapted triplet values
%
% Returns:
%    imsrgb - the resultant srgb triplet values

function imsrgb = labeta2srgb( imlabeta )
    A = [ 1  1  1;...
          1  1 -1;...
          1 -2  0; ];
    B = [ sqrt(3)./3 0 0;...
          0 sqrt(6)./6 0;...
          0 0 sqrt(2)./2; ];
    invM2labeta = A * B;

    imlms = color_tool.im2matrix( imlabeta, invM2labeta );
    
    imxyz = color_appearance.lms2xyz( imlms );

    imsrgb = color_tool.xyz2srgb( imxyz, [1 1 1] );

end
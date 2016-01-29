% LDR2SRGB - transform the LDR image to gamma corrected sRGB color space
% 
% Arguments: 
%    ldr - input image
%    gamma - the mapping gamma value
%
% Returns:
%    srgb - the image mapped onto SRGB color space
function srgb = ldr2srgb( ldr, gamma )

if nargin < 2
    % default sRGB gamma value
    gamma = 2.2;
end

    srgb = ( ldr./max(max(max(ldr))) ).^(1./gamma);

end
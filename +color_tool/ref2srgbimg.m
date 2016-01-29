% REF2SRGBIMG - transform the measure reflectances into SRGB patch image
%
% This function transforms the input reflectances into SRGB color patch
% images (like the Macbeth color checker). 
%
% Usage: patch_img = ref2srgbimg(ref,cmf,illum,wp,patch_w,patch_h,mopcode)
%
% Arguments: 
%    ref - input reflectance with MxN, where M is the number of patches,
%          and N is the measure length of wavelength, i.e., for 380:10:720,
%          N is 35
%    cmf - the color matching function, cmf, which should be calculated
%          from color_tool.cie_struct
%    illum - the reflectance of illumination source, should be Nx1
%    wp - white point value, if not specified, a perfect white is given
%    patch_w, patch_h - pixel width and height of output patch, if not
%                       specified, 250 is given.
%    mopcode - 'show figure' or 'not'


function patch_img = ref2srgbimg( ...
    ref,...
    cmf, illum,wp,...
    patch_w, patch_h, mopcode)

if nargin < 5
    patch_w = 250;
    patch_h = 250;
end

xyz_patch = color_tool.ref2xyzpatches( ...
    ref,...
    cmf, illum,...
    patch_w, patch_h,...
    4,...
    6);

if nargin < 4
    % Perfect as white point
    wp = color_tool.ref2xyz( ones(1,size(ref,2)), cmf, illum );
end

if nargin < 7
    mopcode = 'show figure';
end

patch_img = color_tool.xyz2srgb( xyz_patch, wp );

if strcmpi(mopcode, 'show figure')
    figure,
    imshow(patch_img);
end

end

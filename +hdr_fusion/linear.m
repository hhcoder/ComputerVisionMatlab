% LINEAR - HDR image fusion without ghost removal
%
% Usage:
%   hdr = linear(fnames, fpath)
%
% Arguments:
%   fnames - input file names
%   fpath - input file path
%
% Returns:
%   hdr - the generated HDR image file
%

function hdr = linear(fnames, fpath)
    if nargin < 1
        [fnames,fpath] = img_acquire.jpggetfiles( );
    end
    hdr = hdr_fusion.srgb2hdr( fpath, fnames );
end
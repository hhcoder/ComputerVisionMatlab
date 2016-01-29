% IM2VIDEO - Transform images into video format, notice the images should
%            have the same dimension
%
% Usage:
%    mreturn = im2video( fpath, fnames )
%
% Arguments:
%    fpath - input file path
%    fnames - input file names

function mreturn = im2video( fpath, fnames )

    if nargin < 1
        [fnames,fpath] = uigetfile(...
                    {'*.JPG'},'Select the JPEG-file',...
                    'MultiSelect','on');
    end

    fnames = sort(fnames);
    im1st = im2double( imread(strcat(fpath,fnames{1})) );
    frames = length(fnames);
    v = zeros( size(im1st,1), size(im1st,2), size(im1st,3), frames );
    
    v(:,:,:,1) = im1st;
    for i=2:frames
        v(:,:,:,i) = im2double( imread(strcat(fpath,fnames{i})) );
    end
    
    mreturn = v;
end
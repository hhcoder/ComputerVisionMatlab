% HDRGETFILES - read single HDR images with user interface
%
% Usage: [fnames,fpath] = hdrgetfiles( )
%
% Returns:
%   fnames - files names in cell array
%   fpath - file path
%
function [fnames,fpath] = hdrgetfiles( )
    [fnames,fpath] = uigetfile(...
                {'*.*','*.HDR'},'Select the HDR-file',...
                'MultiSelect','off');
end
% JPGGETFILES - read multiple JPEG images with user interface
%
% Usage: [fnames,fpath] = jpggetfiles( )
%
% Returns:
%   fnames - files names in cell array
%   fpath - file path
%
function [fnames,fpath] = jpggetfiles( )
    [fnames,fpath] = uigetfile(...
                {'*.*','*.JPG'},'Select the JPEG-file',...
                'MultiSelect','on');
            
    % Sort the names to assure all input files in sequence
    fnames = sort(fnames);
    
    len = length( fnames );
    if len < 2
        error('Input images should not be less than 2');
    end

end
% IOBUF class - create a io buffer object to be able to load multiple
% images quickly
%
% This class can load multiple images into buffer. User can fetch these
% files by giving the iobuf object the filename. The iobuf actually contains
% limited number of images, and when user requires those images do not in
% the buffer, it will load again. This function is especially useful when
% dealing with video sqeuence images.
%
% Usage:
%     obj = img_acquire.iobuf( ifpath, ifnames, ibufsize )
% 
% Argument:
%     ifpath - the file path
%     ifnames - the file names
%     ibufsize - setup the buffer size
%
% Example:
%
%    % Get multiple images 
%    [fnames, fpath] = uigetfile( ...
%        {'*.*', 'All Files(*.*)'}, 'Pick a file', 'MultiSelect', 'on');
%    imbuffer = img_acquire.iobuf(fpath,fnames);
%
%    % format the image into color
%    imbuffer.format('color', 1.0 );
%
%    % looping all images, apply Gaussian blur onto each image
%    for imcnt = 1:length(fnames)
%        im = imbuffer.fnames2im(fnames{imcnt});
%        imblr = imfilter(im, fspecial('gaussian'));
%    end

classdef iobuf < handle
    properties
        fpath;
        fnames;
        bufnames;
        bufsize;
        buf;
        opcode_color;
        opcode_size;
    end
    
    methods
        % Constructor
        function obj = iobuf( ifpath, ifnames, ibufsize )
            
            obj.fpath = ifpath;
            obj.fnames = sort(ifnames);
            if nargin < 3
                obj.bufsize = 100;   % as default buffer size
            else
                obj.bufsize = ibufsize;
            end
            
            obj.bufsize = min(length(ifnames),obj.bufsize);
            
            obj.bufnames = cell(obj.bufsize,1);
            obj.buf = cell(obj.bufsize,1);
            h = waitbar(0,'Loading image buffer...');
            % Loading the images into memory
            for i=1:obj.bufsize
                obj.bufnames{i} = obj.fnames{i};
                obj.buf{i} = im2double( imread(strcat(obj.fpath,obj.bufnames{i})) );
                waitbar(i./obj.bufsize);
            end
            close(h);
        end
        
        function format( obj, opcode1, opcode2 )
            obj.opcode_color = opcode1;
            obj.opcode_size = opcode2;
        end
        
        function im = fnames2im( obj, ifname )
            % Search if the specified name in the file list
            for i=1:obj.bufsize
                if strcmp(ifname,obj.bufnames{i})
                    indicator = i;
                    break;
                else
                    indicator = -1;
                end
            end
            
            if indicator == -1
                % Case that the image is not loaded -> load images 2 buf
                for j=1:length(obj.fnames)
                    if strcmp(ifname,obj.fnames{j})
                        flocator = j;
                        break;
                    else
                        flocator = -1;
                    end
                end
                if flocator == -1
                    error('Input file name is not in the folder');
                else
                    % Read in whole buffer or the remaining files and
                    % update the buffer content
                    rin_fcnt = min( length(obj.fnames)-flocator, obj.bufsize );
                    h = waitbar(0, 'Loading image buffer');
                    for i=1:rin_fcnt
                        obj.bufnames{i} = obj.fnames{flocator+i-1};
                        obj.buf{i} = im2double( imread(strcat(obj.fpath,obj.bufnames{i})) );
                        waitbar(i./rin_fcnt);
                    end
                    close(h);
                    if rin_fcnt > 0
                        im = obj.fnames2im(ifname);
                    else
                        im = 0;
                        return;
                    end
                end
            else
                src = obj.buf{indicator};
                % Case that the image is loaded
                switch obj.opcode_color
                    case 'color'
                        im = src;
                    case 'gray'
                        if size(src,3) ~= 1
                            im = rgb2gray(src);
                        else
                            im = src;
                        end
                end
                
                if obj.opcode_size ~= 1.0
                    im = imresize(im, obj.opcode_size );
                end
            end
        end
    end
        
end
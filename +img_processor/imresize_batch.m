% IMRESIZE_BATCH - batch resize images
% 
% This function can let user specified multiple JPEG images then resize
% them and write back with 's' at end of file name, i.e., the smaller
% version of 'IM00001.jpg' is 'IM00001s.jpg'. This function is especially
% useful when we wish to test algorithms on multiple smaller images.
%
% Usage:
%     imresize_batch( scale, gray )
%
% Arguments:
%     scale - the scaling factor to resize
%     gray - enable/disable to write out the gray channel only
%
function imresize_batch( scale, gray )
    
    if nargin < 2
        gray = 0;
    end
    
    if nargin < 1
        scale = 0.5;
    end
    
    [fnames,fpath] = uigetfile(...
                {'*.JPG','*.*'}, 'Select the JPEG-file',...
                'MultiSelect','on');

    h = waitbar(0,'Applying Batch Resizing...');
    set(h,'Name','Resize in Progress');

    for i = 1:length(fnames)
        img = imread(strcat(fpath,fnames{i}));
        
        if gray
            ch0 = rgb2gray(imresize(img, scale));
            imwrite( ch0, strcat(fpath, 's', fnames{i}));
        else
            ch1 = imresize(img(:,:,1),scale);
            ch2 = imresize(img(:,:,2),scale);
            ch3 = imresize(img(:,:,3),scale);
            imwrite( cat(3,ch1,ch2,ch3), strcat(fpath,'s',fnames{i}));
        end
        waitbar(i./length(fnames));
    end
    
    close(h);

end
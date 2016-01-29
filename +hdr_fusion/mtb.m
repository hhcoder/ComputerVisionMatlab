% MTB - the Mean Threshold Bitmap algorithm
%
% Usage:
%   hdr = mtb(fnames, fpath)
%

function hdr = mtb(fnames, fpath)

    if nargin < 1
        [fnames,fpath] = img_acquire.jpggetfiles( );
    end
    
    fnames = sort(fnames);
    len = length(fnames);

    h = waitbar(0,'Applying MTB hdr image fusion...');
    set(h,'Name','MTB in Progress');
    
    prev_img = imread(strcat(fpath,fnames{1}));
    
    ih = size(prev_img,1);
    iw = size(prev_img,2);
    
    dy = zeros(len,1);
    dx = zeros(len,1);

    for i=2:len
        next_img = imread(strcat(fpath,fnames{i}));
        
        % Mean threshould
        img1 = img_processor.im2binary(prev_img,'percent+threshold+exclusion', .5, 4);
        img2 = img_processor.im2binary(next_img,'percent+threshold+exclusion', .5, 4);
        
%        figure, imshow(img1);
        [dy(i),dx(i)] = img_analyzer.im2motionest( ...
            img1, img2, ...
            [floor(ih./2), floor(iw./2)],...
            floor(ih./2+10),...
            -25:+25,...
            'xor+sum' );

        prev_img = next_img;        
        clear('next_img');
        
        waitbar((i-1)./(len-1));
    end
    
    close(h);
    
    hdr = hdr_fusion.srgb2hdr( fpath, fnames, dy, dx );

end


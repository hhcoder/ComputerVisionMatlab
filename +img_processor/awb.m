function ret = awb( im, mode, range )
    if nargin < 1
        mode = 'gray world';
        range = [1 size(im,1) 1 size(im,2)];
    end
    
    ret = im;
    
    rgain = (sum(sum(im(:,:,2)))./sum(sum(im(:,:,1))));
    ret(:,:,1) = im(:,:,1) .* rgain;
    
    bgain = (sum(sum(im(:,:,2)))./sum(sum(im(:,:,3))));
    ret(:,:,3) = im(:,:,3) .* bgain;
        
end
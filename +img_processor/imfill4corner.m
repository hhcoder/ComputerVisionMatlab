% IMFILL4COURNER - fill solid color at four corners of the image
%
% Usage:
%     imnew = imfill4corner( im, size, color )
%
% Arguments:
%     im - input image
%     size - the size (a scalar value) of square to put on four corner
%     color - useless parameter
% 
% Example:
%     imshow(img_processor.imfill4corner(im2double(imread('imsouthpark01.jpg'))));

function imnew = imfill4corner( im, size, color )

    if nargin < 2
        size = 10;
    end
    
    if nargin < 3
        color = cat(3, ones(size), zeros(size), ones(size) );
    end
    
    imnew = im;
    imnew(1:size,1:size,:) = color;
    imnew(1:size,end-size+1:end,:) = color;
    imnew(end-size+1:end,1:size,:) = color;
    imnew(end-size+1:end,end-size+1:end,:) = color;
   
end
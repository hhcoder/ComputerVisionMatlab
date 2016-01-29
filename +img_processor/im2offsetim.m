% IM2OFFSETIM - offset the image
%
% This function offset the image with (dx,dy) value and leave the blank
% part black.
%
% Argument:
%     src - source image
%     dy - vertical offset
%     dx - horizontal offset
%
% Returns:
%    mreturn - the offset image
%
% Example:
%     im = im2double(imread('imsouthpark01.jpg'));
%     im2 = img_processor.im2offsetim(im, 100, 100);
%     subplot(2,1,1), imshow(im), subplot(2,1,2), imshow(im2);

function mreturn = im2offsetim( src, dy, dx )
    h = size(src,1);
    w = size(src,2);
    dst = zeros(size(src));

    ydst = dst_range(h,dy);
    xdst = dst_range(w,dx);
    ysrc = src_range(h,dy);
    xsrc = src_range(w,dx);

    dst(ydst,xdst,:) = src(ysrc,xsrc,:);
    
    mreturn = dst;
        
end

function r = dst_range( h, dx )
    if dx > 0
        r = dx:h;
    else
        r = 1:(h+dx);
    end
end

function r = src_range( h, dx )
    if dx > 0
        r = 1:(h-dx+1);
    else
        r = (-dx+1):h;
    end
end

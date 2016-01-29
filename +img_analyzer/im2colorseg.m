% IM2COLORSEG - segement the color image by the saturation
% 
% This function do the color segmentation and returns the result with
% labeled image. Notice it supports only lab color space.
%
% Usage: [labels, numlabels] = im2colorseg( imrgb, level )
% 
% Arguments: 
%    imrgb - the input color image 
%    level - the threhold of generate bw image
% 
% Returns:
%    labels - the labeled image
%    numlabels - how many labels found in this image

function [labels, numlabels] = im2colorseg( imrgb, level )

    if size(im,3) < 3
        error('the color detection algorithm accepts only color images');
    end

    if nargin < 2
        level = 0.8;
    end
    
    cfrgb2lab = makecform('srgb2lab');
    imlab = applycform(imrgb, cfrgb2lab);
    
    % ============================================
    % ========== Color Taransformation ===========
    % ============================================
    im_a = imlab(:,:,2);
    im_b = imlab(:,:,3);
    
    % 128: maximal value of a*b* channel
    im_cab = sqrt( im_a.^2+im_b.^2 ) ./ 128;
    im_hab = atan( im_b ./ im_a );

    % Only segment based on saturation in current development stage
    im_binary = im2bw( im_cab, level );

    % ============================================
    % ========= Morphological Operations =========
    % ============================================
    se = strel('disk', 3);
    im_clean = imclose(im_binary,se);
    im_clean = imopen(im_clean,se);
%    im_clean = imclearborder(im_clean);

    [labels, numlabels] = bwlabel(im_clean);

end
% IM2MOTIONEST - calculate the block motion estimation between two images 
% using linear search method
%
% This function calculates the motion between images by block-based motion
% estimation with linear searching.
%
% Usage:
%     [dy,dx] = im2motionest( img1, img2, posyx, bsize, search_range,
%     compare_rule )
%
% Arguments:
%     img1 - first image
%     img2 - seconde image
%     posyx - the position of the block in (y,x)
%     bsize - scalar of block size
%     search_range - nxm searching range, for example, -16:15
%     compare_rule -
%                    'mse' - mean square error
%                    'sub+sum' - sum of subtraction
%                    'xor+sum' - sum of exclusive OR
%
function [dy,dx] = im2motionest( img1, img2, posyx, bsize, search_range, compare_rule )

    if strcmp(compare_rule,'lucas_kanade')
        [dy,dx] = lucas_kanade_est(img1(:,:,2), img2(:,:,2), posyx, bsize, search_range );
        return;
    end

    pos_y = floor(posyx(1)-bsize./2):floor(posyx(1)+bsize./2);
    pos_x = floor(posyx(2)-bsize./2):floor(posyx(2)+bsize./2);
    
    slen = length(search_range);
    diff = zeros(slen,slen);

    for i=1:slen
        for j=1:slen
            b1 = img1(pos_y,pos_x,:);
            b2 = img2(pos_y+search_range(j),pos_x+search_range(i),:);
            switch lower(compare_rule)
                case {'mse', 'sub+square+sum'}
                    diff(j,i) = sqrt(sum(sum(sum( (b1-b2).^2 ))));
                case 'sub+sum'
                    diff(j,i) = sum(sum(sum(b1-b2)));
                case 'xor+sum'
                    diff(j,i) = sum(sum(sum(xor(b1,b2))));
            end

        end
    end

    diffmin = ( diff==min(min(diff)) );
    
    if sum(sum(diffmin)) > 1
        dy = 0;
        dx = 0;
    else
        [y,x] = ind2sub( size(diff),find(diffmin, 1, 'first') );
        dy = search_range(y);
        dx = search_range(x);
    end
end

function [dy, dx] =lucas_kanade_est( imprev, imnext, posyx, bsize, search_range )

    % Thanks for D.Kroon 
    addpath('./_LucasKanade2/');

    Options.TranslationIterations=30;
    Options.AffineIterations=0;
    Options.RoughSigma=1.6;
    Options.FineSigma=1.3;
    Options.TolP = 1e-8;

    tpltmulti = struct;

    b=-round(bsize/2):round(bsize/2);

    [wys,wxs] = meshgrid(b,b);
    gausswin = @(I,sigma_len)(exp(-I./2.*(sigma_len.^2)) );
    weight = gausswin( sqrt(wys.^2+wxs.^2), 0.01);

    tpltmulti.p= [0 0 0 0 posyx(1) posyx(2)];
    tpltmulti.weight = weight;
    tpltmulti.image= imprev(posyx(1)+b, posyx(2)+b);

    [new_point, roi_img, errorval] = ...
                LucasKanadeInverseAffine( imnext, tpltmulti.p, tpltmulti.image, tpltmulti.weight, Options );
    xpos = new_point(6);
    ypos = new_point(5);
    
    dy = posyx(1)-ypos;
    dx = posyx(2)-xpos;
end
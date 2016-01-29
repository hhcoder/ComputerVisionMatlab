% RUN_IP_DETECT_COLORPATCHES - detect colorful color patches in the input
%                              image
%
% This function use simple color segementation algorithm to find the
% position of colorful patches (highly-saturated) in the image.
% 
% Usage : [x,y] = run_ip_detect_colorpatches( im )
%
% Arguments: 
%   im - the input color image; if no input image, an example image will be
%   loaded
%   show_search_result - enable/disable the search result display
%   show_segment_result - enable/disable the segmented result display
% 
% Returns:
%   [xs,ys] - the [x,y] positions of color patches, if N patches is found,
%             the size of xs/ys is Nx1.

function [xs,ys] = run_ip_detect_colorpatches( im, show_search_result, show_segment_result )

    if nargin < 1
        im = im2double( imread('imchipmonkcorner.jpg') );
    end

    if nargin < 2
        show_search_result = 1;
    end

    if nargin < 3
        show_segment_result = 0;
    end

    [labels, numlabel] = img_analyzer.im2colorseg(im);

    if show_segment_result
        imshow(label2rgb(labels));
    end

    if show_search_result
        figure, imshow(im);
        hold on
    end

    xs = zeros(numlabel,1);
    ys = zeros(numlabel,1);

    for i=1:numlabel
        % the upper left index
        ul_idx = find((labels==i),1,'first');
        [ulx,uly] = ind2sub( size(labels), ul_idx );

        % the lower right index
        lr_idx = find((labels==i),1,'last');
        [lrx,lry] = ind2sub( size(labels), lr_idx);

        xs(i) = ulx + (lrx-ulx)./2;
        ys(i) = uly + (lry-uly)./2;

        if show_search_result
            % Text it!
            text(ys(i)+6,xs(i),sprintf('%d',i));
        end
    end

    if show_search_result
        drawnow;
        hold off
    end

end

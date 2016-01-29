% IM2HISTPERCENT - Calculate the pixel value based on given percent
%
% This function calculate the pixel value by giving the percentage. For
% example, percent = 0.01 means finding pixel value at the front 1% of 
% the histogram distribution.
%
% Usage:
%     i = im2histpercent( G, percent )
%
% Arguments:
%     G - input image
%     percent - the percentage
%
% Returns:
%     i = the pixel value
%
function i = im2histpercent( G, percent )
    if percent > 1.0
        m = percent;
    else
        m = floor( percent.*size(G,1).*size(G,2) );
    end

    if size(G,3) > 1
        error('Only gray image acceptable in current version');
    end

    counts = imhist(G);

    s = 0;
    for i=1:length(counts)
        s = s + counts(i);
        if s >= m
            break;
        end
    end

end

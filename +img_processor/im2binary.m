% IM2BINARY - transform the grayscale image into binary image
%
% Usage:
%     [b,i] = im2binary( img, opcode, percent, extravar )
%
% Arguments:
%     img - input image
%     opcode - the operation code, including:
%              'percent+value' - use value as the threshold value
%              'percent+threshold' - use the percentage of histogram as the
%              threshold value
%              'percent+threshold+exclusion'- use the percentage of
%              histogram and exclusion percentage
%              'value+threshold' - use percentage as the threshold value
%     extravar - the extravalue, only needed  when use option
%     'percent+threshold+exclusion'
% 
% Returns:
%     b - the binary image
%     i - the percentage calculated
%
function [b,i] = im2binary( img, opcode, percent, extravar )

    if size(img,3) > 1
        G = img(:,:,2);
    else
        G = img;
    end
    
    % only operates within 0~1
    if max(max(G)) > 1.0
        G = G./max(max(G));
    end

    switch lower(opcode)
        case {'percent+value'}
            b = G > percent;
        case {'percent+threshold'}
            i = img_analyzer.im2histpercent( G, percent );
            b = ( G > (i./256) );
        case {'percent+threshold+exclusion'}
            i = img_analyzer.im2histpercent( G, percent );
            b1 = G > (i./256+extravar);
            b2 = G > (i./256-extravar);
            b = and(b1,b2);
        case {'value+threshold'}
            i = percent;
            b = G./max(max(G)) > percent;
    end


end
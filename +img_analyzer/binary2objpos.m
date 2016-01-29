% BINARY2OBJPOS - Transfer from binary image to object position
% 
% This function searches for the object in binary image and returns their
% positions using image dilate/erode and border cleaning technique.
%
% Usage:
%     [pos, area, im_clean] = binary2objpos( im_binary, geosize, opcode1,
%     opcode2 )
%
% Argument:
%     im_binary - the input binary image
%     geosize - the size of morphology operator
%     opcode1 - the shape of morphology operator, 'disk' is the default
%     opcode2 - the shape of output area, 'rectangle' is the default
%
% Returns:
%     pos - Nx2 array for N objects and their (x,y) position
%     area - Nx1 array for the sizes of N objects
%     im_clean - the cleaned image

function [pos, area, im_clean] = binary2objpos( im_binary, geosize, opcode1, opcode2 )
    if nargin < 2
        geosize = 4;
    end
    
    if nargin < 3
        opcode1 = 'disk';
    end
    
    if nargin < 4
        opcode2 = 'rectangle';
    end
    
    se = strel(opcode1, geosize);

    im_clean = imclose(im_binary,se);
    im_clean = imopen(im_clean,se);
    im_clean = imclearborder(im_clean);
    
    [labels, numlabels] = bwlabel(im_clean);
    
    pos = cell(numlabels,1);
    area = cell(numlabels,1);
    tolerance = 1;
    for i=1:numlabels
        [x1,y1] = ind2sub( size(im_clean), find(labels==i, tolerance, 'first') );
        [x2,y2] = ind2sub( size(im_clean), find(labels==i, tolerance, 'last') );
        [y3,x3] = ind2sub( size(im_clean'), find(labels'==i, tolerance, 'first') );
        [y4,x4] = ind2sub( size(im_clean'), find(labels'==i, tolerance, 'last') );
        xpos = min([x1,x2,x3,x4]);
        ypos = min([y1,y2,y3,y4]);
        xwid = max([x1,x2,x3,x4])-xpos;
        ywid = max([y1,y2,y3,y4])-ypos;
        switch opcode2
            case {'four corner'}
                pos{i} = [ypos xpos ypos+ywid xpos+xwid];
            case {'rectangle'}
                pos{i} = [ypos xpos ywid xwid];
            case {'upper left'}
                pos{i} = [ypos xpos];
        end
        
        % Object area
        area{i} = sum(sum(labels==i));
    end
end
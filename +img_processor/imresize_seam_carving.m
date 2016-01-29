% IMRESIZE_SEAM_CARVING - do the seam carving algorithm on input image
%
% This function executes the seam-carving algorithm (see ref) on the input
% image. The seam-carving is a smart image resizeing algorithm which
% calculate the unwanted image pixel by the dynamic weighting value from
% image gradient. This function does not implement the dynamic programming
% part, which could be have best estimation on pixel removal. Also, this
% function does not implement the "enlarge" function (only shrink). 
%
% Usage: ret = imresize_seam_carving( srcimg, targetsize, axes )
%
% Argument: 
%    srcimg - input image
%    targetsize - target size, should be [x y]
%    axes - the figure handler to show the seam-carving procedure
%
% Return:
%    ret - the resized image
%
% References:
% [1] Seam Carving for Content-Aware Image Resizing. S. Avidan, A. Shamir,
% 2007, Siggraph.

function ret = imresize_seam_carving( srcimg, targetsize, axes )

    oysize = size(srcimg,1);
    dysize = targetsize(1);
    oxsize = size(srcimg,2);
    dxsize = targetsize(2);
    
    if dysize>oysize || dxsize>oxsize 
        error( 'Not support image enlarging');
    end

    % Initializing
    r2 = srcimg;

    for y=1:oysize-dysize
        [r1,r2] = img_analyzer.im2minseam( r2, 'y' );
        if axes
            imshow(r1, 'Parent', axes);
            drawnow;
            imshow(r2, 'Parent', axes);
            drawnow;
        end
    end

    for x=1:oxsize-dxsize
        [r1,r2] = img_analyzer.im2minseam( r2, 'x' );
        if axes
            imshow(r1, 'Parent', axes);
            drawnow;
            imshow(r2, 'Parent', axes);
            drawnow;
        end
    end
    ret = r2;

end


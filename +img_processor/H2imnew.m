% H2imnew - Apply homogeneous transformation on image
%
% This function applies the homogeneous transformation onto the im2 and
% output the new image as well as the translation. Remember to add the 
% '_PFCVM' folder to Matlab path to run the toolbox.
% 
% Usage:
%    [dy, dx, im2new] = H2imnew( im1, im2, H, show_two_images )
%
% Arguments:
%    im1 - the original image
%    im2 - the image to transform, which means, im2_coord = H * im1_coord
%    H - the 3x3 homogeneous matrix
%    show_to_images - enable/disable to show two images
%
% Returns:
%    dy - the vertical translation
%    dx - the horizontal translation
%    im2new - the new, transformed im2
%

function [dy, dx, im2new] = H2imnew( im1, im2, H, show_two_images )
    
    if nargin < 4
        show_two_images = 0;
    end

    % Hnorm is the normalized homogeneous matrixs
    Hi = inv(H./H(3,3));
    Hnorm = Hi./Hi(3,3);
    
    % The new image
    im2newsize = abs(Hnorm*[size(im2) 1]'- Hnorm*[1 1 1]');       
    [im2new, T2new] = imTrans(im2, Hnorm, [], max(im2newsize));
    T2new = T2new./T2new(1,1);
    
    % Translation
    dy = round( T2new(2,3) );
    dx = round( T2new(1,3) );
    
    if show_two_images
        figure, subplot(2,1,1), imshow(im1), title('im1'), subplot(2,1,2), imshow(im2new), title('im2new');
    end

end


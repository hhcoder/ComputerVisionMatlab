function run_harris_corner( im1color )

if size(im1color,3) > 1
    im1 = rgb2gray(im1color);
else
    im1 = im1color;
end


%% Show the Harris corner detection results
C = imadjust(cornermetric( im1, 'Harris'));
corner_peaks = imregionalmax(C);
corner_idx = find(corner_peaks == true);

if size(im1color,3) > 1
    [r g b] = deal(im1color);
else
    r = im1color(:,:,1);
    g = im1color(:,:,2);
    b = im1color(:,:,3);
end
r(corner_idx) = 255;
g(corner_idx) = 255;
b(corner_idx) = 0;
RGB = cat(3,r,g,b);
figure, imshow(RGB), title('Harris Corner');

end
function test_WhiteBoardDetect()

%White board detection
[fnames,fpath] = uigetfile(...
                {'*.jpg','*.bmp'},'Select the image file',...
                'MultiSelect','off');
            
img_src = imread( strcat(fpath, fnames) );

% To gray scale
img_src_gray = rgb2gray(img_src);

% Cropping
src = img_src_gray;
crop_ratio = 0.1;
crop_h = uint32(size(src,1).*crop_ratio);
crop_w = uint32(size(src,2).*crop_ratio);
dst_crop = img_src_gray(crop_h:size(src,1)-crop_h, crop_w:size(src,2)-crop_w);

% Check 1: histogram
src = dst_crop;
img_hist = imhist(src);

hist_thre_l = 185;
hist_thre_r = 255;
pixel_cnt_ratio_white = 0.65;
if( sum(img_hist(hist_thre_l:hist_thre_r)) >= (size(src,1)*size(src,2))*pixel_cnt_ratio_white )
    fprintf('Histogram test passed!\n');
else
    fprintf('Not a white board image - QUIT\n');
    return;
end

% Blur the image
src = dst_crop;
dst_blur = imfilter(src, fspecial('gaussian', [15 15]));

% Check 2: 
src_blur = dst_blur;
src_orig = dst_crop;

img_clear = src_orig - src_blur;
imshow(img_clear);

end
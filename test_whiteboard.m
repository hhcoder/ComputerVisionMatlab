%% First load and resize the image
im = im2double(imread('imwhiteboard3.jpg'));
%im_dn_1_2 = im2double(imresize(im, 1/2, 'bilinear'));
%im_up_1_2 = imresize(im_dn_1_2, 2/1, 'bilinear');
%im_dn_1_4 = im2double(imresize(im, 1/4, 'bilinear'));
%im_up_1_4 = imresize(im_dn_1_4, 4/1, 'bilinear');
%im_dn_1_8 = im2double(imresize(im, 1/8, 'bilinear'));
%im_up_1_8 = imresize(im_dn_1_8, 8/1, 'bilinear');
%im_dn_1_16 = im2double(imresize(im, 1/16, 'bilinear'));
im_up_1_16 = imresize(im_dn_1_16, 16/1, 'bilinear');
im_dn_1_32 = im2double(imresize(im, 1/32, 'bilinear'));
im_up_1_32 = imresize(im_dn_1_32, 32/1, 'bilinear');

imsubtract = @(im1, im2)( im1 - imresize(im2, [size(im1,1) size(im1,2)]) );

%% Run the algorithm


%im_median = imsubtract( im_up_1_4, im_up_1_16 );
%im_median = imsubtract( im_up_1_32,im_up_1_4);

%im_dog = imsubtract(...
%    img_processor.imfilter_gauss(im,3,0.01), ...
%    img_processor.imfilter_gauss(im,9,0.1) );

%%

im_background = im_up_1_16;
im_content = imsubtract(im_background,im);
im_pure_white = ones(size(im_content));
im_content_enhance = im_content;
im_recovered = imsubtract(im_pure_white, im_content_enhance);

%%

im_d_lpf = imsubtract(im,im_up_1_32);
%I = checkerboard(200,4,6);
%im_d_lpf = imsubtract( im, imfilter(im, fspecial('gaussian', [8 8])) );

im_replace = ones(size(im_d_lpf));
%tmp = I(1:size(im_d_lpf,1),1:size(im_d_lpf,2));
%im_replace = cat(3, tmp,tmp,tmp);
clear tmp;

imshow(im_d_lpf + im_replace);

%%
figure, imshow(im), title('Original image');
figure, imshow(imsubtract(im, im_median)), title('im - (im_up_1_32 - im_up_1_8)');
figure, imshow(imsubtract(im_up_1_32, im)), title('im - im_up_1_32');
figure, imshow(im_dog), title('im_dog');

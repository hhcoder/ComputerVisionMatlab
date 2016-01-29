% RUN_SIFT_TEST - do the sift matching between two input images
%
% This function execute the SIFT algorithm on two input images and maps the
% feature points from one to the other. The detail algorithm please refer
% to ref1.
%
% Usage: 
%    run_sift_test(im1color, im2color)
%
% Argument:
%    im1color - the first image
%    im2color - the second image
%
% Reference:
% [1] Lowe, David G. (1999). "Object recognition from local scale-invariant
% features". Proceedings of the International Conference on Computer Vision. 
% 2. pp. 1150-1157

function run_sift_test(im1color, im2color, inthresh)

%% Inititalize and loading images

if nargin < 1 
    [fnames, fpaths] = img_acquire.jpggetfiles( );
    imbuffer = img_acquire.iobuf( fpaths, fnames );
    imbuffer.format('color', .3 );

    im1color = imbuffer.fnames2im(fnames{1});
    im2color = imbuffer.fnames2im(fnames{2});
end

if nargin < 3
    threshold = 0.025;
else
    threshold = inthresh;
end

if size(im1color,3) > 1
    im1 = rgb2gray(im1color);
end
if size(im2color,3) > 1
    im2 = rgb2gray(im2color);
end


%% Calculation, from the sift toolbox
addpath('./_sift/');

[frames1,descriptors1,gss1,dogss1] = ...
    sift(im1, ...
        'verbosity', 1, ...
        'threshold', threshold );
[frames2,descriptors2,gss2,dogss2] = ...
    sift(im2, ...
        'verbosity', 1, ...
        'threshold', threshold );

%% Display
figure, 
subplot(2,1,1), 
imshow(im1color);
hold on;
scatter(frames1(1,:), frames1(2,:), 'r.');
title(sprintf('SIFT detector of im1 with threshold %d', threshold));
hold off;

subplot(2,1,2),
imshow(im2color);
hold on;
scatter(frames2(1,:), frames2(2,:), 'r.');
title(sprintf('SIFT detectorof im2 with threshold %d', threshold));
hold off;

%% Display multi-level
%figure; plotss(dogss1); title('Multi-level of im1'); 
%figure; plotss(dogss2); title('Multi-level of im2'); 
drawnow ;

%% Test the matching 

figure,
subplot(1,2,1), imshow(im1color);
subplot(1,2,2), imshow(im2color);

matches = siftmatch( descriptors1, descriptors2 ) ;

type_drawing = 'parallel';

figure,
switch type_drawing
    case 'stacking'
        plotmatches(im1, im2, frames1(1:2,:), frames2(1:2,:), matches, 'interactive', 2,  'stacking', 'o' );
    case 'parallel'
        plotmatches(im1,im2,frames1(1:2,:),frames2(1:2,:),matches, 'Interactive', 2) ;
end



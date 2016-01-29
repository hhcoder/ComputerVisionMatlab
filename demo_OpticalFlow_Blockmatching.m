%% (1) Read in and show the panaromatic sequence
% Althogh this panaromic image is pre-captured, we wanna show the block
% matching working correctly
img_pan_org = imread('..\DataImage\20100819_QCOMAV\pacific_center.jpg');
img_pan = imresize(img_pan_org, 0.5);
dimx = size(img_pan, 2);
dimy = size(img_pan, 1);

figure, title('Pan Image');
for i=1:5:(dimx-dimy)/2
    imshow(img_pan(1:end, 1+i:dimy+i,:));
    drawnow;
end
%% (2) Show the block estimation on letter 'P'
img1 = (img_pan(1:end, 1:dimy,:));
posyx = [369 439];
bsize = 60;
search_range = -10:10;
posyx_now = posyx;
for i=1:5:200
    img2 = (img_pan(1:end, 1+i:dimy+i,:));
    [dy,dx] = img_analyzer.im2motionest( img1, img2, posyx, bsize, search_range, 'mse' );
    img1 = img2;
    imshow(img1);
    posyx_now(2) = posyx_now(2)+dx;
    posyx_now(1) = posyx_now(1)+dy;
    rectangle(...
        'Position', [ posyx_now(2) posyx_now(1) bsize bsize], ...
        'LineWidth',2, 'EdgeColor', 'r');
    drawnow;
end

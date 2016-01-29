% Block-based motion estimation
% - Searching the smallest mse value linearly
function demoOpticalFlow_motionEstimationLinear( fpath, fnames )

%% Stage 1: Load the image data
if nargin < 1
    fpath = './';
    fnames = {'imbird01.jpg', 'imbird02.jpg'};
end

imbuffer = img_acquire.iobuf( fpath, fnames );
imbuffer.format('color', 1.0 );

im1 = imbuffer.fnames2im(fnames{1});
dims = size(im1);
im2 = imbuffer.fnames2im(fnames{2});

%% Stage 2: Fixed size block motion estimation

% The parameters for block matching algorithm
bsize = 64;
search_range = -32:32;

% Parameter for boundary
border = ceil(bsize./2) + ceil(length(search_range)./2) + 1;
starty = border;
startx = border;

% Moving forward step size
scan_step = 32;
county = floor( (dims(1)-border.*2)./scan_step);
countx = floor( (dims(2)-border.*2)./scan_step );

% Output parameters (in this format, it's easier to draw velocity diagram)
motionvecx = zeros( county, countx );
motionvecy = zeros( county, countx );
posys = zeros(county, countx);
posxs = zeros(county, countx);

hwait = waitbar(0, 'Running motion estimation');

% Tuning parameters
compare_rule = 'xor+sum';

% make a mask by DSTEI method
motionmsk = img_analyzer.im2dstei( im1(:,:,2)-im2(:,:,2), -2:2 );
motionmsk = img_processor.im2binary(motionmsk, 'value+threshold',0.3);
se = strel('rectangle',[8 8]);
motionmsk = imerode( imdilate( motionmsk, se ), se );    

im1e = run_ip_preproc(im1(:,:,2), 'sobel+bw') .* motionmsk;
im2e = run_ip_preproc(im2(:,:,2), 'sobel+bw') .* motionmsk;

for xidx=01:countx
    for yidx=1:county
        posys(yidx, xidx) = starty+(scan_step.*(yidx-1));
        posxs(yidx, xidx) = startx+(scan_step.*(xidx-1));
        [motionvecx(yidx,xidx), motionvecy(yidx,xidx)] = ...
            img_analyzer.im2motionest( im1e, im2e, [posys(yidx, xidx) posxs(yidx,xidx)], bsize, search_range, compare_rule );
    end
    waitbar(xidx./countx);
end
close(hwait);

%% Stage 3: Show the motion vectors
figure;
im2avg = @(I1,I2)( (I1+I2)./2 );
imshow( im2avg(im1,im2) );
hold on
interv = 1;
quiver( posxs(1:interv:end,1:interv:end), posys(1:interv:end,1:interv:end), motionvecx(1:interv:end,1:interv:end), motionvecy(1:interv:end,1:interv:end), 0, 'Color', [1 1 0] );
hold off

end
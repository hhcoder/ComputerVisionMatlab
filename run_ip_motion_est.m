% RUN_IP_MOTION_EST - do the block-based motion estimation linearly
% 
% This high-level function calculate the block-based motion estimation with
% linear searching, which could be slow comparing with Lucas-Kanade
% algorithm. It can be viewed as the most basic and simple algorithm in
% motion estimation.
%
% Usage: run_ip_motion_est( im1, im2 )
% 
% Arguments: 
%    im1 - the first input image
%    im2 - the second input image


function run_ip_motion_est( im1, im2 )

%% (1): Do the corner detection
im1g = im1(:,:,2);
im2g = im2(:,:,2);
im1br = img_processor.imfilter_bilateral_range( im1g );
c = cornermetric( im1br, 'Harris', 'SensitivityFactor', 0.15);
corner_peaks = imregionalmax(c);
corner_idx = find(corner_peaks == true);    % search the corner points as anchor of blocks
dims = size(im1);

%% (2): Do the motion estimation based on the positions of corner detection

% Setup the border size at first
bsize = 32; %block size
search_range = -16:16;
border = ceil(bsize./2) + ceil(length(search_range)./2) + 1;

% Build the output parameter via the corner detection results
N = length(corner_idx);
[posys, posxs] = ind2sub( size(im1br), corner_idx );
motionvecx = zeros(N,1);
motionvecy = zeros(N,1);

% Setup the searching parameters
im1b = img_processor.im2binary(im1g, 'percent+threshold+exclusion', 0.5, 0.04);
im2b = img_processor.im2binary(im2g, 'percent+threshold+exclusion', 0.5, 0.04);
compare_rule = 'xor+sum';
hdisp = waitbar(0, 'Running feature point based motion estimation...');
for i=1:N
    if posys(i)<=border || (posys(i)>=(dims(1)-border)) ... 
            || (posxs(i)<=border) || (posxs(i)>=(dims(2)-border))
        continue;
    end
    [motionvecy(i), motionvecx(i)] =...
        img_analyzer.im2motionest(im1b, im2b, [posys(i) posxs(i)], bsize, search_range, compare_rule );
    waitbar(i./N);
end
close(hdisp);

% Show the searching result
figure,
imshow((im1+im2)./2);
hold on;
quiver(posxs, posys, motionvecx, motionvecy, 0, 'Color', [1 1 0]  );
hold off

end
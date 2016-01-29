function test_m3d_ui_sim

%% Initialize video
vid = videoinput('winvideo',1);
start(vid);
%preview(vid);

% Setup vars
rshift = 25;

%% Showing with Blending
im1 = im2double(getsnapshot(vid));

able_to_stitch = 0;

while able_to_stitch==0
    im2 = getsnapshot(vid);
    
    im3 = im2double(im2);
    im3(:,1:end-rshift,:) = ( im3(:,1:end-rshift,:) + im1(:,rshift+1:end,:) )/2;
    imshow(im3);
    
    drawnow
end

%% Showing with "Edges"
im1 = getsnapshot(vid);

[h,w,ch] = size(im1);
posy = ceil(h/2);
posx = ceil(w/2);
bsize =32;
search_range = -32:32;
compare_rule = 'lucas_kanade';

% Enter loop
able_to_stitch = 0;

diff = rshift;

figure,
while able_to_stitch==0
    im2 = getsnapshot(vid);

%     [dy,dx] = img_analyzer.im2motionest(im2double(im1), im2double(im2), [posy posx], bsize, search_range, compare_rule );
%     dy = round(dy);
%     dx = round(dx);
% 
%     diff = diff-dx;
%     if diff==0
%        able_to_stitch=0;
%     end

    im3 = imfilter(im1, fspecial('sobel'));
    im3(:,:,1) = im3(:,:,2);
    im3(:,:,3) = im3(:,:,2);
    
    im3 = im3>20;

    im4 = im2double(im2);
    im4(:,1:end-rshift,:) = im4(:,1:end-rshift,:) + im3(:,rshift+1:end,:);

    imshow(im4);
    drawnow
    
end

close all

figure,
subplot(1,2,1), imshow(im1);
subplot(1,2,2), imshow(im4);

end
function test_autorama

%% Initialize video
vid = videoinput('winvideo',1);
start(vid);
preview(vid);

%% Set parameter

im1 = getsnapshot(vid);
[h,w,ch] = size(im1);
posy = ceil(h/2);
posx = ceil(w/2);
bsize =16;
search_range = -32:32;
compare_rule = 'lucas_kanade';

extra_w = w;
extra_h = h;

img_pan = uint8(zeros(h+extra_h*2,w+extra_w*2,ch));

%% Show the rectangle on screen

rect_ratio = 10;

rect_w = ceil(w/rect_ratio);
rect_h = ceil(h/rect_ratio);
canvas_w = size(img_pan,1);
canvas_h = size(img_pan,2);

canvas_cent_y = ceil(canvas_h/2-rect_h/2);
canvas_cent_x = ceil(canvas_w/2-rect_w/2);


%% Reset to the first image


dsty = ceil(extra_h);
dstx = ceil(extra_w);
im1 = getsnapshot(vid);
img_pan(dsty:dsty+h-1, dstx:dstx+w-1,:) = im1(:,:,:);

% Enter loop
able_to_stitch = 1;

% draw the rectangle in the center
rect_y = canvas_cent_y;
rect_x = canvas_cent_x;

% draw the image at bottom-left
dsty = ceil(extra_h);
dstx = ceil(extra_w);

while 1
    im2 = getsnapshot(vid);

    [dy,dx] = img_analyzer.im2motionest(im2double(im1), im2double(im2), [posy posx], bsize, search_range, compare_rule );
    dy = round(dy);
    dx = round(dx);

    % Draw the center image & center rectangle
    imshow(img_pan);
    rectangle( ...
        'Position', [canvas_cent_y canvas_cent_x rect_w rect_h], ...
        'LineWidth', 1, 'LineStyle', '-', 'EdgeColor', 'b');
    % Draw the movable rectangle
    rect_y = rect_y-round(dy/rect_ratio);
    rect_x = rect_x-round(dx/rect_ratio);
    rectangle(...
        'Position', [rect_y rect_x rect_w rect_h], ...
        'LineWidth', 1, 'LineStyle', '-', 'EdgeColor', 'w');
    drawnow;

    dsty = dsty-dy;
    dstx = dstx-dx;
    if dsty>size(img_pan,1)-h+1 || dstx>size(img_pan,2)-w+1 || dsty<1 || dstx < 1
        break;
    end
    
    if able_to_stitch
        img_pan(dsty:dsty+h-1,dstx:dstx+w-1,:) = im2(:,:,:);
        imshow(img_pan);
    end

    im1 = im2;
end
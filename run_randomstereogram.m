% set up the pixel shift as 1/100 of the image width
pixel_shift = 10;

% setup the image width/height
w_size = 220;
c_size = 10;

% burger?
option = 'pyramid';

switch option
    % french fries?
    case 'in-n-out'
        b1 = 50;
        b2 = 25;
        shift_map = zeros(w_size,w_size);
        shift_map(b1+1:w_size-b1,b1+1:w_size-b1) = 3;
        shift_map(b1+b2+1:w_size-b1-b2,b1+b2+1:w_size-b1-b2) = -3;
    % checker board?
    case 'checker'
        shift_map = (checkerboard(55, 2)>0.5) .* pixel_shift;
    % pyramid!
    case 'pyramid'
        b1 = 30;
        b2 = 50;
        b3 = 70;
        b4 = 90;
        shift_map = zeros(w_size,w_size);
        shift_map(b1+1:w_size-b1,b1+1:w_size-b1) = -2;
        shift_map(b2+1:w_size-b2,b2+1:w_size-b2) = -5;
        shift_map(b3+1:w_size-b3,b3+1:w_size-b3) = -8;
        shift_map(b4+1:w_size-b4,b4+1:w_size-b4) = -11;
end
    
% set up the random dot distribution
mean = 0;
var = 0.2;

% Generate the left image (random dots)
im_left = random('norm', mean, var, [w_size w_size]) > 0;

% Generate the blank image
im_right = zeros([w_size w_size]);

% Map the right image from left image based on the shifting map
for x=1:w_size
    for y=1:w_size
        im_right(y,x) = im_left(y,min(w_size, x+shift_map(y,x)));
    end
end

disp_right = im_right(c_size+1:end-c_size, c_size+1:end-c_size);
disp_left = im_left(c_size+1:end-c_size, c_size+1:end-c_size);

% Show the image pair
figure,
subplot(1,2,1), imshow(disp_right), title('.', 'FontSize', 30);
subplot(1,2,2), imshow(disp_left), title('.', 'FontSize', 30);

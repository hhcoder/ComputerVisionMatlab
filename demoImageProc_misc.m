% This function demostrates some miscellenous 

%% Detecting the edge position of each black rectangle
I = checkerboard(20);
Ibw = im2bw(I);
[Ilabel, numlabel] = bwlabel(Ibw,4);
figure, imshow(Ibw);
for i=1:numlabel
    % the upper left index
    ul_idx = find((Ilabel==i),1,'first');
    % Find the exact [x,y] position of each block
    [y,x] = ind2sub( size(Ibw), ul_idx );
    % Text it! [x, y+6] avoid text in black region
    text(x+6,y+20,sprintf('%d',i));
end

%% Use the checker board image to debug
I = checkerboard(100, 6);
Ibw = im2bw(I);
Ibw = Ibw(1:900, 1:1200);
[Ilabel, numlabel] = bwlabel(Ibw,4);
%%figure, imshow(Ibw);
ImgGrad = Ibw.* (((1:900)./900)' * ones(1,1200));
h = figure;
imshow(cat(3,double(ImgGrad),double(ImgGrad),double(ImgGrad)));
for i=1:numlabel
    % the upper left index
    ul_idx = find((Ilabel==i),1,'first');
    % Find the exact [x,y] position of each block
    [y,x] = ind2sub( size(Ibw), ul_idx );
    % Text it! [x, y+6] avoid text in black region
    text(x+20,y+40,sprintf('%d',i), 'Color', [1 0 0], 'FontWeight', 'bold', 'FontSize', 20);
end

%% Do some test on two image as a stereo image
im1 = im2double( imresize(imread('immeganfox.jpg'), 0.3) );
dims = size(im1);
[idxx, idxy] = meshgrid(1:dims(2), 1:dims(1));
intensity = imfilter(im1(:,:,2), fspecial('gaussian'));
figure,
warp( idxx, idxy, intensity, im1 );
xlabel('X'), ylabel('Y'), zlabel('Z');
campos([dims(2)./2, dims(1)./2, 1000]);
camup([0 -1 0]);
camtarget([dims(2)./2, dims(1)./2, 0]);

title('Use rotate tool to see the 3D');

% 30: distance to screen 2.5: distance between eyes
theta = atan(30./2.5);
zdistance = dims(2)./2 .* tan(theta);

%% Try to use profile toolbox
cL = im2double(imread('imcolorchecker.tif'));
cfsrgb2lab = makecform('srgb2lab');
cflab2srgb = makecform('lab2srgb');
profile on
profile viewer
p = profile('info');
profsave(p,'./RESULTS/profile_results')

%% Get input from the computer video, *** only works on Windows ***
vid = videoinput('winvideo',1);
start(vid);
preview(vid);
test_img = getsnapshot(vid);
stop(vid);  
delete(vid);

%% Try the "fisheye" effect

func = @(x)(x.*(((1:x)/x).^2));

Icolor = imread('imsnow.jpg');
Ibw = im2double(Icolor(:,:,2));
h = size(Ibw,1);
w = size(Ibw,2);

X = func(w);
Y = func(h);
Iresult = Ibw(ceil(Y), ceil(X));

imshow(Iresult);


%% Stage 1: Read-in a corner image

selector = 'girl';
switch selector
    case 'checkerboard'
        src = checkerboard(30);
    case {'national geo girl', 'ngm girl', 'girl' }
        srcrgb = im2double(imread('imagfagirl.jpg'));
        src = rgb2gray(srcrgb);
        %src = srcrgb(:,:,2);
    case {'meganfox', 'hot', 'chick'}
        srcrgb = im2double(imread('immeganfox.jpg'));
        src = rgb2gray(srcrgb);
end

%% Stage 2.1: Gradient methods
%g1src = edge(src,'log');l
c = 0.4;
g1src = imfilter(src,fspecial('laplacian')) - c .* gradient(src);

block = -1:1;
dims = size(src);
dst = zeros(size(src));
interv = 1; %length(block);
thresh = 0.2;
corner_weight = numel(block)./2;
for i=(1-block(1)):interv:(dims(1)-block(end))
    for j=(1-block(1)):interv:(dims(2)-block(end))
        B = g1src(i+block,j+block) > thresh;
        dst(i,j) = sum(sum(abs(B))) > corner_weight;
    end
end

b = imerode(dst, strel('disk',1));
b = imdilate(b, strel('disk',2));
b = imfilter(b,fspecial('log')) > 0.05;

figure;
imshow( cat(3,b,zeros(dims),b) + srcrgb );

%% Stage 2.2: Display
b = img_processor.im2binary(g1src, 'percent+threshold', 0.95 );
b = imerode(b, strel('rectangle', [2 2]));
[L,num] = bwlabel(b,8);

figure;
imshow( img_processor.im2binary(dst, 'percent+threshold', 0.99) );
title('Eroded image');

%% Stage 3: Harris corner detection
g1src = img_processor.imfilter_bilateral_range( src );

% See Matlab help on cornermetric
c = cornermetric( g1src, 'Harris');

% Do the watershed algorithm
corner_peaks = imregionalmax(c);
corner_idx = find(corner_peaks == true);
figure;
[r g b] = deal(src);
r(corner_idx) = 0;
g(corner_idx) = 1;
b(corner_idx) = 1;
imshow(cat(3,r,g,b));

block = -2:2;
dims = size(src);

dst = zeros(size(src));

for i=(1-block(1)):(dims(1)-block(end))
    for j=(1-block(1)):(dims(2)-block(end))
        B = src(i,j) - src(i+block,j+block);
        dst(i,j) = sum(sum(abs(B)));
    end
end

hdisp = figure;
subplot(1,2,1), imshow(src);
subplot(1,2,2), imshow(dst);

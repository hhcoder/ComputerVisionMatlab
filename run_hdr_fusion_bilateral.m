% RUN_HDR_FUSION_BILATERAL - demonstrate the bilateral filtering funcion
% 
% This is a high-level demo function shows how the bilateral filtering works.
% Notice that this function is just a demostration. Further research on
% range filtering is required.
%

%% Stage 1: Simulate the range filter in 1D case

% generate a 1-D step function with random noise
signal_in =0.3 * rand(1,200) + [zeros(1,100), ones(1,100)];

win1d = -5:5;

gaussian = @(v)( exp(-(v).^2 ./ (2.*0.3.^2) ) );
inv_gaussian = @(v)( 1 - gaussian(v));

signal_out = zeros(size(signal_in));

% do the bilateral filtering
for i=1-win1d(1):length(signal_in)-win1d(end)
    
    p1center = signal_in(i);
    p1neighbor = signal_in(i+win1d);
 
    weight = gaussian(p1center-p1neighbor);

    signal_out(i) = sum(sum(weight.*p1neighbor)) ./ sum(sum(weight));
end
 
% show result
h = figure;
plot( signal_in, '-', 'Color', [ 0 0 0] );
hold on
plot( signal_out, '--', 'Color', [ 1 0 0]);
axis( [ 0 200 -0.3 1.3] );
legend( 'Signal in', 'Signal out', 'Location', 'NorthWest' );
saveas(h, '01_1dRangeFilter', 'jpg');
hold off

%% Stage 2: Simulate the range filter in 2D case

% generate a 2-D step function with random noise
signal2in = 0.3 .* (0.5-rand(200,200)) + [zeros(200,100), ones(200,100)];

win2d = -5:5;

gaussian = @(v)( exp(-(v).^2 ./ (2.*0.3.^2)) );

signal2out = zeros(size(signal2in));

% do the 2-d bilateral filtering
for i=1-win2d(1):size(signal2in,1)-win2d(end)
    for j=1-win2d(1):size(signal2in,2)-win2d(end)
        p2center = signal2in(i,j);
        p2neighbor = signal2in(i+win2d,j+win2d);
        
        weight = gaussian(p2center-p2neighbor);
        signal2out(i,j) = sum(sum(weight.*p2neighbor)) ./ sum(sum(weight));
    end
end

% show result
h2 = figure;
hold on;
subplot(1,2,1), surf(signal2in(1:2:end,1:2:end));
subplot(1,2,2), surf(signal2out(1:2:end,1:2:end));
hold off;

%% Stage 3: Simulate the 'modified' range filter in 2D case
imcolor = im2double(imread('../DataImage/20090708_SequenceFlowers/s01.JPG'));
signal2in = imcolor(:,:,2);
imcolormove = im2double(imread('../DataImage/20090708_SequenceFlowers//s04.JPG'));
imcolormove = imfilter(imcolormove, fspecial('gaussian'));
signal2in_bk = imcolormove(:,:,2);

win2d = -3:3;

gaussian = @(v)( exp(-(v).^2 ./ (2.*0.3.^2)) );

signal2out = zeros(size(signal2in));

%signal2in_blur = imfilter(signal2in,fspecial('gaussian', 5, 5.5));

hwait = waitbar(0,'Applying range filter...');

for i=1-win2d(1):size(signal2in,1)-win2d(end)
    for j=1-win2d(1):size(signal2in,2)-win2d(end)
        p2center = signal2in(i,j);
        %p2neighbor = signal2in_blur(i,j);
        p2neighbor = signal2in_bk(i+win2d,j+win2d);
        
        weight = gaussian(p2center-p2neighbor);
        
        %signal2out(i,j) = sum(sum(weight.*p2neighbor))./(length(win2d).*length(win2d));
        signal2out(i,j) = sum(sum(weight.*p2neighbor))./sum(sum(weight));
    end
    
    waitbar(i./length(1-win2d(1):size(signal2in,1)-win2d(end)));
end

close(hwait);

h2 = figure;
hold on;
subplot(1,2,1), imshow((signal2in+signal2in_bk)./2);
subplot(1,2,2), imshow(signal2out);
hold off;

% imwrite(signal2in, 'source.jpg');
% imwrite(signal2out, 'dest.jpg');
% imwrite(abs(signal2in-signal2out), 'diff.jpg');

%% Stage 4: A testing on multiple images
[fnames,fpath] = img_acquire.jpggetfiles( );
imbuffer = img_acquire.iobuf(fpath,fnames);
imbuffer.format('gray', 1.0 );

imbrs = cell(length(fnames),1);

blrimg = @(I)( imfilter(I,fspecial('gaussian', [5 5], 0.4)) );
bfilter_range = @(I)( img_processor.imfilter_bilateral_range(I));

im1 = imbuffer.fnames2im(fnames{1});
imav = zeros(size(im1));
imbf = zeros(size(im1));
imbr = zeros(size(im1));
N = length(fnames);
for i=1:N
    im = imbuffer.fnames2im(fnames{i});
    imbf = imbf + bfilter_range(im);
    imbr = imbr + blrimg(im);
    imav = imav + im;
end

imbfd = im1-bfilter_range(im1);
imbfresult = imbfd + imbf./N;
imbrd = im1-blrimg(im1);
imbrresult = imbrd + imbr./N;
figure, 
subplot(2,2,1), imshow( imbfresult ), title('Bilateral Filter Averaging');
subplot(2,2,2), imshow( imbfd ), title('Bilateral Filter Difference');
subplot(2,2,3), imshow( imav./N), title('Simple Avaraging');
subplot(2,2,4), imshow( imbrresult ), title('Gaussian Filter Averaging');

figure,
subplot(1,2,1), imshow( imbfresult ), title('Bilateral Filter Averaging');
subplot(1,2,2), imshow( imbrresult ), title('Gaussian Filter Averaging');

% imwrite(imbrresult);

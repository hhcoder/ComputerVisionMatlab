% This function is deprecated.... Use run_ip_lucaskanade2 instead.
% Please not to use it, or, fix it!
function run_ip_lucaskanade( fnames, fpath )

%% (1) Initialization and image loading

if nargin < 2
    % Load image files
    [fnames,fpath] = img_acquire.jpggetfiles( );
end

% Thanks for D.Kroon 
addpath('./_LucasKanade2/');

imbuffer = img_acquire.iobuf(fpath,fnames);
imbuffer.format('color', 1.0 );

% Use two image in experiment #1
im1 = imbuffer.fnames2im(fnames{1});
im2 = imbuffer.fnames2im(fnames{2});

figure, imshow((im1+im2)./2);

%% (2) Feature points selection - based on corner metric

im2gbr = @(I)( imfilter(im2double(rgb2gray(I)), fspecial('gaussian', [16 16], 0.8)) );
imselmaxval = @(I)( I==max(max(I)) );

im1br = im2gbr(im1);
im2br = im2gbr(im2);

c = cornermetric( im1br, 'Harris', 'SensitivityFactor', 0.14);
c2 = c .* (imregionalmax(c)== true);
block_sel = 'block-based';
switch block_sel
    case 'descending'
        csel = blkproc(c2,[16 16],imselmaxval);
    otherwise
        csel = c2;
end

%skip border region as feature points
border = 20;
bmask = zeros(size(c));
bmask(1+border:1-border+end,1+border:1-border+end) = 1;
csel = csel .* bmask;

sel_points = 32;
[cY, cI] = sort( reshape(c.*csel,numel(c),1), 1, 'descend' );
[posys, posxs] = ind2sub(size(im1br), cI(1:sel_points) );

% Show the corner detection result
figure,
imshow(im1);
hold on
for ind = 1:length(posys)
    plot(posxs(ind),posys(ind),'go','MarkerFaceColor', 'red');
end
%quiver(posxs(1:interv:end), posys(1:interv:end), zeros(size(posxs)), zeros(size(posys)), 0, 'Color', [1 0 1]  );
hold off

%% (3) Do the Lucas-Kanade optical flow calculation
%(3.1) Preprocessing
% setup two input images
im1g = rgb2gray(im1);
im2g = rgb2gray(im2);

% (3.2) Actual processing of Lucas-Kanade Algorithm
Options.TranslationIterations=30;
Options.AffineIterations=0;
Options.RoughSigma=1.6;
Options.FineSigma=1.3;
Options.TolP = 1e-8;

tplt = struct;

len = length(posys);

b=-16:16;

if border <= abs(b(1)) || border <= abs(b(end))
    error('variable border must be set larger than size of block');
end
[wys,wxs] = meshgrid(b,b);
gausswin = @(I,sigma_len)(exp(-I./2.*(sigma_len.^2)) );
weight = gausswin( sqrt(wys.^2+wxs.^2), 0.01);

hdisp = waitbar(0, 'Processing Lucas-Kanade Optical Flow Tracing');

for ind=1:len
    posx = posxs(ind);
    posy = posys(ind);

    tplt(ind).p=[0 0 0 0 posy posx];
    tplt(ind).image= im1g( posy+b, posx+b);
    tplt(ind).weight = weight;

    [tplt(ind).p, roi_img, errorval] = ...
        LucasKanadeInverseAffine( im2g, tplt(ind).p, tplt(ind).image, tplt(ind).weight, Options );

    waitbar(ind./len);
end
close(hdisp);

% Display the result
figure,
subplot(1,2,1), imshow(im1);
hold on
for ind=1:len
    cmap=hot(256);
    xpos = posxs(ind);
    ypos = posys(ind);
    text(xpos+5, ypos+5, sprintf('%d',ind));
    plot(xpos,ypos,'go','MarkerFaceColor', 'red' );
end
hold off

subplot(1,2,2), imshow(im2);
hold on
for ind=1:len
    cmap=hot(256);
    xpos = tplt(ind).p(6);
    ypos = tplt(ind).p(5);
    text(xpos+5,ypos+5,sprintf('%d',ind));
    plot(xpos, ypos,'go','MarkerFaceColor', 'red' );
end
hold off

%% (4) Show demo sequential movie

for imcnt = 1:length(fnames)
    imshow( imbuffer.fnames2im(fnames{imcnt}) );
    drawnow;
end


%% (5) Do sequential search

imprev = im1g;
tpltmulti = struct;
figure,
imshow(im1);

len = length(posys);

for ind=1:len
    posx = posxs(ind);
    posy = posys(ind);

    tpltmulti(ind).p=[0 0 0 0 posy posx];
    tpltmulti(ind).image= imprev( posy+b, posx+b);
    tpltmulti(ind).weight = weight;
end

for imcnt = 2:length(fnames)
    imnextclr = imbuffer.fnames2im(fnames{imcnt});
    imnext = rgb2gray(imnextclr);

    for ind=1:len
        [tpltmulti(ind).p, roi_img, errorval] = ...
            LucasKanadeInverseAffine( imnext, tpltmulti(ind).p, tpltmulti(ind).image, tpltmulti(ind).weight, Options );
    end
        
    imshow(imnextclr);
    
    hold on;
    
    for ind=1:len
        hmap = cmap( round(ind*255/len)+1,: );
        xpos = tpltmulti(ind).p(6);
        ypos = tpltmulti(ind).p(5);
        text(xpos+5,ypos+5,sprintf('%d',ind));
        plot(xpos, ypos,'go','MarkerFaceColor', hmap );
    end
    
    drawnow;
    hold off;
    imprev = imnext;
 
end

% RUN_IP_LUCASKANADE2 - Running the Lucas-Kanade optical flow algorithm
%
% This high-level function demostrates the Lucas-Kanade algorithm in
% feature tracking for video/serial images input. The Lucas-Kanade
% algorithm is a famous optical flow algorithm which uses Newton-Gaussain
% nonlinear optimization in tracking feature point in block. This function 
% runs with serial images. For further reading, see refs.
%
% Usage: run_ip_lucaskanade2( fnames, fpath, user_select_points )
%
% Arguments:
%    fnames - input file names
%    fpath - input file path, if not specified, a UI window pops out for
%            multiple file selection
%    user_select_points - enable/disable user selecting feature points.
%                         If disabled, the feature points will be selected
%                         by Harris corner detection algorithm.
% 
% References
% [1] Lucas B D and Kanade T 1981, An iterative image registration
% technique with an application to stereo vision. Proceedings of Imaging 
% understanding workshop, pp 121?130
% [2] Simon Baker and Iain Matthews, Lucas-Kanade 20 Years On: A Unifying
% Framework, International Journal of Computer Vision, pp. 221-255, Volume 
% 56, Number 3 / February, 2004

function run_ip_lucaskanade2( fnames, fpath, user_select_points )
%% Read images in
if nargin < 1
    [fnames, fpath] = uigetfile( ...
        {'*.*', 'All Files(*.*)'}, 'Pick a file', 'MultiSelect', 'on');
end

if nargin < 3
    user_select_points = 1;
end

imbuffer = img_acquire.iobuf(fpath,fnames);
imbuffer.format('color', 1.0 );


%% Show the original sequence
for i=1:length(fnames)
    imshow(imbuffer.fnames2im(fnames{i}));
    title('The original sequence');
    drawnow;
end

%% Feature points selection, by user or by Harris corner detection
    im1 = imbuffer.fnames2im(fnames{1});

    hbean = figure;
    imshow(im1);
    if user_select_points
        % Open a user interactive window and let user picks the feature points
        title('Please select points to track, press Enter to Finish');

        [posxs,posys] = getpts(hbean);

    else
        % Run the Harris corner detection algorithm
        im2gbr = @(I)( imfilter(im2double(rgb2gray(I)), fspecial('gaussian', [16 16], 0.8)) );
        imselmaxval = @(I)( I==max(max(I)) );

        im1br = im2gbr(im1);

        c = cornermetric( im1br, 'Harris', 'SensitivityFactor', 0.18);
        c2 = c .* (imregionalmax(c)== true);
        block_sel = 'block-based';
        switch block_sel
            case 'descending'
                csel = blockproc(c2,[16 16],imselmaxval);
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
        title('The Harris corner detection as feature points');
    end

    % Show the user selected points
    hold on
    cmap=hot(256);
    for ind=1:length(posys)
        hmap = cmap( round(ind*255/length(posys))+1,: );
        xpos = posxs(ind);
        ypos = posys(ind);
        text(xpos+5,ypos+5,sprintf('%d',ind));
        plot(xpos, ypos,'go','MarkerFaceColor', hmap );
    end
    hold off

%% Set up some initial value and first image case

    imprev = rgb2gray(im1);

    % Thanks for D.Kroon 
    addpath('./_LucasKanade2/');

    Options.TranslationIterations=30;
    Options.AffineIterations=0;
    Options.RoughSigma=1.6;
    Options.FineSigma=1.3;
    Options.TolP = 1e-8;

    tpltmulti = struct;

    b=-15:16;

    border = abs(b(1));

    for i=1:length(posys)
        if posxs(i) <= abs(b(1))
            posxs(i) = abs(b(1));
        end
        if posxs(i) >= (size(imprev,2)-border)
            posxs(i) = (size(imprev,2)-border);
        end
        if posys(i) <= abs(b(1))
            posys(i) = abs(b(1));
        end
        if posys(i) >= (size(imprev,1)-border)
            posys(i) = (size(imprev,1)-border);
        end
    end

    [wys,wxs] = meshgrid(b,b);
    gausswin = @(I,sigma_len)(exp(-I./2.*(sigma_len.^2)) );
    weight = gausswin( sqrt(wys.^2+wxs.^2), 0.01);

%% Start run the algorithm

    imprev = rgb2gray(im1);
    imprev = imadjust(imprev);

    % Setup the first frame case
    for ind=1:length(posys)
        tpltmulti(ind).p= [0 0 0 0 posys(ind) posxs(ind)];
        tpltmulti(ind).weight = weight;
        tpltmulti(ind).image= imprev( int16(round(tpltmulti(ind).p(5)+b)), int16(round(tpltmulti(ind).p(6)+b)));
    end

    for imcnt = 2:length(fnames)
        % Read next image in
        imnextclr = imbuffer.fnames2im(fnames{imcnt});
        imnext = imadjust(rgb2gray(imnextclr));

        % Track between previous image and next image
        for ind=1:length(posys)
            [new_point, roi_img, errorval] = ...
                LucasKanadeInverseAffine( imnext, tpltmulti(ind).p, tpltmulti(ind).image, tpltmulti(ind).weight, Options );
            tpltmulti(ind).p = new_point;
            tpltmulti(ind).image= imnext( int16(round(tpltmulti(ind).p(5)+b)), int16(round(tpltmulti(ind).p(6)+b)));
        end

        % Show the current tracking image
        %subplot(2,1,1), 
        imshow(imnextclr);
        hold on;
        cmap=hot(256);
        for ind=1:length(posys)
            hmap = cmap( round(ind*255/length(posys))+1,: );
            xpos = tpltmulti(ind).p(6);
            ypos = tpltmulti(ind).p(5);
            text(xpos+5,ypos+5,sprintf('%d',ind));
            plot(xpos, ypos,'go','MarkerFaceColor', hmap );
        end
        drawnow;
        hold off;

        % Update previous image with next image
        imprev = imnext;
        %subplot(2,1,2), imshow(tpltmulti(1).image);

    end

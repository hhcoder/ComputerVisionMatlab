% RUN_RANSAC_TEST - Sticthing images together
%
% This is a high-level function trying to stitching multiple images onto
% one big template image. It uses the SIFT and RANSAC to find the
% homogeneous matrix between the first image and other images and attatches
% them all together. The known problem is that when images has much
% difference, especially when the camera moved to different angle, the
% stitching works just bad... For future work, some local non-linear
% optimization should be used on segmented image.
%
% Usage: 
%  run_ransac_test( what_to_show )
%
% Arguments: 
%  what_to_show: 'Stop1GeoDemo', 'RoomZoomIn', 'RoomRotate', 'RoomMove',
%                'Stop2GeoDemo', 'SimpleChipmonk', or 'MultipleImages'. The
%                last option enables user to open a UI window to select
%                multiple images.
%
% Returns:
%
% Notice this function doesn't complete and the result might not be
% satisfied under many situation.
%

function [im1, im2new] = run_ransac_test( what_to_show )

    %% Calculate matching between images
    if ~strcmp(what_to_show, 'MultipleImages')
        switch what_to_show
            case 'Stop1GeoDemo'
                im1color = imread('DataHDR/PanImages2/sP9198717.JPG');
                im2color = imread('DataHDR/PanImages2/sP9198958.JPG');
            case 'RoomZoomIn'
                im1color = imread('DataHDR/MatrixH/roomZoom1.JPG');
                im2color = imread('DataHDR/MatrixH/roomZoom2.JPG');
            case 'RoomRotate'
                im1color = imread('DataHDR/MatrixH/roomRotate2.JPG');
                im2color = imread('DataHDR/MatrixH/roomRotate1.JPG');
            case 'RoomMove'
                im1color = imread('DataHDR/MatrixH/roomMove1.JPG');
                im2color = imread('DataHDR/MatrixH/roomMove2.JPG');
            case 'Stop2GeoDemo'
                im1color = imread('DataHDR/PanImages/sP9198805.JPG');
                im2color = imread('DataHDR/PanImages/sP9199275.JPG');
            case 'SimpleChipmonk'
                im1color = imread('imchipmonk.jpg');
                im2color = imread('imchipmonks.jpg');
            case 'CSIOffice'
                im1color = imresize( imread('../DataImage/20091021_CSIOffice/IMG_2695.jpg'), 0.3);
                im2color = imresize( imread('../DataImage/20091021_CSIOffice/IMG_2694.jpg'), 0.3);
            case 'RITPan'
                im1color = imresize( imread('../DataImage/20090817_RITPan/P1010030.jpg'), 0.3 );
                im2color = imresize( imread('../DataImage/20090817_RITPan/P1010032.jpg'), 0.3 );
        end

        im1 = im2double(rgb2gray(im1color));
        im2 = im2double(rgb2gray(im2color));
        % Calculate the H matrix and the inliers with SIFT and RANSAC
        % algorithm
        H = img_analyzer.im2homogeneousmatrix(im1, im2);
        % Calculate new image and the (x,y) offsets based on the
        % homogeneous matrix
       [dy, dx, im2new] = img_processor.H2imnew(im1, im2, H );
       % Store the [dy, dx, im2new] to serial of images
       dys = [0, dy];
       dxs = [0, dx];
       ims = {im1, im2new};
       
       figure, subplot(1,2,1), imshow(im1), subplot(1,2,2), imshow(im2);
    else
    % Multiple images case
        [fnames,fpath] = img_acquire.jpggetfiles( );
        imbuffer = img_acquire.iobuf(fpath,fnames);
        imbuffer.format('gray', 0.4 );
        
        frms = length(fnames);
        dys = zeros(frms, 1);
        dxs = zeros(frms, 1);
        ims = cell(frms, 1);

        % Loop for calculate H matrix between images
        im1 = imbuffer.fnames2im(fnames{1});
        ims{1} = im1;
        for idx = 2:length(ims)
            im2 = imbuffer.fnames2im(fnames{idx});
            
            % Calculate the H matrix and the inliers with SIFT and RANSAC 
            % algorithm
            [H, inliers] = img_analyzer.im2homogeneousmatrix(im1, im2);
            
            if inliers ~= 0
                % Calculate new image and the (x,y) offsets based on the
                % homogeneous matrix
                [dy, dx, im2new] = img_processor.H2imnew(im1, im2, H );
            else
                dy=0;
                dx = 0;
                im2new = 0;
            end
            
            % Store the [dy, dx, im2new] to serial of images
            dys(idx) = dy;
            dxs(idx) = dx;
            ims{idx} = im2new;
        end
        
    end
    
    %% Generate the template image
    
    [hbase,wbase,chbase] = size(im1);
    for idx = 2:length(ims)
        % Calculate the size
        [h,w,ch] = size(im2new);
        if hbase < h
            hbase = h;
        end
        if wbase < w
            wbase = w;
        end
        if chbase < ch
            chbase = ch;
        end
    end
    % calculate four directional extention
    plusbottom= abs(sum(dys.*(dys>0)));
    plustop = abs(sum(dys.*(dys<0)));     %notice the y axis in Matlab is inverse...
    plusright = abs(sum(dxs.*(dxs>0)));
    plusleft = abs(sum(dxs.*(dxs<0)));
    
    img_pan = zeros(plusbottom+hbase+plustop,plusleft+wbase+plusright,chbase);
    
    %% Append all images onto the template image
    for idx = 1:length(ims)
        dx = dxs(idx);
        dy = dys(idx);
        im = ims{idx};

        [h,w] = size(im);
        dsty = (1+plustop+dy):(plustop+dy+h);
        dstx = (1+plusleft++dx):(plusleft+dx+w);
        
        im_background = img_pan(dsty,dstx,:) .* isnan(im(1:h,1:w,:));
        im(isnan(im)) = 0;
        
        img_pan(dsty,dstx,:) = im + im_background;
    end

    figure, imshow(img_pan);

end

















































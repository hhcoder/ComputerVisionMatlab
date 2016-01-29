% Panaramatic Scene Composition

load demoOpticalFlow_panImageStitching

%% (1) Read in and show the panaromatic video sequence
    vin_pan = img_acquire.im2video( fpath, fnames );
    mplay(vin_pan);
    
%% (2) Calculate the motion vector between each two frames
    [dy,dx,vblock_pan] = img_analyzer.mov2motionvector( vin_pan, 'trace only two frames', 'edge' );
    
%% (3) Do the Pan image stitching

    plusbottom= abs(sum(dy.*(dy<0)));
    plustop = abs(sum(dy.*(dy>0)));
    plusleft = abs(sum(dx.*(dx>0)));
    plusright = abs(sum(dx.*(dx<0)));
        
    [h,w,ch,frms] = size(vin_pan);
    img_pan = zeros(plusbottom+h+plustop,plusleft+w+plusright,ch);

    dsty = (1+plusbottom):(plusbottom+h);
    dstx = (1+plusleft):(plusleft+w);

    img_pan(dsty,dstx,:) = vin_pan(1:h,1:w,:,1);
    for i=2:frms
        % Notice it's -dy & -dx because we're not trying to compensate the
        % movement but expand images
        dsty = dsty-dy(i);
        dstx = dstx-dx(i);
        img_pan(dsty,dstx,:) = vin_pan(1:h,1:w,:,i);
    end
    
    imshow(img_pan);


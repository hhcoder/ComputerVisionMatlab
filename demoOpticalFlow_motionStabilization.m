% Block-based Motion RMS Estimation with linear search
% - Single block search
% - Only fixing the position offset

load demoOpticalFlow_motionStabilization.mat;


%% (1) Read in the video sequence
    vin_mov = img_acquire.im2video( fpath, fnames );
    mplay(vin_mov);
    
%% (2) Calculate the motion vector between each frames
    [dy,dx,vblock_mov] = img_analyzer.mov2motionvector( vin_mov,'center block tracing', 'intensity' );

%% (3) Do the cropping display
    crop = 16;
	[h,w,ch,frms] = size(vin_mov);
    nh = h-crop.*2+1;
    nw = w-crop.*2+1;
    vcomp = zeros(nh,nw,ch,frms);
    ypos = crop:(h-crop);
    xpos = crop:(w-crop);

    for i=1:length(dy)
        ddy = dy(i);
        ddx = dx(i);
        ypos = min(nh,max(1,ypos+ddy)); 
        xpos = min(nw,max(1,xpos+ddx));
        vcomp(:,:,:,i) = vin_mov(ypos,xpos,:,i);
    end

%% (4) Display results
    mplay(vcomp);


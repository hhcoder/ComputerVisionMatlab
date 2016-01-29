function run_hdr_split_disp(fname)

    if(nargin<1)
        [fnames,fpath] = img_acquire.hdrgetfiles( );
        fname = strcat(fpath,fnames);
    end
    
    hdr_img = hdrread(fname);

%% Tone Mapping section
    ldr_img_linear = run_hdr_to_ldr(hdr_img, 'linear');
    ldr_img_toned = run_hdr_to_ldr(hdr_img, 'exp');
    
    [w,h,c] = size(ldr_img_linear);
    

%% Show on the screen
    
    
    imshow(srgb_img);   

end
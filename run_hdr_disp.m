%fname = '.\DataHDR\ImgHDRformat\forest_path.hdr';
function run_hdr_disp(fname, tone_select)

    if(nargin<1)
        [fnames,fpath] = img_acquire.hdrgetfiles( );
        fname = strcat(fpath,fnames);
    end
    
    hdr_img = hdrread(fname);

%% Tone Mapping section
    if nargin < 2
        tone_select = 'exp';
        %tone_select = 'log';
    end
    
    ldr_img = run_hdr_to_ldr(hdr_img, tone_select);

%% Show on the screen
    srgb_img = hdr_fusion.ldr2srgb(ldr_img);
    
    imshow(srgb_img);   

end
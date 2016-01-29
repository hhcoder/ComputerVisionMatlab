function patch_img = ref2xyzpatches( ...
    ref,...
    cmf, illum,...
    patch_w, patch_h,...
    sep_size,...
    columns )

    if sep_size <= 0
        sep_size = 1;
    end

    num_samples = size(ref,1);

    colors = color_tool.ref2xyz( ref, cmf, illum );
    
    rows = ceil(num_samples./columns);
    
    im_w = patch_w.*columns + sep_size.*(columns+1);
    im_h = patch_h.*rows + sep_size.*(rows+1);
    patch_img = zeros( im_h, im_w, 3 );
    
    idx = 1;
    for i=0:(rows-1)
        for j=0:(columns-1)
            if idx <= num_samples
                x0 = sep_size+j*(sep_size+patch_w);
                x1 = x0+patch_w;
                y0 = sep_size+i*(sep_size+patch_h);
                y1 = y0+patch_h;

                patch_img(y0:y1,x0:x1,1) = colors(1,idx);
                patch_img(y0:y1,x0:x1,2) = colors(2,idx);
                patch_img(y0:y1,x0:x1,3) = colors(3,idx);
            end
            idx = idx+1;
        end
    end

end
function hdr_img = run_hdr_fusion(fnames, fpath, fusion_select)

    switch lower(fusion_select)
        case 'linear'
            hdr_img = hdr_fusion.linear( fnames,fpath );
        case {'mtb', 'variance-based', 'ward'}
            hdr_img = hdr_fusion.mtb( fnames,fpath );
        case {'khan06','kernel density estimation', 'kme'}
            hdr_img = hdr_fusion.khan06( fnames,fpath ); 
    end

end
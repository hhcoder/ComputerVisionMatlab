function rgb = demosaicking(fdata, width, height, bayer_pattern, mode)
    raw = reshape(fdata, width, height);
    
    [raw_r, raw_g, raw_b] = demosaicking_mask( raw, bayer_pattern);
    
    switch lower(mode)
        case 'fourier'
            rgb = demosaicking_fourier( raw_r, raw_g, raw_b );
        case {'average'}
            rgb = demosaicking_average( raw_r, raw_g, raw_b );
    end
    
end
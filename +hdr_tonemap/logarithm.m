function ldr = logarithm( hdr_img, anchor_select )
    switch lower(anchor_select)
        case {'lmax','max'}
            Lanchor = max(max(max(hdr_img)));
        case {'average', 'lav', 'av'}
            Lanchor = mean(mean(mean(hdr_img)));
        case {'max+av'}
            Lanchor = (max(max(max(hdr_img))) + mean(mean(mean(hdr_img))))./2;
    end

    ldr = log10(1+hdr_img)./log10(1+Lanchor);

end
function ldr = exponential( hdr_img, anchor_select )
    switch lower(anchor_select)
        case {'lmax','max'}
            Lanchor = max(max(max(hdr_img)));
        case {'average', 'lav', 'av'}
            Lanchor = mean(mean(mean(hdr_img)));
        case {'max+av'}
            Lanchor = (max(max(max(hdr_img))) + mean(mean(mean(hdr_img))))./2;
    end

    ldr = 1 - exp( -(hdr_img./Lanchor) );

end
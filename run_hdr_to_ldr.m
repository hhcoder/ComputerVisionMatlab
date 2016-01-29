function ldr_img = run_hdr_to_ldr(hdr_img, tone_select)
    % Do the tone mapping
    switch lower(tone_select)
        case {'ward contrast', 'ward94'}
            % This method seems useless for those high-contrast hdr images
            ldr_img = hdr_tonemap.ward_contrast( hdr_img, 50 );

        case {'ferwerda96', 'ferwarda jnd', 'ferwerda visual adaptation'}
            ldr_img = hdr_tonemap.ferwerda_adaptation( hdr_img );

        case {'logarithm mapping', 'logarithm', 'log'}
            ldr_img = hdr_tonemap.logarithm(hdr_img, 'Lmax');
            
        case {'exponential mapping', 'exponent', 'exp'}
            ldr_img = hdr_tonemap.exponential(hdr_img, 'Lav');
            
        case {'drago03', 'drago logarithm', 'drago log', 'drago'}
            ldr_img = hdr_tonemap.drago_logarithm(hdr_img,0.8,100);
            
        case {'icam', 'fairchild icam'}
            ldr_img = hdr_tonemap.fairchild_icam( hdr_img );
        case {'linear', 'lin'}
            ldr_img = hdr_tonemap.linear(hdr_img);
    end

end
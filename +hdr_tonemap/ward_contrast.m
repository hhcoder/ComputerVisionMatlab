function ldr = ward_contrast( src_hdr, Ldmax)
    if nargin < 2
        Ldmax = 80;
    end
    
    N = sum(sum(sum(src_hdr~=0)));
    Lwa = exp( (1./N) .* sum(sum(sum(10e-8+src_hdr))) );
    m = (1./Ldmax) .* ( (1.219+(Ldmax./2).^0.4)./(1.219+Lwa.^0.4) ).^2.5;
    
    ldr = m .* src_hdr;
end
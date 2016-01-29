function ret = imfilter_gauss( I, b, i )

if nargin < 2
    b = 3;
    i = 0.01;
end

    [wys,wxs] = meshgrid(floor(-b/2):1:floor(b/2));
    gausswin = @(I,sigma_len)(exp(-I./2.*(sigma_len.^2)) );
    
    gw = gausswin(sqrt(wys.^2+wxs.^2), i);
    
    ret = imfilter(I, gw./sum(sum(gw)));
end


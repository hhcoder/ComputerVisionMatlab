function plot_srgbimggamut( isrgb, axes )

    cf1 = makecform('srgb2lab');
    ilab = applycform( isrgb, cf1 );

    dims = size(ilab);
    histbin = zeros(100, 256, 256 );
    h2 = waitbar( 0, 'Please wait gamut analysis');
    
    for i=1:dims(1)
        for j=1:dims(2)
            l = floor( ilab(i,j,1) ) + 1;
            a = floor( ilab(i,j,2) ) + 128 + 1;
            b = floor( ilab(i,j,3) ) + 128 + 1;
            t = histbin(l,a,b);
            histbin(l,a,b) = t + 1;
        end
        waitbar(i./dims(1),h2);
    end

    idx = find( histbin > dims(1)*dims(2)*0.00003 );
    [i1,i2,i3] = ind2sub(size(histbin),idx);

    cf2 = makecform('lab2srgb');
    l = i1-1;
    a = i2-128-1;
    b = i3-128-1;
    crgb = applycform( [l,a,b], cf2 );
    close(h2);

    if nargin > 1
        scatter3(a,b,l,12,crgb,'filled', 'Parent', axes);
        rotate3d on
    else
        figure;
        scatter3(a,b,l,12,crgb,'filled')
    end
    xlabel('b');
    ylabel('a');
    zlabel('l*');
end
function [rgb] = demosaicking_average( raw_r, raw_g, raw_b )

    % The linear interpolation kernel for channel G
    avg_g = [   0,1,0;
                1,4,1;
                0,1,0 ];
    avg_g = avg_g./sum(sum(avg_g));

    % The linear interpolation kernel for channel R & B
    avg_rb = [  1,2,1;
                2,4,2;
                1,2,1 ];
            
    avg_rb = avg_rb./sum(sum(avg_rb));

    r = imfilter( raw_r, avg_rb );

    g = imfilter( raw_g, avg_g );

    b = imfilter( raw_b, avg_rb );

    rgb = cat( 3, uint8(r), uint8(g), uint8(b) );

end
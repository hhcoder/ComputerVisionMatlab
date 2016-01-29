function [rgb] = demosaicking_fourier( raw_r, raw_g, raw_b )

% lum_ker = [ 1, 0, 2, 0, 1;
%             0, 0, 4, 0, 0;
%     		2, 4, 8, 4, 2;
%             0, 0, 4, 0, 0;
%             1, 0, 2, 0, 1 ];

% lum_ker = [  1,2,1;
% 			2,4,2;
% 			1,2,1 ];
        
% avg_rb = [  1,2,1;
% 			2,4,2;
% 			1,2,1 ];


kernel_rb = [ -2,  3, -6,  3, -2;
             3,  4,  2,  4,  3;
            -6,  2, 48,  2, -6;
             3,  4,  2,  4,  3;
            -2,  3, -6,  3, -2 ];

kernel_rb = kernel_rb./sum(sum(kernel_rb));

avg_rb = [  0,1,0;
    		1,4,1;
    		0,1,0 ];


avg_rb = avg_rb./sum(sum(avg_rb));

r = imfilter( raw_r, kernel_rb );
r = imfilter( r, avg_rb );

b = imfilter( raw_b, kernel_rb );
b = imfilter( b, avg_rb );

g = uint8(raw_g);

rgb = cat( 3, uint8(r), uint8(g), uint8(b) );

end
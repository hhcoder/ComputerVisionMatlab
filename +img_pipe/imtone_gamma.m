function [dst] = demosaicking_gamma( src )

% system gain
Kg = 1.0;

% system offset
Ko = 0.0;

% gamma value
% let gamma = 1.0 thus skip the gamma procedure
gamma = 1.0/2.2;

% overall offset
Koo = 0.01;

% calculate the maximal pixel value
pix_max = max( max( max( src ) ) );

dst = ( ( Kg * double(src/pix_max) + Ko ) .^ gamma )+ Koo;

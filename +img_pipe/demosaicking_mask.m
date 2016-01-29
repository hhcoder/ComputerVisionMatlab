function [raw_r, raw_g, raw_b] = demosaicking_mask( raw, mode )

[rows, columns] = size( raw );
length = max( [rows, columns] );

n = 1:length;

% generate 1010 series by (-1)^n
x = ( (-1).^n + 1 ) /2;
% generate 0101 series by 1111 - 1010
y = 1 - x;

% X1 = 0 1 0 1 0 1
%      0 1 0 1 0 1
%      0 1 0 1 0 1
%      0 1 0 1 0 1

% Y1 = 0 0 0 0 0 0 
%      1 1 1 1 1 1
%      0 0 0 0 0 0 
%      1 1 1 1 1 1

[X1, Y1] = meshgrid( x, y );

% X2 = 1 0 1 0 1 0
%      1 0 1 0 1 0
%      1 0 1 0 1 0
%      1 0 1 0 1 0

% Y2 = 1 1 1 1 1 1
%      0 0 0 0 0 0 
%      1 1 1 1 1 1
%      0 0 0 0 0 0 
[X2, Y2] = meshgrid( y, x );

if nargin < 2
    % OR, Set this mode for DCRAW software decoded raw data
    mode = 'RGGB';
end

switch mode
    case 'RGGB'
        msk_red = X2 .* Y1;
        msk_blue = X1 .* Y2;
        msk_green = 1 - ( msk_red + msk_blue );

    case 'GRBG'
        msk_red = X1 .* Y1;
        msk_blue = X2 .* Y2;
        msk_green = 1 - (msk_red + msk_blue );

    case 'BGGR'
        msk_red = X1 .* Y2;
        msk_blue = X2 .* Y1;
        msk_green = 1 - (msk_red + msk_blue );

    case 'GBRG'
        msk_red = X2 .* Y2;
        msk_blue = X1 .* Y1;
        msk_green = 1 - (msk_red + msk_blue);
end

raw_r = msk_red(1:rows, 1:columns) .* raw;
raw_g = msk_green(1:rows, 1:columns) .* raw;
raw_b = msk_blue(1:rows, 1:columns) .* raw;

end
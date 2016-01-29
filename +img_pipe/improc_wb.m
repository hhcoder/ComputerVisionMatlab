% The function for "gray-world" white balance
function [dst] = demosaicking_wb( src )

red = src(:,:,1);
red_sum = sum( sum(red) );

green = src(:,:,2);
green_sum = sum( sum(green) );

blue = src(:,:,3);
blue_sum = sum( sum(blue) );

rgain = green_sum/red_sum
b_gain = green_sum/blue_sum

dst = cat( 3, (red .* rgain), green, (blue .* b_gain) );
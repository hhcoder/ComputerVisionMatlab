% BLOCK2MOTIONVECTOR - This function is deprecated
% 
% Usage:
%     [dy,dx] = block2motionvector( img1, img2, posyx, block, search_range,
%     compare_rule )
%
% img1: 
% img2:
% posyx: the position of center processing pixel in the specified block 
% bsize: vector denotes the block range, i.e., -3:3
% search_range: vector denotes the searching range, i.e., -20:20
%
function [dy,dx] = block2motionvector( img1, img2, posyx, block, search_range, compare_rule )

    for i=search_range(1):search_range(end)
        for j=search_range(1):search_range(end)
            b1 = img1(posyx(1),posyx(2),:);
            b2 = img2(pos_y+search_range(j),pos_x+search_range(i),:);
            switch lower(compare_rule)
                case {'mse', 'sub+square+sum'}
                    diff(j,i) = sqrt(sum(sum(sum( (b1-b2).^2 ))));
                case 'sub+sum'
                    diff(j,i) = sum(sum(sum(b1-b2)));
                case 'xor+sum'
                    diff(j,i) = sum(sum(sum(xor(b1,b2))));
            end

        end
    end

    [y,x] = ind2sub( size(diff),find(diff==min(min(diff))) );

    dy = search_range(y);
    dx = search_range(x);

end
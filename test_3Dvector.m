function test_3Dvector

imorigin = imread('im3dbikini1.jpg');
worigin = size(imorigin,2);

imleft = imorigin(:, 1:ceil(worigin/2), :);
imright = imorigin(:, ceil(worigin/2)+1:end, :);

fkernel = [1 1 1 1; 1 1 1 1; -1 -1 -1 -1; -1 -1 -1 -1];
comp_rate = 0.3;
imhpleft = imfilter(imresize(imright(:,:,2),comp_rate), fkernel);
imhpright = imfilter(imresize(imleft(:,:,2),comp_rate), fkernel);

[Ilabel, numlabel] = bwlabel(imregionalmax(imhp),4);

dxs = zeros(1,numlabel);
dys = zeros(1,numlabel);
for i=1:numlabel
    % the upper left index
    ul_idx = find((Ilabel==i),1,'first');
    % Find the exact [x,y] position of each block
    [y,x] = ind2sub( size(imhpleft), ul_idx );
    [dys(i), dxs(i)] = blockmatching(imhpleft, imhpright, y, x, 3);
end

end
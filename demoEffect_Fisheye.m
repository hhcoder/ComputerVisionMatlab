function demoEffect_Fisheye
%% Try another "fisheye" effect

% this function is the core part...
func = @(x)(sin(linspace(-pi/2, pi/2, length(x))) .* (max(x)-min(x))./2);

yradius = 60;
xradius = 60;

Icolor = imread('imsnow.jpg');
Ibw = im2double(Icolor(:,:,2));

hfig = figure;
imshow(Ibw);
h = size(Ibw,1);
w = size(Ibw,2);
[posxs,posys] = getpts(hfig);

Iresult = Ibw;

for i=1:length(posxs)

ui_y = min(max(posys(i),yradius),h-yradius);
ui_x = min(max(posxs(i),xradius),w-xradius);

range_y = -yradius+1:yradius;
func_y = func(range_y);
range_x = -xradius+1:xradius;
func_x = func(range_x);

src_y = ceil(ui_y+range_y);
src_x = ceil(ui_x+range_x);

out_y = ui_y+func_y;
out_x = ui_x+func_x;

[x,y] = meshgrid(src_x, src_y);
[xi,yi] = meshgrid(out_x, out_y);

Bresult = interp2(x,y,Iresult(src_y,src_x),xi,yi,'spline');
Bmask = generate_circle_mask(size(Bresult,1), size(Bresult,2));
Bresult = Bmask.*Bresult;

Iresult(src_y,src_x) = Iresult(src_y,src_x) .* (Bmask==0);
Iresult(src_y,src_x) = Iresult(src_y,src_x) + Bresult;
end

imshow(Iresult), drawnow;

end

function mask = generate_circle_mask(y,x)
    [xi,yi] = meshgrid(ceil(-x./2)+1:ceil(x/2),ceil(-y./2)+1:ceil(y./2));
    r = ceil(min(x,y)./2);
    mask = double((xi.^2+yi.^2) < r.^2);
end
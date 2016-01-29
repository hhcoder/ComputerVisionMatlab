% IMFILTER_BILATERAL_RANGE - run the range filtering on the image

function signal2out = imfilter_bilateral_range( signal2in, win2d, func )

if nargin < 2
    win2d = -8:8;
end

if nargin < 3
    func = @(v)( exp(-(v).^2 ./ (2.*0.9.^2)) );
end

signal2out = zeros(size(signal2in));

hdisp = waitbar(0, 'Running range filter');

for i=1-win2d(1):size(signal2in,1)-win2d(end)
    for j=1-win2d(1):size(signal2in,2)-win2d(end)
        p2center = signal2in(i,j);
        p2neighbor = signal2in(i+win2d,j+win2d);
        
        weight = func(p2center-p2neighbor);
        signal2out(i,j) = sum(sum(weight.*p2neighbor)) ./ sum(sum(weight));
    end
    waitbar(i./(size(signal2in,1)-win2d(end)));
end
close( hdisp );

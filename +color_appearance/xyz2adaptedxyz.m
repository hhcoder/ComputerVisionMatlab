% ixyz: input xyz value
% xyzn: white point of source
% xyzt: target adaptation white value
function mreturn = xyz2adaptedxyz( ixyz, xyzn, xyzt, mode, D )
    if nargin < 4
        mode = 'MCAT02';
        D = 1.0;    %adaptation factor
    end

    Mcat02 = [  0.7382 0.4296 -1.624; ...
               -0.7036 1.6975 0.0061; ...
                0.0030 0.0136 0.9834 ];
    
    irgb = Mcat02 * ixyz;
    
    wrgb = Mcat02 * xyzn;

    trgb = Mcat02 * xyzt;
    
    crgb = zeros( size(ixyz) );
    
    crgb(1,:) = ( trgb(1)./wrgb(1) .*D ) + (1 - D) .* irgb(1,:);
    crgb(2,:) = ( trgb(2)./wrgb(2) .*D ) + (1 - D) .* irgb(2,:);
    crgb(3,:) = ( trgb(3)./wrgb(3) .*D ) + (1 - D) .* irgb(3,:);
    
    mreturn = crgb;
    
end
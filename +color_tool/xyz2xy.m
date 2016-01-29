% XYZ2XY - Transform XYZ value to XY value
function [xy] = xyz2xy( xyz )
    xy = zeros(2,size(xyz,2));
    xy(1,:) = xyz(1,:)./sum(xyz);
    xy(2,:) = xyz(2,:)./sum(xyz);
end
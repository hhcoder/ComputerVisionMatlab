function mreturn = xyz2srgb( xyz, wp )
%     if sum(sum(xyz>1.0)) > 1
%         nxyz = xyz;
%         sum_nxyz = (nxyz(:,:,1)+nxyz(:,:,2)+nxyz(:,:,3));
%         xyz(:,:,1) = nxyz(:,:,1)./sum_nxyz;
%         xyz(:,:,2) = nxyz(:,:,2)./sum_nxyz;
%         xyz(:,:,3) = nxyz(:,:,3)./sum_nxyz;
%     end

    lab = color_tool.xyz2lab(xyz,wp);
    srgbcf = makecform('lab2srgb');
    mreturn = applycform( lab, srgbcf );
end
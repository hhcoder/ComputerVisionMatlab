function canvas = disp_split(iml, imr, wloc, axe)
    if (3~=sum(size(iml)==size(imr)))
        sprintf('im1 and im2 has to be in same dimension');
    end

    [h,w,c] = size(iml);    
    canvas = zeros(h,w,c);
    canvas(:,1:wloc,:)=iml(:,1:wloc,:);
    canvas(:,wloc:end,:) = imr(:,wloc:end,:);
    
    imshow(canvas, 'Parent', axe);
end
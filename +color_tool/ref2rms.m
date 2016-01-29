function ret = ref2rms( src, dst )
    if size(src)~=size(dst)
        error('Dimension must be the same!');
    end

    rows = size(src,1);
    columns = size(src,2);
    
    ret = zeros(rows,1);
    
    for i=1:rows
        diff = src(i,:) - dst(i,:);
        ret(i) = sqrt( (1./columns) .* sum( diff.^2 ) );
    end
end

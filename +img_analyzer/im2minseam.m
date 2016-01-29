% The input image should be MxNx3 colored image in double format
function [ret1,ret2, rpath] = im2minseam( srcimg, mode )

    if nargin < 3
        %axes = gca;
    end

    gradx = @(i)( imfilter(i,[-1,1]) );
    grady = @(i)( imfilter(i,[1;-1]) );

    gx = abs( gradx(srcimg) );
    gy = abs( grady(srcimg) );

    % Consider gray only in the first place
    gradimg = gx(:,:,2) + gy(:,:,2);

    % Looking for the best path
    
    switch mode
        case {'X','x'}
            [mn,idxmn] = min(gradimg(:,1));
            search_points = find( gradimg(:,1) <= mn );
        case {'Y','y'}
            [mn,idxmn] = min(gradimg(1,:));
            search_points = find( gradimg(1,:) <= mn );
    end
    
    weights = zeros(1,size(search_points,1));
    rpaths = cell(1,size(search_points,1));
    for i=1:size(search_points)
        [rpaths{i},weights(i)] = find_opt_path( gradimg, mode, idxmn );
    end
    
    [mnval,mnidx] = min(weights);
    rpath = rpaths{mnidx};

    ret1 = fill_in_path(srcimg, rpath, [1 0 0]);
    ret2 = remove_path(srcimg, rpath, mode );

end

function [rpath,weights] = find_opt_path( gradimg, direction, idxmn, idx_lbound, idx_rbound )

if nargin == 3
    idx_lbound = [1,1];
    idx_rbound = [size(gradimg,1), size(gradimg,2)];
end

minmax = @(mn,i,mx)( max( min( i, mx ), mn ) );

switch direction
    case {'X','x'}
        y = idxmn;
        lbound = idx_lbound(2);
        rbound = idx_rbound(2);
        rpath = zeros(rbound-lbound+1,2);
        rpath(1,:) = [y,1];
        weights = 0;
        for x = (lbound+1):rbound
            %         P
            %   P-1   P    P+1
            %    1    2     3
            %  Therefore, it's P+(idx-2)
            y = minmax( 2, y+(idxmn-2), idx_rbound(1)-1 );
            [mn,idxmn] = min( gradimg(y-1:y+1,x) );
            rpath(x-(lbound+1)+1+1,:) = [y,x];
            weights = weights + mn;
        end
        
    case {'Y','y'}
        x = idxmn;
        lbound = idx_lbound(1);
        rbound = idx_rbound(1);
        rpath = zeros(rbound-lbound+1,2);
        rpath(1,:) = [1,x];
        weights = 0;
        for y = (lbound+1):rbound
            x = minmax( 2, x+(idxmn-2), idx_rbound(2)-1 );
            [mn,idxmn] = min( gradimg(y,x-1:x+1) );
            rpath(y-(lbound+1)+1+1,:) = [y,x];
            weights = weights + mn;
        end
        
end

end

% Used for display which seam being removed
function ret = fill_in_path( srcimg, rpath, color )

    if nargin < 3
        color = [0 1 0];
    end
    
    ret = srcimg;

    for i=1:size(rpath,1)
        ret(rpath(i,1), rpath(i,2), : ) = color;
    end

end

function ret = remove_path( srcimg, rpath, mode )
    switch mode
        case {'X','x' }
            ret = zeros( size(srcimg,1)-1, size(srcimg,2), size(srcimg,3) );
            for i=1:size(rpath,1)
                y = rpath(i,1);
                ret(:,i,:) = srcimg([1:y-1,y+1:end], i, : );
            end
        case {'Y','y' }
            ret = zeros( size(srcimg,1), size(srcimg,2)-1, size(srcimg,3) );
            for i=1:size(rpath,1)
                x = rpath(i,2);
                ret(i,:,:) = srcimg(i, [1:x-1,x+1:end], : );
            end
    end
end


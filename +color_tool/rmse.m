function ret = rmse( src, dst )
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
    
    
% Function to calculate root mean square error from a data vector or matrix 
% and the corresponding estimates.
% Usage: r=rmse(data,estimate)
% Note: data and estimates have to be of same size
% Example: r=rmse(randn(100,100),randn(100,100));

% % delete records with NaNs in both datasets first
% I = ~isnan(data) & ~isnan(estimate); 
% data = data(I); estimate = estimate(I);
% 
% r=sqrt(sum((data(:)-estimate(:)).^2)/numel(data));
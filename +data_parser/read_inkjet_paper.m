function ret_spec = read_inkjet_paper( ...
    fname_dc, ...
    fname_spec, ...
    fmin_lambda,...
    finterval,...
    fmax_lambda,...
    omin_lambda, ...
    ointerval,...
    omax_lambda )

    if nargin < 1
        [filename, pathname] = uigetfile( '*.txt', 'DC value for samples' );
        fname_dc = strcat(pathname,filename);
        [filename, pathname] = uigetfile( '*.txt', 'Spectrum value for samples' );
        fname_spec = strcat(pathname,filename);
    end
    
    % digital counts need not 
    dc = dlmread( fname_dc );
    
    paper_idx = find( sum( (dc == 0)' ) == 7 );

    % spectrum need to be truncate if what we want is not the same with
    % filename
    spec = dlmread( fname_spec );
    spec = spec(:,1:end-1);
    
    spec_unlim = spec(paper_idx,:);

    ret_spec = color_tool.ref2ref(...
        spec_unlim, ...
        fmin_lambda, finterval, fmax_lambda,...
        omin_lambda, ointerval, omax_lambda );

%     out_rows = size(spec_unlim,1);
%     out_cols = size(omin_lambda:ointerval:omax_lambda,2);
%     ret_spec = zeros(out_rows, out_cols);
%     for i=1:out_rows
%         ret_spec(i,:) = interp1(...
%             fmin_lambda:finterval:fmax_lambda,...
%             spec_unlim(i,:),...
%             omin_lambda:ointerval:omax_lambda);
%     end
    
%     if fmin_lambda > omin_lambda || fmax_lambda > omax_lambda || finterval ~= ointerval
%         front_truncate = (omin_lambda-fmin_lambda)./ finterval;
%         end_truncate = (fmax_lambda-omax_lambda)./finterval;
%         interval = ointerval./finterval;
%         ret_spec = ret_spec(:, (front_truncate+1):interval:(end-end_truncate-1) );
%     end

end
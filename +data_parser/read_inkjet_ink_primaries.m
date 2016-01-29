% Read the inkjet printed primaries (pure) information
function [ret_dc, ret_spec] = read_inkjet_ink_primaries( ...
    fname_dc,  ...
    fname_spec, ...
    fmin_lambda,...
    finterval,...
    fmax_lambda,...
    omin_lambda, ...
    ointerval,...
    omax_lambda )

    if nargin < 1
        [filename, pathname] = uigetfile( '*.txt', 'DC value for ink primaries' );
        fname_dc = strcat(pathname,filename);
        [filename, pathname] = uigetfile( '*.txt', 'Spectrum value for ink primaries' );
        fname_spec = strcat(pathname,filename);
    end

    ramp_dc = dlmread( fname_dc );
    spectrum_dc = dlmread( fname_spec );
    spectrum_dc = spectrum_dc(:,1:end-1);
    
%    ch_count = size(ramp_dc, 2);
%    spec_count = size(spectrum_dc, 2);
    
%     spec_unlim = zeros(ch_count,spec_count);
%     ret_dc = zeros(ch_count,ch_count);

    spec_unlim = spectrum_dc;
    ret_dc = ramp_dc;
    
    ret_spec = color_tool.ref2ref(...
        spec_unlim, ...
        fmin_lambda, finterval, fmax_lambda,...
        omin_lambda, ointerval, omax_lambda );

%     for i=1:ch_count
%         idx = find(ramp_dc(:,i)==100);
%         spec_unlim(i,:) = spectrum_dc(idx,:);
%         ret_dc(i,:) = ramp_dc(idx,:);
%     end
    
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
function ldr = bilateral_rangefilter( src_hdr, w, sigma_r )

if nargin < 3
    %sigma_r = 0.1;
    sigma_r = 2.5;
end

if nargin < 2
    w = 3;
end
    
    dims = size(src_hdr);
    B = zeros( dims );
    C = zeros( dims );
    A = src_hdr;
    
    h = waitbar(0,'Applying bilateral filter...');
    set(h,'Name','Range Filter Progress');
    
    %tone1d = @(v,s)( exp( -(v)./(2.*s.^2) ) );
    %tone1d = @(v,s)( v.^0.2 );
    tone1d = @(v,s)( 1 - (v.^5)./(s+(v.^5)) );
    
    for i=1:dims(1)
        for j=1:dims(2)

            % Extract local region.
            iMin = max(i-w,1);
            iMax = min(i+w,dims(1));
            jMin = max(j-w,1);
            jMax = min(j+w,dims(2));
         
            I = A(iMin:iMax,jMin:jMax,:);
         
            % Compute Gaussian range weights.
            dL = I(:,:,1)-A(i,j,1);
            da = I(:,:,2)-A(i,j,2);
            db = I(:,:,3)-A(i,j,3);
            %F = tone1d( dL.^2+da.^2+db.^2, sigma_r );
            
            F1 = tone1d(dL,sigma_r);
            F2 = tone1d(da,sigma_r);
            F3 = tone1d(db,sigma_r);
            
            % Calculate the normailization term
%            norm_F = sum(F(:));
            
            B(i,j,1) = sum(sum(F1.*I(:,:,1)))/sum(F1(:));
            B(i,j,2) = sum(sum(F2.*I(:,:,2)))/sum(F2(:));
            B(i,j,3) = sum(sum(F3.*I(:,:,3)))/sum(F3(:));
            
            C(i,j,1) = sum(sum(F1));
            C(i,j,2) = sum(sum(F2));
            C(i,j,3) = sum(sum(F3));

        end
        waitbar(i/dims(1));
    end
    
    close(h);
    
    ldr = B;    
end
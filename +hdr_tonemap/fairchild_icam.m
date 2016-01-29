function mreturn = fairchild_icam( src_hdr, D, perc_ckernel, perc_skernel )

if nargin < 4
    perc_skernel = 1./3;
end

if nargin < 3
    perc_ckernel = 1./4;
end

if nargin < 2
    D = 0.9;
end

    imxyz = color_tool.srgb2xyz( src_hdr );

    % 1) Forward Chromatic Adaptation
    cksize = floor( perc_ckernel.* [size(src_hdr,1) size(src_hdr,2)] );
    ckernel = fspecial('gaussian', cksize, 8 );
    
    Yw = [95.05 100 108.88];

    imxyz_fca = chromatic_adaptation_forward( imxyz, ckernel, Yw, D );
    
    % 2) Forward Cone Compression
    sksize = floor( perc_skernel.* [size(src_hdr,1) size(src_hdr,2)] );
    skernel = fspecial('gaussian', sksize, 10 );

    imxyz_fcc = cone_compression_forward( imxyz_fca, skernel );
    
    % 3) Inverse Cone Compression
    imxyz_bcc = cone_compression_inverse( imxyz_fcc );
    
    % 4) Inverse Chromatic Adaptation
    Ye = [100 100 100];
    imxyz_bca = chromatic_adaptation_inverse( imxyz_bcc, Ye, Yw );
    
    imsrgb = color_tool.xyz2srgb( imxyz_bca );
    
    mreturn = imsrgb;
end

% Chromatic Adaptation by CAT02 matrix
function imxyz_fca = chromatic_adaptation_forward( imXYZ, ckernel, Yw, D )

    imCAT = color_appearance.xyz2Mcat02( imXYZ );

    Wc = imfilter( imCAT, ckernel );
    Rc = imCAT(:,:,1) .* ( Yw(1) .* D./Wc(:,:,1) + 1 - D );
    Gc = imCAT(:,:,2) .* ( Yw(2) .* D./Wc(:,:,2) + 1 - D );
    Bc = imCAT(:,:,3) .* ( Yw(3) .* D./Wc(:,:,3) + 1 - D );
    
    % ca: chromatic adaptation
    imCAT_fca = cat(3,Rc,Gc,Bc);
    
    imxyz_fca = color_appearance.Mcat022xyz( imCAT_fca );
    
end

% Cone compression by HPE color space
function imxyz_fcc = cone_compression_forward( imxyz, skernel )
    imlms = color_appearance.xyz2lms( imxyz );
    
    S = abs( imfilter( imlms, skernel ) );
    
    % tc: cone compression
    A = ( (1./(5.*S+1)).^4 );
    B = (5.* S);
    C = ( 1 - (1./(5.*S)).^4 ).^2;
    D = (5.*S).^(1./3);
    
    Fl = (1./1.7).*( (0.2.*A.*B) + (0.1.*C.*D) );

    imlms_cc = abs(imlms).^(0.43.*Fl);

    imxyz_fcc = color_appearance.lms2xyz( imlms_cc );
    
end

function imxyz_bcc = cone_compression_inverse( imxyz_fcc )
    imlms = color_appearance.xyz2lms( imxyz_fcc );
    
    imlms_bcc = abs(imlms).^(1./0.43);
    
    imxyz_bcc = color_appearance.lms2xyz( imlms_bcc );
end

function imxyz_bca = chromatic_adaptation_inverse( imxyz_bcc, Ye, Yw )
    imcat = color_appearance.xyz2Mcat02( imxyz_bcc );
    
    imcat(:,:,1) = imcat(:,:,1) .* Ye(1)./Yw(1);
    imcat(:,:,2) = imcat(:,:,2) .* Ye(2)./Yw(2);
    imcat(:,:,3) = imcat(:,:,3) .* Ye(3)./Yw(3);
    
    imxyz_bca = color_appearance.Mcat022xyz( imcat );
end







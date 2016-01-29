function hdr = developing
    [fnames,fpath] = img_acquire.jpggetfiles( );

    fnames = sort(fnames);
    len = length(fnames);

    imsrgbs = cell(len,1);
    exps = cell(len,1);
    for i=1:len
        fname = strcat(fpath,fnames{i});
        exps{i} = img_analyzer.im2exptime(fname);
        imsrgbs{i} = im2double(imread( fname ));
    end
    
    tonemap = @(v)( 1 - ((v)./(0.3+v)) );

    hdr = zeros( size(imsrgbs{1}) );
    for idxanchor=1:len
        imanchor = imsrgbs{idxanchor};
        improb = zeros(size(imanchor));
        for idxproc=1:len
            if idxanchor ~= idxproc
                imedge = imanchor - imfilter( imsrgbs{idxproc}, fspecial('gaussian', 16, 3.0 ) );
                improb = improb + tonemap( abs(imedge) );
            end
        end

        hdr = hdr + (improb./len).*( imsrgbs{idxanchor}./exps{idxanchor} );
    end

end
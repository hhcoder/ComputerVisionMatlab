function hdr = srgb2hdr( fpath, fnames, offsety, offsetx, exps, gamma )

    len = length(fnames);
    if len < 2
        error('There should be more than 2 images input');
    end

    fnames = sort(fnames);
    iname = cell(len,1);
    for i=1:len
        iname{i} = strcat(fpath,fnames{i});
    end
    
if nargin < 6
    % default sRGB gamma value
    gamma = 2.2;
end

if nargin < 5
    exps = cell(len,1);
    for i=1:len
        exps{i} = img_analyzer.im2exptime(iname{i});
    end
end

if nargin < 4
    offsety = zeros(len,1);
    offsetx = zeros(len,1);
end
    
    % ananymous fxn to indicate where is over/under exposure
    ouexp = @(i,o,u)( 1 - ((i>=o)+(i<=u)) );
    
    h = waitbar(0,'Linear hdr image fusion...');
    set(h,'Name','HDR Fusion in Progress');

    for i=1:len

        img = im2double( imread(iname{i}) );
        exposure = exps{i};
        
        img = (img).^(gamma);
        
        img = img_processor.im2offsetim( img, offsety(i), offsetx(i) );
        
        if i==1
            s = img./exposure;
            smsk = ouexp(img,1.0,0.0);
        else
            s = s + img./exposure;
            smsk = smsk + ouexp(img,1.0,0.0);
        end
        
        waitbar(i./len);
        
    end
    
    clear img;
    
    % Avoid divided by zero (the specified pixel location is always under/over
    % exposed, or is a bad pixel )
    smsk = smsk + ( len.*(smsk==0) );
    hdr = s./smsk;

    close(h);    
end
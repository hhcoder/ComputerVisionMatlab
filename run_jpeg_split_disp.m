function run_jpeg_split_disp(imlname, imrname, axe)

    if(nargin<1)
        [fnames,fpath] = img_acquire.jpggetfiles( );
        len = length(fnames);
        if len ~= 2
            error('There should be only 2 images as input');
        end
        imlname = strcat(fpath,fnames{1});
        imrname = strcat(fpath,fnames{2});
    end
    
    iml = im2double(imread(imlname));
    imr = im2double(imread(imrname));

    [h,w,c] = size(iml);
    
    img_disp.disp_split(iml, imr, w/2, axe);
    

%% Show on the screen

    ratio = 1.2;
   
    zoomed = 0;
    
    imldisp = iml;
    imrdisp = imr;

    while(1)
        [x,y,button] = ginput(1);
        if button==3
            zoomed = zoomed+1;
            if zoomed>=5
                zoomed = 0;
                imldisp = iml;
                imrdisp = imr;
            else
                [posl, posr, post, posb] = getrange(x,y,w,h,ratio);
                imldisp = imresize(imldisp(post:posb, posl:posr,:), [h w], 'bilinear');
                imrdisp = imresize(imrdisp(post:posb, posl:posr,:), [h w], 'bilinear');
            end
        end
        
        img_disp.disp_split(imldisp, imrdisp, int32(x), axe);
        drawnow
    end
    
end

function [l,r,t,b] = getrange(x,y,w,h,ratio)
    l = x-w/(ratio*2);
    r = x+w/(ratio*2);
    t = y-h/(ratio*2);
    b = y+h/(ratio*2);
    if(l<0)
        r = w/ratio;
        l = 1;
    else
        if(r>w/ratio)
            l = w - (w/ratio) + 1;
            r = w;
        end
    end
    
    if(t<0)
        b = h/ratio;
        t = 1;
    else
        if(b>h/ratio)
            t = h - (h/ratio) + 1;
            b = h;
        end
    end
    l = uint32(l);
    r = uint32(r);
    t = uint32(t);
    b = uint32(b);
end
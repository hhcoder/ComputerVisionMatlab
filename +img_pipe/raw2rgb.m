function [frameRGB] = raw2rgb( fname, width, height, mode, display )

switch lower(mode)
    case {'vfe h2v2', 'h2v2', 'vfe default'}
        fdata = file2data( fname, width*height*1.5, 'unsigned char');
        
        frameY = uint8(reshape(fdata(1:width*height), width, height));
        frameCbCr = uint8(reshape(fdata(width*height+1:end), width, height/2));
        frameCb = imresize(frameCbCr(2:2:end, 2:2:end), [width height]);
        frameCr = imresize(frameCbCr(1:2:end, 1:2:end), [width height]);
        
        clear('frameCbCr');
        
        frameYCbCr = cat(3, frameY, frameCb, frameCr);
        frameRGB = ycbcr2rgb(frameYCbCr);

    case {'bayer raw', 'bayer'}
        fdata = file2data( fname, width*height, 'unsigned char');
        
        frameRGB = demosaicking(fdata, width, height, 'RGGB', 'Average');
end

if nargin < 5
    % Display these two images
    figure, imshow( imrotate(frameRGB, 180) );
end
    
end


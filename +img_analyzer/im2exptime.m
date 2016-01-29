% IM2EXPTIME - read the exposure time of the image with EXIF information
function t = im2exptime(iname)
    iinfo = imfinfo(iname);
    if isfield( iinfo, 'DigitalCamera')
        t = iinfo.DigitalCamera.ExposureTime;
    else
        error('No exif info');
    end

end
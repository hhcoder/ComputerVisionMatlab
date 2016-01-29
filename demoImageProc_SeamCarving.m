function ret = demoImageProc_SeamCarving( i, target_size, show_procedure )

    if nargin < 1
        %i = im2double(imread('imgoose.jpg'));
        i = im2double( imread( imgetfile ) );
    end

    if nargin < 2
        target_size = [floor(size(i,1)./2), floor(size(i,2))];
    end
    
    if nargin < 3 
        show_procedure = 1;
    end

    if show_procedure
        figure;
        ret = img_processor.imresize_seam_carving( i, target_size, gca );
    else
        ret = img_processor.imresize_seam_carving( i, target_size, 0 );
        figure, imshow(ret);
    end

end
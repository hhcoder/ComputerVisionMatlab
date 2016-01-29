% RUN_IP_PREPROC - some simple image pre-processing functions
%
% This function runs some simple image processing for preprocessing.
%
% Usage: [dst] = run_ip_preproc( src, opcode )
%
% Arguments:
%    src - the source image
%    opcode - list of image operations, including:
%             'sobel': Sobel operator
%             'dog': Difference-of-Gaussian
%             'bw': Black-or-white thresholding
%             'dog+bw': DoG and BW
%             'sobel+bw': Sobel and BW
% Returns:
%    dst - the result images

function [dst] = run_ip_preproc( src, opcode )

dogfilt = @(I)( abs(imfilter(I,fspecial('gaussian', [3 3], 0.1))-imfilter(I,fspecial('gaussian', [5 5], 0.6))) );
sobelfilt = @(I)( imfilter(I, fspecial('sobel')) );

switch lower(opcode)
    case 'sobel'
        dst = sobelfilt(src);
    case 'dog'
        dst = dogfilt(src);
    case 'bw'
        dst = img_processor.im2binary(src,'percent+threshold+exclusion', .5, 0.04);
    case 'dog+bw'
        dst = img_processor.im2binary(dogfilt(src),'percent+threshold', .5);
    case 'sobel+bw'
        dst = img_processor.im2binary(sobelfilt(src),'percent+threshold', .5);
end

end
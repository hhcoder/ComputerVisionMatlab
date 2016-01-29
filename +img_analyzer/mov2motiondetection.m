% MOV2MOTIONDETECTION - Detect the motion of input sequence images
function mov2motiondetection( fpath, fnames )

% num of frames to average as prior knowledge
N = 1:3;

% Check for read-in frames
if nargin < 1
    [fnames,fpath] = img_acquire.jpggetfiles( );
    fnames = sort(fnames);
    if length(fnames) < length(N)
        error('This method requires more than %d images',length(N));
    end
end

% Setup blurring parameters
im2blur = @(I)( imfilter(I,fspecial('Gaussian', [3 3], 0.7)) );

% Quantization size of pixel value
q_len = 10;

% block range (size == length(rangebk))
B = 2;  %As border
win = -(B):B;

imbuffer = img_acquire.iobuf(fpath,fnames);
imbuffer.format('color', 0.5 );

im1 = imbuffer.fnames2im( fnames{1} );

diff_seq = zeros(size(im1,1), size(im1,2), length(N)-1 );
for i=2:length(fnames)

    % Calculate difference image
    im2 = imbuffer.fnames2im( fnames{i} );
    imd = abs( im2blur(im1(:,:,2)) - im2blur(im2(:,:,2)) );
    diff = gray2ind( imd, q_len );

    % update next frame
    im1 = im2;

    diff_seq(:,:,1:end-1) = diff_seq(:,:,2:end);
    diff_seq(:,:,end) = diff;
    
    mest = img_analyzer.im2dstei( diff_seq, win );
% open this comment to give weighting between previous value and current value
%    a = 0.8;
%    mest = a.*mest1 + (1-a).*mest2;
    
    imb = img_processor.im2binary(mest, 'value+threshold',0.3);
    [border, area, imclean] = img_analyzer.binary2objpos( imb, 4 );
    
    % Setup the alarm size; only object larger than this size will be
    % detected
    alarm_size = 10*15;

    % Update image sequence
    imshow(im1), title(sprintf('Index:%s', fnames{i}));
    for j=1:length(border)
        if area{j} > alarm_size
            rectangle('Position', border{j}, 'LineWidth', 1, 'LineStyle', '-', 'EdgeColor', 'r');
        end
    end

    drawnow;
end

end

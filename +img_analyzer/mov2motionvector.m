% MOV2MOTIONVECTOR - Calculate motion vector from input video sequence
function [dy,dx,mreturn] = mov2motionvector( video_seq, control_code, compare_space )

if nargin < 2
    control_code = 'center block tracing';
end

if nargin < 3
    compare_space = 'intensity';
end

pred_video = video_seq;

[img_h,img_w,img_chs,img_frms] = size(video_seq);

img_prev = video_seq(:,:,:,1);

% The comparing block size and initial position
switch lower(compare_space)
    case 'intensity'
        block_sz = 16;
    case {'edge','edges'}
        block_sz = 64;
end
        
start_y = floor(img_h./2-block_sz./2):floor(img_h./2+block_sz./2);
start_x = floor(img_w./2-block_sz./2):floor(img_w./2+block_sz./2);

% The searching range
search_range = -64:64;
diff = zeros(length(search_range),length(search_range));

dy = zeros(img_frms,1);
dx = zeros(img_frms,1);

h = waitbar(0,'Analysis Block Motion by RMS...');
set(h,'Name','Motion Estimation in Progress');

% Define first frame block position
pos_y = start_y;
pos_x = start_x;

edge_kernel = fspecial('sobel');
for frms = 2:img_frms
    
    switch lower(compare_space)
        % Calculate the RMS between block_content and block_looking within 
        % whole search_range
        case 'intensity'
            block_prev = img_prev(pos_y,pos_x,: );
            img_next = video_seq(:,:,:,frms);
            for i=1:length(search_range)
                for j=1:length(search_range)
                    block_next = img_next(pos_y+search_range(j),pos_x+search_range(i),:);
                    diff(j,i) = sqrt( sum(sum(sum( (block_prev-block_next).^2 ))) );
                end
            end
        % Calculate the RMS of edge image
        case {'edges','edge'}
            img_prev = imfilter(img_prev,edge_kernel);
            block_prev = img_prev(pos_y,pos_x,: );
            img_next = imfilter(video_seq(:,:,:,frms), edge_kernel );

            for i=1:length(search_range)
                for j=1:length(search_range)
                    block_next = img_next(pos_y+search_range(j),pos_x+search_range(i),:);
                    diff(j,i) = sqrt( sum(sum(sum( (block_prev-block_next).^2 ))) );
                end
            end
    end
    
    [y,x] = ind2sub( size(diff),find(diff==min(min(diff))) );
    dy(frms) = search_range(y);
    dx(frms) = search_range(x);

    switch lower(control_code)
        case 'center block tracing'
            pos_y = pos_y + dy(frms);
            pos_x = pos_x + dx(frms);
            pred_video(pos_y,pos_x,1,frms) = 1.0;
            pred_video(pos_y,pos_x,2,frms) = 0.0;
            pred_video(pos_y,pos_x,3,frms) = 0.0;

        case 'trace only two frames'
            pos_y = start_y + dy(frms);
            pos_x = start_x + dx(frms);
            
            pred_video(start_y,start_x,1,frms) = 1.0;
            pred_video(start_y,start_x,2,frms) = 0.0;
            pred_video(start_y,start_x,3,frms) = 0.0;
            
            pred_video(pos_y,pos_x,1,frms) = 0.0;
            pred_video(pos_y,pos_x,2,frms) = 1.0;
            pred_video(pos_y,pos_x,3,frms) = 0.0;
    end

    img_prev = video_seq(:,:,:,frms);
    
    waitbar(frms./img_frms);
end

close(h);

mreturn = pred_video;

% IM2DSTEI - Calculate the DSTEI images of the input sequence
%
% The DSTEI image is the difference spatial temporal entropy image, please
% see ref1.
%
% Usage:
%     dstei = im2dstei( diff_seq, win )
%
% Argument:
%     diff_seq - input difference sequence
%     win - size of window
%
% Reference:
% [1] Yu-Fei Ma and Hong-Jiang Zhang, ?Detecting motion object by
% spatio-temporal entropy,? in Proceedings of the 2001 IEEE International 
% Conference on Multimedia and Expo, pp. 381-384, 2001

function dstei = im2dstei( diff_seq, win )

dims = size(diff_seq);

% # of frames
if length(dims)>=3
    N = 1:dims(3);
else
    N = 1;
end

dstei = zeros(dims(1),dims(2));
for t = N
    dstei = dstei + entropyfilt(diff_seq(:,:,t), ones(length(win),length(win)) );
end

dstei = dstei./length(N);

end
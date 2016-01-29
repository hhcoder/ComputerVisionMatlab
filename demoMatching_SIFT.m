%% Read the images in
%im1 = imread('imsheva.jpg');
im1 = imread('imbooks.jpg');
im2 = imrotate(imresize(im1, 0.8), 15);

figure, subplot(1,2,1), imshow(im1), title('original image');
subplot(1,2,2), imshow(im2), title('scaled 80% and rotated 15 degree image');

%% Run the actual 

run_sift_test(im1, im2, 1.2);
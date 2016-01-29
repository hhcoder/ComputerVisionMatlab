function test_imblend()

    im1color = imresize( imread('../DataImage/20090817_RITPan/P1010030.jpg'), 0.3 );
    im2color = imresize( imread('../DataImage/20090817_RITPan/P1010032.jpg'), 0.3 );

    im1 = im2double(rgb2gray(im1color));
    im2 = im2double(rgb2gray(im2color));
    
    % Calculate the H matrix and the inliers with SIFT and RANSAC
    % algorithm
    H = img_analyzer.im2homogeneousmatrix(im1, im2);
    
    % Calculate new image and the (x,y) offsets based on the
    % homogeneous matrix
    [dy, dx, im2new] = img_processor.H2imnew(im1, im2, H );
    
    img_analyzer.im2minseam

end
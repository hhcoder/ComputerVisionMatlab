% IM2HOMOGENEOUSMATRIX - Calculate homogeneous matrix between two input
% images by selected matching algorithm
% 
% This function calculates the homogeneous matrix between two images
% containing similar contents. User can specify the methods selecting
% feature points and matching data clouds.  
%
% Usage: [H, inliers] = im2homogeneousmatrix( im1, im2,
% feature_point_method, show_feature_points, robust_method, show_ui_matching_with_H )
% The return H matrix denotes the homogeneous transformation that 
% im2_coordinate = im1_coordinate * H
%
% Arguments: 
%  im1 - first input image (as the base image)
%  im2 - second input image 
%  feature_point_method - 'SIFT' or 'HARRIS'
%  show_feature_points - on/off to show selected feature points with UI
%                        window
%  robust_method - 'RANSAC' only
%  show_ui_matching_with_H - show an interactive UI window being able to
%                            let user select point in im1/im2 and show the
%                            matching position in im2/im1
%
% Returns:



function [H, inliers] = im2homogeneousmatrix( im1, im2, feature_point_method, show_feature_points, robust_method, show_ui_matching_with_H )

% Initialize toolbox
    addpath('./_sift/');

    addpath('./_PFCVM/Robust/');
    addpath('./_PFCVM/Projective/');
    addpath('./_PFCVM/Match');
    addpath('./_PFCVM/GreyTrans');
    
    addpath('./_MVGMFUN/vgg_ui');

    v = version; Octave=v(1)<'5';  % Crude Octave test
    
    if nargin < 3
        feature_point_method = 'SIFT';
    end
    
    if nargin < 4
        show_feature_points = 0;
    end
    
    if nargin < 5
        robust_method = 'RANSAC';
    end
    
    if nargin < 6
        show_ui_matching_with_H = 0;
    end
    
    switch lower(feature_point_method)

        % Find the matching points using Harris corner detection
        case 'harris'
            thresh = 500;   % Harris corner threshold
            dmax = 50;
            w = 11;         % Window size for correlation matching

            fprintf('\nRun Harris Corner algorithm....\n');
            
            [cim1, r1, c1] = harris(im1, 1, thresh, 3);
            [cim2, r2, c2] = harris(im2, 1, thresh, 3);
            
            % do the correlation to find matching points
            fprintf('\nRun Matching by correlation...\n');
            
            [m1,m2] = matchbycorrelation(im1, [r1';c1'], im2, [r2';c2'], w, dmax);
            
            % Display putative matches
            show(im1,3), set(3,'name','Putative matches'), 
            if Octave, figure(1); title('Putative matches'), axis('equal'), end    
            for n = 1:length(m1);
                line([m1(2,n) m2(2,n)], [m1(1,n) m2(1,n)])
            end
       
        % Find the matching points using SIFT algorithm
        case 'sift'
            fprintf('\nRun SIFT algorithm....\n');
            threshold = 0.025;
            [frames1,descriptors1,gss1,dogss1] = ...
                sift(im1, ...
                    'verbosity', 1, ...
                    'threshold', threshold );
            r1 = frames1(2,:)';
            c1 = frames1(1,:)';

            [frames2,descriptors2,gss2,dogss2] = ...
                sift(im2, ...
                    'verbosity', 1, ...
                    'threshold', threshold );
            r2 = frames2(2,:)';
            c2 = frames2(1,:)';
            matches = siftmatch( descriptors1, descriptors2 ) ;
            m1 = [r1(matches(1,:)), c1(matches(1,:))]';
            m2 = [r2(matches(2,:)), c2(matches(2,:))]';
    end
    
    fprintf('\nFinish feature point matching\n');

    if show_feature_points
        show(im2,2), hold on, plot(c2,r2,'r+');
        show(im1,1), hold on, plot(c1,r1,'r+');
        drawnow
    end

    % Assemble homogeneous feature coordinates for fitting of the
    % homography, note that [x,y] corresponds to [col, row]
    x1 = [m1(2,:); m1(1,:); ones(1,length(m1))];
    x2 = [m2(2,:); m2(1,:); ones(1,length(m1))];    

    % RANSAC algorithm
    switch lower(robust_method)
        case 'ransac'
            fprintf('\n Running RANSAC matching... \n');
            if length(x1) < 4
                H = zeros(3,3);
                inliers = 0;
            else
                t = .001;  % Distance threshold for deciding outliers
                [H, inliers] = ransacfithomography(x1, x2, t);
            end
            fprintf('\n End RANSAC \n');
    end
    
    if show_ui_matching_with_H
        vgg_gui_H(im1, im2, H);
    end

end

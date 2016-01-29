% VECTOR - simulator class to the standard C++ template std::vector 
%
% This class simulates the C++ template std::vector. However, during
% development, I found that it is meaningless to write this on Matlab
% because their methodologies are so different. Matlab is more suitable for
% sequential, rapid-changing and experimental enviromental. Also, Matlab 
% has already is a non-type strict language. Toolbox like STL should not 
% be implemented here. 
%
% Usage:
%    myv = stl.vector
%
% Example:
%    myv = stl.vector;
%    im1 = imread('imagfagirl.jpg');
%    im2 = imread('imchipmonk.jpg');
%    myv.push_back(im1);
%    myv.push_back(im2);
%    imshow(myv.at(2));
%
%    This is useless...it can easily be written in Matlab without any toolbox
%
%    myv{1} = imread('imagfagirl.jpg');
%    myv{2} = imread('imchipmonk.jpg');
%    imshow(myv{2});

classdef vector < handle
    properties
        data;
    end

    methods
        function obj = vector( init_list )
            if nargin < 1
                obj.data = [];
                return
            end
            
            if size( init_list, 2 ) > 1
                error('vector requires 1-D list to initialize');
            end
                
            size_list = size(init_list);
            obj.data = cell(size_list);
            
            for i=1:size_list
                obj.data{i} = init_list{i};
            end
        end

        function mreturn = size( obj )
            mreturn = size( obj.data );
        end
        
        function push_back( obj, elem )
            size_list = obj.size( );
            obj.data{ size_list+1 } = elem;
        end
        
        function mreturn = at( obj, idx )
            mreturn = obj.data{idx};
        end
    end
end
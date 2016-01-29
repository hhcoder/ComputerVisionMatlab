% FILE_LOG - Class for writing information to file
%
% This object is designed to be created in the very first your program is
% called, and by interatively call to this file_log, you can attach
% information to it. At the end of your program, you should dump out all
% informaiton.
%
% Example:
%
%   mylog = rec.file_log;
%   mylog.set_align('align1');
%   mylog.push('Begin of the program loop 1');
%   mylog.set_align('align2');
%   for i=1:N
%     mylog.push(sprintf('Running program loop 1 #: %d', i);
%     run_filtering(img{i});
%   end
%   mylog.write_string('filter_result.txt');
%

classdef file_log < handle
    properties
        str;
        str_buffer;

        n_lines;
        tab_space;
    end

    methods
        function obj = file_log( )
            obj.n_lines = 0;
            obj.tab_space = ' ';
        end
        
        % Fxns for output string
        function ret = get_string( obj )
            ret = obj.str_buffer;
        end

        function clear( obj )
            obj.str_buffer = cell(0,0);
            obj.n_lines = 0;
        end
        
        function write_string( obj, fname )
            fid = fopen( fname, 'wt' );
            strs = obj.str_buffer;
            for i=1:size(strs,2)
                fprintf( fid, '\n %s \n', strs{i} );
            end
        end
        
        function ret = set_align(obj, align )
            tab_space = '    ';
            switch align
                case {'noalign'}
                    s = '';
                case {'align1', 'level1'}
                    s = tab_space;
                case {'align2', 'level2'}
                    s = [tab_space, tab_space ];
                case {'align3', 'level3'}
                    s = [tab_space, tab_space, tab_space ];
                case {'align4', 'level4'}
                    s = [tab_space, tab_space, tab_space, tab_space ];
            end
            obj.tab_space = s;
            ret = obj.tab_space;
        end
        
        function push_seperator( obj, sep  )
            switch sep
                case 'Double'
                    istr = '======================================================';
                case 'Single'
                    istr = '------------------------------------------------------';
                case 'Star'
                    istr = '******************************************************';
                case 'Plus'
                    istr = '++++++++++++++++++++++++++++++++++++++++++++++++++++++';
                case 'Sharp'
                    istr = '######################################################';
            end

            obj.push( istr, 'noalign' );
        end
        
        function ret = push( obj, str, align )
            if nargin > 2
                obj.set_align(align);
            end
            
            if ischar(str)
                obj.n_lines = obj.n_lines+1;
                obj.str_buffer{obj.n_lines} = [obj.tab_space, str];
            else
                in_lines = size(str,2);
                for i=1:in_lines
                    obj.n_lines = obj.n_lines+1;
                    obj.str_buffer{obj.n_lines} = [obj.tab_space, str{i}];
                end
            end
            ret = obj.str_buffer;
        end
    end
end

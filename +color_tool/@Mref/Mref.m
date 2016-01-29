% Class for restoring reflectances, might be deprecated....

classdef Mref < handle
    properties
        name;
        data;

        lambda_min;
        lambda_max;
        lambda_int;
        
        cmf;
        white;
    end
    
    methods
        function obj = Mref(iname,isrc,ilambda_min,ilambda_int,ilambda_max, icmf, iwhite)
            obj.name = iname;
            obj.data = isrc;
            obj.lambda_min = ilambda_min;
            obj.lambda_int = ilambda_int;
            obj.lambda_max = ilambda_max;
            
            if nargin < 6
                lambdas = obj.lambda_min:obj.lambda_int:obj.lambda_max;
                tmp = color_tool.cie_struct(lambdas);
                obj.cmf = tmp.cmf2deg;
            else
                obj.cmf = icmf;
            end
            
            if nargin < 7
                obj.white = ones(size(obj.data));
            else
                obj.white = iwhite;
            end
        end
    end
end
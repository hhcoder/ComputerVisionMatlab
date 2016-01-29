classdef Minkjet < handle
    properties
        %Actually, we don't need the ink's dc cause it should be 1.0 at 
        % that specific ink channel and 0.0 at others
        ink_dc; 
        ink_dc_count;
        ink_primaries;

        neugebauer_dc;
        neugebauer_prim;
        neugebauer_prim_n;
        
        cellular_dc;
        cellular_area; % for fast calculation
        cellular_prim;
        cellular_prim_n;

        paper_spec;

        parameters;
        name;
        
        model;
        
        lambda;
        
        tbl_dc2area;
        
        tbl_cellular;

        tbl_cellular_area_upper;
        tbl_cellular_area_lower;
        tbl_cellular_midarea;
    end
    
    methods
        function obj = Minkjet( iname )
            obj.name = iname;
            obj.model = struct('theo_eff_area', 0, 'n', 12, ...
                'dc_max', 100, 'dc_min', 0,...
                'dcc_max', 75, 'dcc_mid1', 50, 'dcc_min', 0 );
            obj.lambda = struct('max', 700, 'min', 400, 'int', 10);
            obj.tbl_dc2area = struct('x', 0:1/255:1, 'y', 0:1/255:1 );
            obj.tbl_cellular = struct('a_upper', 0, 'a_mid', 0, 'a_lower', 0);
        end
        
        init_ink_prim( obj, in_dc, in_prim, dc_count );
        
        function init_neugebauer_prim( obj, in_dc, in_prim )
            obj.neugebauer_prim = in_prim;
            obj.neugebauer_dc = in_dc;
            obj.neugebauer_prim_n = obj.neugebauer_prim.^(1/obj.model.n);
        end
        
        init_area2dc_table( obj );
        
        init_cellular_area2areac_table( obj );
        
        function init_cellular_prim( obj, cellular_dc, cellular_ref )
            obj.cellular_prim = cellular_ref;
            obj.cellular_dc = cellular_dc;
            obj.cellular_area = obj.dc2area( cellular_dc );
            obj.cellular_prim_n = (obj.cellular_prim).^(1/obj.model.n);
        end
        
        function init_paper( obj, in_paper )
            obj.paper_spec = in_paper;
        end

        function init_parameters( obj, ...
                in_n, ...
                dc_min,...
                dc_max,...
                dcc_min,...
                dcc_mid1,...
                dcc_max,...
                ilambdamin,...
                ilambdaint,...
                ilambdamax)

            obj.model.theo_eff_area = 0;
            obj.model.n = in_n;
            
            obj.model.dc_min = dc_min;
            obj.model.dc_max = dc_max;
            
            obj.model.dcc_min = dcc_min;
            obj.model.dcc_mid1 = dcc_mid1;
            obj.model.dcc_max = dcc_max;

            obj.lambda.max = ilambdamax;
            obj.lambda.int = ilambdaint;
            obj.lambda.min = ilambdamin;
        end
    end
    
    % Methods for setting properties
    methods
        function n = set_nelson( obj, in_n )
            obj.model.n = in_n;
            obj.neugebauer_prim_n = obj.neugebauer_prim.^(1/obj.model.n);
            n = obj.model.n;
        end
    end
    
    % Methods for getting properties (const)
    methods
        function ret = ch_count( obj )
            ret = size(obj.ink_dc,2);
        end
        
        function ret = spec_count( obj )
            ret = size(obj.neugebauer_prim,2);
        end

        function ret = get_paper_spec( obj )
            ret = obj.paper_spec;
        end
        
        function ret = get_neugebauer_prim_n( obj )
            ret = obj.neugebauer_prim_n;
        end
        
        function ret = get_ink_ref( obj )
            ret = obj.ink_primaries;
        end
        
        function ret = get_ink_dcs( obj )
            ret = obj.ink_dc;
        end
        
        function ret = get_lambdas( obj )
            ret = obj.lambda.min:obj.lambda.int:obj.lambda.max;
        end
        
        function ret = get_cie( obj )
            ret = color_tool.cie_struct( obj.get_lambdas() );
        end
        
        function ret = get_d65wp( obj )
            cie = obj.get_cie();
            ret = color_tool.ref2xyz( ...
                obj.get_paper_spec(), cie.cmf2deg, cie.illD65 );
        end
    end
    
    methods
        mreturn = dc2spectrum( obj, in_dcs );
        mreturn = dc2spectrum_cellular( obj, in_dcs );
        mreturn = dc2area( obj, in_dcs );
        mreturn = area2spectrum( obj, in_dcs );

        
        mreturn = spectrum2dc( obj, in_spectrum, ctrl );
        mreturn = spectrum2dc_cellular( obj, in_spectrum, ctrl );
        mreturn = spectrum2area( obj, in_spectrum, area_guess );
        mreturn = spectrum2area_cellular( obj, in_spectrum, ctrl );
        mreturn = spectrum2dc_guess( obj, in_spectrum );
        mreturn = area2dc( obj, in_areas );
        
    end

end
        

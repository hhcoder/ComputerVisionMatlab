classdef Mdsc < handle
    properties
        name;
        model;

        m2xyz;
        m2ref;
    end
    
    methods
        function obj = Mdsc( iname )
            obj.name = iname;
            
            obj.m2xyz = ...
                [ 0.4024 0.4620 0.0871; ...
                  0.1904 0.7646 0.0450; ...
                 -0.0249 0.1264 0.9873];
        end

    end
        
    methods
        function mreturn = reshape_to( obj, img )
            obj.reshapeh = size(img,1);
            obj.reshapew = size(img,2);
            mreturn = reshape( img, obj.reshapeh*obj.reshapew, 3 );
        end

        function mreturn = reshape_from( obj, img )
            mreturn = reshape( img, [obj.reshapeh obj.reshapew 3] );
        end
    end
    
    methods
        function mreturn = resp2ref( obj, iresp )
            if size(iresp,3)>1
                r = obj.reshape_to( iresp );
            else
                r = iresp;
            end
            mreturn = obj.m2ref * r;
        end
        
        function mreturn = resp2xyz( obj, iresp )
            if size(iresp,3)>1
                r = obj.reshape_to(iresp);
            else
                r = iresp;
            end
            mreturn = obj.reshape_from( obj.m2xyz * r );
        end
        
        mreturn = resp2lab( obj, iresp, imethod );

        mreturn = ref2resp( obj, in_ref, imethod ); % Useless
    end


end
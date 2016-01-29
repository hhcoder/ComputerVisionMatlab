function mreturn = area2dc( obj, in_areas )
    mreturn = zeros( size(in_areas) );
    
    len = size(in_areas,1);

    for i=1:len
        mreturn(i,:) = area2dc_tbl( ...
            in_areas(i,:),...
            obj.tbl_dc2area.x,...
            obj.tbl_dc2area.y,...
            'linear' );

    end
end

function mreturn = area2dc_tbl( ...
    in_areas,...
    intrp_idx, ...
    intrp_ouy, ...
    method )

    dceff = zeros(size(in_areas));
    for ch_idx = 1:length(in_areas)
        area = in_areas(ch_idx);
        % Notice the interpolating direction is inversed
        dceff(ch_idx) = ...
            interp1( intrp_ouy(:,ch_idx), intrp_idx, area, method, 'extrap');
    end
    
    % Truncate to 0~1
    mreturn = min(100,max(0,dceff));
end

function init_cellular_area2areac_table( obj )
    obj.tbl_cellular.a_upper = obj.dc2area( obj.model.dcc_max.*ones(1, obj.ch_count()) );
    obj.tbl_cellular.a_mid = obj.dc2area( obj.model.dcc_mid1.*ones(1, obj.ch_count()) );
    obj.tbl_cellular.a_lower = obj.dc2area( obj.model.dcc_min.*ones(1, obj.ch_count()) );
end


function init_cellular_area2areac_table_backup( obj )
    len = size(obj.tbl_dc2area.x,1);
    ch_count = obj.ch_count();
    
    tbl_u.x = zeros(len./2, 1);
    tbl_u.y = zeros(len./2, ch_count);
    
    tbl_l.x = zeros(len./2, 1);
    tbl_l.y = zeros(len./2, ch_count);
    
    % Fast lookup action
    mid_area = zeros(ch_count,1);
    
    mid = obj.model.dcc_mid1;
    mid_idx = find( obj.tbl_dc2area.x<=mid, 1, 'last');

    tbl_x = obj.tbl_dc2area.x;
    tbl_y = obj.tbl_dc2area.y;
    
    for ch_idx=1:ch_count

        for x = 1:len;
            a_t = tbl_y(x,ch_idx);     %theoretical area
            mid_area(ch_idx) = tbl_y(mid_idx,ch_idx);
            if a_t <= mid_area(ch_idx)
                a_l = tbl_y(1,ch_idx);
                a_u = tbl_y(mid_idx,ch_idx);
                tbl_l.x(x) = tbl_x(x);
                tbl_u.y(x) = (a_t-a_l)./(a_u-a_l);
            else
                a_l = tbl_y(mid_idx,ch_idx);
                a_u = tbl_y(end,ch_idx);
                tbl_u.x(x-mid_idx) = tbl_x(x);
                tbl_u.y(x-mid_idx) = (a_t-a_l)./(a_u-a_l);
            end
            
            
        end
    end
    
    obj.tbl_cellular_midarea = mid_area;
    obj.tbl_cellular_area_lower = tbl_l;
    obj.tbl_cellular_area_upper = tbl_u;
 
end
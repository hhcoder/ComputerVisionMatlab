function init_area2dc_table( obj )
    in_dc = obj.ink_dc;
    dc_counts = obj.ink_dc_count;

    ch_counts = size(obj.ink_dc,2);
    intrp_tbl= zeros( dc_counts, ch_counts );
    
    h = waitbar(0, 'Building Naugbauer DC to AREA interp table');
    
    len = ch_counts*dc_counts;

    idx_dcs = 1:dc_counts;
    for i=1:ch_counts
        for j=1:dc_counts
            Rink = obj.ink_primaries(i*dc_counts,:);
            Rmeasure = obj.ink_primaries(idx_dcs(j),:);
            Rpaper = obj.get_paper_spec();
            
            % Equations
            intrp_tbl(j,i) = ...
                singledc2area( Rink, Rmeasure, Rpaper, obj.model.n );
        end
        
        %   1~ 256 -> C
        % 257~ 512 -> M
        % 513~ 768 -> Y
        % 769~1024 -> K
        idx_dcs= idx_dcs+dc_counts;
        waitbar((i*dc_counts+j)./len, h )
    end
    
    close(h);
    
    obj.tbl_dc2area.x = in_dc(1:dc_counts,1);
    obj.tbl_dc2area.y = intrp_tbl;
end

function mreturn = singledc2area( Rink, Rmeasure, Rpaper, n )
    Rm = (Rmeasure).^(1/n) - (Rpaper).^(1/n);
    Rt = (Rink).^(1/n) - (Rpaper).^(1/n);
    mreturn = Rm * Rt' * inv(Rt * Rt');
end
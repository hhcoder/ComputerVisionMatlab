function mreturn = dc2area( obj, in_dcs )
    use_table_interp = 1;
       
    mreturn = zeros( size(in_dcs) );

    len = size(in_dcs,1);
    
    % Only wake up waitbar when there are more than 10 input DCs
    if len > 10
        h = waitbar(0,'DC to AREA');
    end

    for i=1:len
        if use_table_interp
            mreturn(i,:) = dc2area_tbl( ...
                in_dcs(i,:),...
                obj.tbl_dc2area.x,...
                obj.tbl_dc2area.y,...
                'linear' );
        else
            mreturn(i,:) = dc2area_single( ...
                in_dcs(i,:), ...
                obj.model.dc_max,...
                obj.get_paper_spec(),...
                obj.get_ink_ref(),...
                obj.get_ink_dcs(),...
                obj.model.n );
        end
        if len > 10
            waitbar(i/len,h);
        end
    end
    
    if len > 10
        close(h);
    end
end

function mreturn = dc2area_tbl( ...
    in_dcs,...
    intrp_idx, ...
    intrp_ouy, ...
    method )

    aeff = zeros(size(in_dcs));
    for ch_idx = 1:length(in_dcs)
        dc = in_dcs(ch_idx);
        aeff(ch_idx) = ...
            interp1( intrp_idx, intrp_ouy(:,ch_idx), dc, method );
    end
    
    % Truncate to 0~1
    mreturn = min(1,max(0,aeff));
end

function mreturn = dc2area_single(...
        in_dcs,...
        dc_max,...
        paper_ref,...
        ink_ref,...
        ink_dc, ...
        n )
    aeff = zeros(size(in_dcs));
    
    Rpaper = paper_ref;

    for ch_idx=1:length(in_dcs)
        % The reflectance of that ink
        Rink = find_Rmeasure(dc_max, ch_idx, ink_ref, ink_dc );
        % The reflectance of that DC value
        Rmeasure = find_Rmeasure( in_dcs(ch_idx), ch_idx, ink_ref, ink_dc);
        
        % Equations
        Rm = (Rmeasure).^(1/n) - (Rpaper).^(1/n);
        Rt = (Rink).^(1/n) - (Rpaper).^(1/n);
        
        % output aeff
        aeff(ch_idx) = Rm * Rt' * inv(Rt * Rt');
    end
    
    % Truncate to 0~1
    mreturn = min(1,max(0,aeff));
    
end

function ret = find_Rmeasure( in_dc, ch_idx, ink_ref, ink_dc )
    ret = ink_ref( find(ink_dc(:,ch_idx) >= in_dc, 1, 'first'), : );
end

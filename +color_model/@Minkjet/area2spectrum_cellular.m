function mreturn = area2spectrum_cellular( obj, in_areas )
    len = size(in_areas,1);

    % The output should be spectrum for each input DC
    mreturn = zeros( len, obj.spec_count() );
    
    I = (obj.neugebauer_dc==obj.model.dc_max);
    
    a_u = obj.tbl_cellular.a_upper;
    a_l = obj.tbl_cellular.a_lower;
    a_m = obj.tbl_cellular.a_mid;


    if len > 10
        h = waitbar(0,'AREAs to SPECTRUM');
    end
    
    c_area = obj.cellular_area;
    expander = ones(size(c_area,1),1);
    ch_count = obj.ch_count();
    
    for i=1:len

        a = in_areas(i,:);
        u = (a>a_m).*a_u + (a<=a_m).*a_m;
        l = (a>a_m).*a_m + (a<=a_m).*a_l;

        ac = (a-l)./(u-l);

        tmp = ( c_area==(expander*u) ) + ( c_area==(expander*l) );
        idx = find( sum(tmp')==ch_count );

        mreturn(i,:) = area2spectrum_cellular_single( ...
            ac,...
            I,...
            obj.cellular_prim_n(idx,:),... 
            obj.model.n );

        if len > 10
            waitbar(i/len,h);
        end
    end

    if len > 10
        close(h);
    end
end

function ret = area2spectrum_cellular_single( ...
    area,...
    I, ...
    neugebauer_prim_n,...
    n )
    
    %% 1. Build the indicator function:
    % Iij = 1 if Neugebauer ink j is in ink primary i
    % Iij = 0 if Neugebauer ink j is not in ink primary i
    % which means, only [1 0 0 0 0 0 0], [0 1 0 0 0 0 0 0], [0 0 1 0 0 0 0 0], ...
    % can be set to 1
    
    % a. Set all values in matrix to 0 or 1
    
    % b. find the index where the row contains more than one 1s
    %    they are not ink primaries
    % Show the output matrix; dot number should be the same as ink
    % number
    % The result should looks like 
    % 0 0 0 0 0 0 0
    % 1 0 0 0 0 0 0
    % 0 1 0 0 0 0 0
    % 0 1 1 0 0 0 0
    % 0 0 0 1 0 0 0
    % ...
    % 0 0 0 0 0 0 1
    % ...
    % 1 1 1 1 1 1 1
    if 0
        spy(I); 
    end
    
    %% 2. Build the probability for each Neugebauer ink
    % in_dc: the digital counts of single color, 1x2.^k
    % Pi = prod<j=1:k>(aj.^Iij*(1-aj).^(1-Iij))
    
%     area2 = ones( size(I,1), 1) * area;
%     area2upper = ones( size(I,1),1 ) * area_upper;
%     area2lower = ones( size(I,1),1 ) * area_lower;
%     
%     area_range = (area2upper-area2lower);
%     prods = ((area2-area2lower)./area_range).^I ...
%             .* ((area2upper-area2)./area_range).^(1-I);

    area2 = ones( size(I,1), 1) * area;
    prods = area2.^I .* (1-area2).^(1-I);

    P = prod(prods');
    
%     P = zeros(2.^k, 1 );
%     for i=1:2.^k
%         P(i) = prod( area.^I(i,:) .* (1-area).^(1-I(i,:))  );
%     end
    
    %% 3. Output the predicted reflectance 
    % R = ( sum<i=1:2.^k>(P .* R^(1/n)) ).^n
    R = ( P * neugebauer_prim_n ).^n;
    
    ret = R;
end

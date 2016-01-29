function mreturn = spectrum2area_guess( obj, in_spectrum )

    len = size(in_spectrum,1);
    mreturn = zeros( len, obj.ch_count() );

    neugebauer_dc = obj.neugebauer_dc;
    neugbauer_prim = obj.neugebauer_prim;
    dc_max = obj.model.dc_max;
    I = (neugebauer_dc==dc_max);        

    if len > 10
        h = waitbar(0,'Running inverse model with fast guess (Pinv)');
    end

    for i=1:len
        mreturn(i,:) = spectrum2area_guess_single( ...
            I, ...
            neugbauer_prim, ...
            in_spectrum(i,:), ...
            obj.model.n );

        if len > 10
            waitbar(i/len,h);
        end
    end
    
    if len > 10
        close(h);
    end

end

function mreturn = spectrum2area_guess_single( I, neug, R, n )
    % This is the key part, we need to add some constrains here
    % The P should be: 
    % (1) sum to 1
    % (2) all elems between 0~1
    % Pprime = R.^(1/1) * pinv( neug.^(1/6) );
    C = ( neug.^(1/3) )';
    d = ( R.^(1/3) )';
    A = C;
    b = ones(size(neug,2),1);
    Aeq = ones(1, 128);
    beq = 1;
    lb = zeros(128,1);
    ub = ones(128,1);

    lsqopt = optimset('LargeScale', 'off', 'Display', 'off');

    Pprime = lsqlin(C, d, A, b, Aeq, beq, lb, ub, [], lsqopt);
    
    % The area_guess is much simpler,
    % We just read those contains pure CMYKRGB position,
    % say, position that is 1000000 0100000 0010000 ...
    % i.e., [2 3 5 9 17 33 65]
    % area_guess = Pprime( (find(sum(I')==1)) );

    len = size(I,2);
    area_guess = zeros(1,len);
    for i=1:len
        area_guess(i) = sum( Pprime(find(I(:,i))) );
    end
    
    mreturn = max(0, min(1,real(area_guess)));
    
end
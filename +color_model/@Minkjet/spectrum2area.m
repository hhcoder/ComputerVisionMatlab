function mreturn = spectrum2area( obj, in_spectrum, ctrl )
    opt_option = optimset(...
        'DiffMaxChange', 0.5,...
        'DiffMinChange', 0.01,...
        'DerivativeCheck', 'off',...
        'Algorithm', 'active-set',...
        'MaxIter', 15,...
        'Display','off',...
        'TolX', 1e-015,...
        'TolFun', 1e-015,...
        'MaxFunEvals', 1e005);    

    len = size(in_spectrum,1);
    
    op_key = {'rmsv','deltaE00','rmsv_log'};
    mreturn = zeros( len, obj.ch_count() );
    
    h = waitbar(0,'Running inverse model with nonlinear Opt.');
    
    lb = zeros(obj.ch_count(), 1);
    ub = ones(obj.ch_count(),1);

    for i=1:len
        
        if size(ctrl,1) > 1
            mreturn(i,:) = ctrl(i,:);
        else
            mreturn(i,:) = ctrl(:);
        end

         for j = 1:2
            for k=1:size(op_key,2)

                pred_func = @(guess_dc)forward_model( ...
                    guess_dc, ...
                    in_spectrum(i,:), ...
                    obj, ...
                    op_key{k} );

                mreturn(i,:) = fmincon( ...
                    pred_func, ...          % :fun
                    mreturn(i,:), ...       % :x0 (input, initial guess)
                    [], [], ...             % : A, b
                    [], [], ...             % :Aeq, beq
                    lb,...                  % :lb
                    ub,...                  % :ub
                    [], ...                 % :nonlcon
                    opt_option...           % :options
                    );
            end % end of k
         end  % end of j

        waitbar(i/len,h);
    end % end of i
    
    close(h);

end

function ret = forward_model( guess, input_spectrum, inkjet_obj, op_key )

    pred_spectrum = inkjet_obj.area2spectrum( guess );
    
    switch op_key
        case 'rmsv_log'
            ret = mean( color_tool.rmse(pred_spectrum.^.7, input_spectrum.^.7) );
        case 'rmsv'
            ret = mean( color_tool.rmse(pred_spectrum, input_spectrum ) );
        case 'deltaE00'
            cie = inkjet_obj.get_cie();
            paper_spec = inkjet_obj.get_paper_spec;
            wp = color_tool.ref2xyz(paper_spec, cie.cmf2deg, cie.illD65);
            ret = color_tool.ref2dE00( ...
                pred_spectrum, input_spectrum, ...
                cie.cmf2deg, cie.cmf2deg,...
                cie.illD65, cie.illD65,...
                wp);
    end

show_display = 0;
if show_display
    switch op_key
        case 'rmsv_log'
            color = [0 1 0];
        case 'rmsv'
            color = [1 0 0];
        case 'deltaE00'
            color = [0 0 1];
    end
    plot(pred_spectrum, '--', 'Color', color );
    hold on
    plot(input_spectrum, '-', 'LineWidth', 2, 'Color', [0 0 0] );
    hold off
    axis( [1 31 0 1]);
    drawnow
end

end

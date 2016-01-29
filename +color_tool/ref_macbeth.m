function ret = ref_macbeth( lambda )
    load('./+color_tool/the_macbetch_color_checker');
    
    c = the_macbeth_color_checker;
    num_samples = size(c.data,1);
    ret = zeros(num_samples, length(lambda));
    for i=1:num_samples
        ret(i,:) = interp1( c.lambda, c.data(i,:), lambda );
    end
end
function xyz = ref2xyz( ref, cmf, illum )
    ks = 100 / sum( illum.* cmf(:,2) );
    xyz = ks * cmf' * diag(illum) * ref';
end
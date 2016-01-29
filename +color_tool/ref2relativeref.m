function mreturn = ref2relativeref(ref_abs,ref_white)
    len = size(ref_abs,1);
    mreturn = ref_abs ./ ( ones(len,1) * ref_white );
end
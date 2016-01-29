function [rms, dE00] = ref_diff( ref1, ref2, cmf1, cmf2, illum1, illum2, wp )

    rms = color_tool.rmse( ref1 * diag(illum1), ref2 * diag(illum2) );

    dE00 = color_tool.ref2dE00( ref1, ref2, cmf1, cmf2, illum1, illum2, wp );

end
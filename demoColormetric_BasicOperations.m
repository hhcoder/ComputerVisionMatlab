%% Initializing
lambda = 380:10:730;
cie = color_tool.cie_struct( lambda );
illumD65 = cie.illD65 ./ max(max(cie.illD65));
illumA = cie.illA ./ max(max(cie.illA));
cmf = cie.cmf2deg;
perfectref = ones(size(lambda));
perfectillum = 100 * ones(size(lambda))';
wp = color_tool.ref2xyz( perfectref, cmf, perfectillum );

%% Plotting Planck's blackbody radiation curve
temperature = 0:100:10000;
bbref = color_tool.blackbody2ref(temperature,lambda,'relative');

color_tool.plot_ref2chrom( bbref, cmf, perfectillum, 'black');
title('The black body curve on chromatic diagram');

%% Show the color checker image under D65 and illumA
macbethref = color_tool.ref_macbeth(lambda);

% Create D65 color patches
macbethimgD65 = color_tool.ref2srgbpatches( ...
    macbethref, cmf, illumD65, 60, 60, 4, 6, wp );
figure, imshow(macbethimgD65);
title('The color checker under D65');

% Show D65 color gamut
color_tool.plot_srgbimggamut( macbethimgD65, figure );
title('The color gamut of color checker in LAB space under D65 illum');

% Create illuminant A color patches
macbethimgillA = color_tool.ref2srgbpatches( ...
    macbethref, cmf, illumA, 60, 60, 4, 6, wp );
figure, imshow(macbethimgillA);
title('The color checker under illuminant A');

% Show illuminant A color gamut
color_tool.plot_srgbimggamut( macbethimgillA, figure );
title('The color gamut of color checker in LAB space under D65 illum');

% Show the gamut change
macbethLabillA = zeros(size(macbethref,1), 3);
macbethLabD65 = zeros(size(macbethref,1), 3);
for i=1:size(macbethref,1)
    macbethLabillA(i,:) = color_tool.ref2lab( macbethref(i,:), cmf, illumA, wp );
    macbethLabD65(i,:) = color_tool.ref2lab( macbethref(i,:), cmf, illumD65, wp );
end
figure,
color_tool.plot_labgamutchange(macbethLabD65, macbethLabillA, gca);

%% Show the reflectance difference of color checker under different
% illuminants

macbethrefD65 = macbethref * diag(cie.illD65);
macbethrefillA = macbethref * diag(cie.illA);

[rms, dE] = color_tool.ref_summary( ...
    macbethref, 'D65', ...
    macbethref, 'illA', ...
    cmf, cmf, ...
    cie.illD65, cie.illA, wp, 1 );
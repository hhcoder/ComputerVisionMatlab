%% Readin the measurement data M1-M36

i_nm_min = 380;
i_nm_max = 780;
i_nm_int = 4;
o_nm_min = 380;
o_nm_max = 730;
o_nm_int = 10;

cie = color_tool.cie_struct(o_nm_min:o_nm_int:o_nm_max);

read_in_ref_measurement = fliplr( dlmread('../DataImage/20090626_Youngs/all.txt') )';

ref_measurement = color_tool.ref2ref( ...
    read_in_ref_measurement, ...
    i_nm_min, i_nm_int, i_nm_max, o_nm_min, o_nm_int, o_nm_max );

ref_white_all = (ref_measurement(1,:)+ref_measurement(2,:))./2;
ref_white_warm = (ref_measurement(3,:)+ref_measurement(4,:))./2;
ref_white_cool = (ref_measurement(5,:)+ref_measurement(6,:))./2;

ref_macbeth1 = ref_measurement([7:15,17:31],:);
ref_macbeth = ref_macbeth1./ (ones(24,1)*ref_white_all);

wp = color_tool.ref2xyz(ref_white_all./ref_white_all, cie.cmf2deg, ref_white_all'./max(ref_white_all') );

imtest_white = color_tool.ref2srgbpatches(ref_macbeth,cie.cmf2deg,ref_white_all',60,60,4,6,wp);
imtest_cool = color_tool.ref2srgbpatches(ref_macbeth,cie.cmf2deg,ref_white_cool',60,60,4,6,wp);
imtest_warm = color_tool.ref2srgbpatches(ref_macbeth,cie.cmf2deg,ref_white_warm',60,60,4,6,wp);
imtest_A = color_tool.ref2srgbpatches(ref_macbeth,cie.cmf2deg,cie.illA,60,60,4,6,wp);

color_tool.plot_ref2chrom(ref_macbeth,cie.cmf2deg,ref_white_all','color',wp);

figure, 
subplot(2,2,1), imshow(imtest_white), title('All on');
subplot(2,2,2), imshow(imtest_cool), title('Cool');
subplot(2,2,3), imshow(imtest_warm), title('Warm');
subplot(2,2,4), imshow(imtest_A), title('A');

%ref_blackcloth = ((ref_measurement(32,:)+ref_measurement(33,:))./2) ./ ref_white_all;
%color_tool.ref2srgbimg( ref_blackcloth, cie.cmf2deg, ref_white_all');

%ref_skin_handfront = ref_measurement(35,:)./ ref_white_all;
%color_tool.ref2srgbimg( ref_skin_handfront, cie.cmf2deg, ref_white_all');

%ref_skin_handback = ((ref_measurement(34,:)+ref_measurement(36,:))./2) ./ ref_white_all;
%color_tool.ref2srgbimg( ref_skin_handback, cie.cmf2deg, ref_white_all');


%% Readin the measurement from four youngs
i_nm_min = 380;
i_nm_max = 780;
i_nm_int = 4;
o_nm_min = 380;
o_nm_max = 730;
o_nm_int = 10;
cie = color_tool.cie_struct(o_nm_min:o_nm_int:o_nm_max);

read_in_ref_measurement = dlmread('../DataImage/20090626_Youngs/youngs.txt')';

ref_white = color_tool.ref2ref( ...
    read_in_ref_measurement(1,:), ...
    i_nm_min, i_nm_int, i_nm_max, o_nm_min, o_nm_int, o_nm_max );

tbl = { 'J.M. A';
        'J.M. B';
        'J.M. C';
        'M.R. A';
        'M.R. B';
        'M.R. C';
        'M.R. D';
        'K.F. A';
        'K.F. B';
        'K.F. C';
        'K.F. D';
        'P.R. A';
        'P.R. B';
        'P.R. C';
        'P.R. D';
        'K.F. CC';
        'J.M. CC' };
    
skin_ref = color_tool.ref2ref( ...
            read_in_ref_measurement(2:18,:),...
            i_nm_min, i_nm_int, i_nm_max, o_nm_min, o_nm_int, o_nm_max );
figure,
plot(skin_ref');
hold on
plot(ref_white);
hold off
legend([tbl;'white']);
wp = color_tool.ref2xyz(ref_white, cie.cmf2deg,cie.illD65);
skin_img = color_tool.ref2srgbimg( skin_ref, cie.cmf2deg, cie.illD65, wp, 40, 40, 4 );
figure, imshow(skin_img);
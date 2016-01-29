% PLOT_REF2CHROM - plot the reflectances onto chromaticity diagram
%
% This function transforms the reflectances into chromaticity (x,y) values
% and plots them. 
%
% Usage: 
%    plot_ref2chrom( ref, cmf, illum, mopcode, wp, withlabel )
%
% Arguments:
%    ref - the input reflectance
%    cmf - the color matching function, should be obtained from 
%          color.cie_struct
%    illum - the illuminant reflectance
%    mopcode - operation mode for drawing, including:
%              'color' - shows only color
%              'circle' - shows only circle
%              'black' - shows in black
%    wp - white point value, if not specified, this value is calculated
%         as white point with perfect white
%    withlabel - enable/disable the label display
%
function plot_ref2chrom( ref, cmf, illum, mopcode, wp, withlabel )

    if nargin < 4
        mopcode = 'color';
    end
    
    if nargin < 5
        white = ones( size(cmf,1), 1 );
        wp = color_tool.ref2xyz( white', cmf, white );
    end
    
    if nargin < 6
        withlabel = 'no label';
    end
    

    deltas = eye(size(cmf,1));
    xylocus = color_tool.ref2xy(deltas,cmf,illum);
   
    xyzcolor = color_tool.ref2xyz(ref,cmf,illum);
    xyzpos = color_tool.xyz2xy(xyzcolor);

    rgb_color = color_tool.xyz2srgb(xyzcolor', wp);
    
    figure,
    hold on
        plot(xylocus(1,:),xylocus(2,:),'LineWidth', 2, 'Color',[0 0 0]);
        line([xylocus(1,1),xylocus(1,end)],[xylocus(2,1),xylocus(2,end)], 'LineWidth',2, 'Color', [0 0 0]);
        switch lower(mopcode)
            case {'color'}
                for i=1:size(ref,1)
                    plot(xyzpos(1,i),xyzpos(2,i),'o', 'MarkerEdgeColor','w','MarkerSize', 8,'MarkerFaceColor', rgb_color(i,:) );
                end
            case {'circle'}
                plot(xyzpos(1,:),xyzpos(2,:),'o');
            case {'black','black solid'}
                plot(xyzpos(1,:),xyzpos(2,:),'.', 'Color', [0 0 0]);
            otherwise
                plot(xyzpos(1,:),xyzpos(2,:));
        end
    hold off
    axis([0 1 0 1]);
    xlabel('x');
    ylabel('y');
    
    if strcmpi(withlabel,'label')
        hold on
        wpd65 = whitepoint('d65')';
        xyd65 = color_tool.xyz2xy(wpd65);
        plot(xyd65(1,:),xyd65(2,:),'+');
        text(xyd65(1,:),xyd65(2,:),'D65');
        
        wpd50 = whitepoint('d50')';
        xyd50 = color_tool.xyz2xy(wpd50);
        plot(xyd50(1,:),xyd50(2,:),'+');
        text(xyd50(1,:),xyd50(2,:),'D50');
        hold off
    end

end
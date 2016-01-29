% PLOT_LABGAMUTCHANGE - plot the gamut changes of lab triplet values
%
% This function shows the LAB gamut change of the two lab triplet values in 
% in 3D view. 
%
% Usage:
%    plot_labgamutchange( ilab1, ilab2, axes, do_arrow, do_label )
%
% Arguments:
%    ilab1 - input lab values
%    ilab2 - input lab values, should be same size as ilab1
%    axes - figure handler to draw
%    do_arrow - enable/disable the color change arrow drawing
%    do_label - enable/disable the labeling on each color patch

function plot_labgamutchange( ilab1, ilab2, axes, do_arrow, do_label )

    if nargin < 4
        do_arrow = true;
    end

    if nargin < 5
        do_label = false;
    end

    cf = makecform('lab2srgb');
    csrgb1 = applycform( ilab1, cf );
    csrgb2 = applycform( ilab2, cf );
    a1 = ilab1(:,2);
    b1 = ilab1(:,3);
    l1 = ilab1(:,1);
    a2 = ilab2(:,2);
    b2 = ilab2(:,3);
    l2 = ilab2(:,1);

    scatter3(a1, b1, l1, 12,csrgb1,'filled', 'Parent', axes);
    hold on
    scatter3(a2, b2, l2,12,csrgb2,'o', 'Parent', axes);
    if do_arrow
        quiver3( a1, b1, l1, a2-a1, b2-b1, l2-l1, 0, 'Parent', axes );
    end
    axis([-100 100 -100 100 0 100]);

    if do_label
        for i=1:length(a1)
        str = sprintf('%d\n', i);
        text('Position', [a1(i)+0.5, b1(i)+0.5, l1(i)+0.5], 'String', str );
        text('Position', [a2(i)+0.5, b2(i)+0.5, l2(i)+0.5], 'String', str );
        end
    end

    hold off
    
    xlabel('b');
    ylabel('a');
    zlabel('l*');
end

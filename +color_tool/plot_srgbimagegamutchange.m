% PLOT_SRGBIMAGEGAMUTCHANGE - shows the gamut change between two images
%
% This function analysis the gamut change betwen two images (the dimension
% should be identical) and draw them onto the figure handler.
%
% Usage:
%     plot_srgbimagegamutchange( isrgb1, isrgb2, axes )
%
% Arguments:
%     isrgb1 - first image
%     isrgb2 - second image
%     axes - figure handler to draw on
function plot_srgbimagegamutchange( isrgb1, isrgb2, axes )

    [l1, a1, b1, csrgb1] = color_tool.srgb2labgamut( isrgb1 );
    [l2, a2, b2, csrgb2] = color_tool.srgb2labgamut( isrgb2 );
    
    % Shows the color point of im1
    scatter3(a1,b1,l1,12,csrgb1,'filled', 'Parent', axes);
    hold on
    % Shows the color points of im2
    scatter3(a2,b2,l2,12,csrgb2,'o', 'Parent', axes);
    % Shows the arrows
    quiver3( a1, b1, l1, (a2-a1), (b2-b1), (l2-l1), 0, 'Parent', axes );
    axis([-100 100 -100 100 0 100]);
    hold off
    
end
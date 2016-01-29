% RUN_HDR_FLOW - execute HDR image fusion
% 
% This is a high-level function combining multiple images with different
% exposures to one single high-dynamic range image. The HDR combination
% flow can be found in the literatures. 
%
% Usage:
%   run_hdr_flow( fusion_select, tone_select, fnames, fpath )
%
% Arguments:
%   fusion_select - default pixel fusion options, including:
%      'linear' - linearly combine images without ghost removal
%      'mtb'    - Greg Ward's MTB algorithm, see ref1
%      'khan06' - Khan's kernel intensity algirithm, see ref2
%  tone_select - default tone mapping options, all these options are listed 
%                in the ref3, including:
%      'ward94' - the Ward contrast tone mapping algorithm
%      'ferwerda96' - Jim Ferwerda's human cone & rod contrast mapping
%                     function
%      'log' - simple logarithm tone mapping
%      'exp' - simple exponential tone mapping
%      'drago03' - Drago tone mapping algorithm
%      'icam' - Mark Farichild's iCAm local tone mapping algorithm, fxn not
%               completed
%  fnames - input file name in cell array
%  fpath - input file path
%
%  References:
%  [1] Greg Ward. Fast, robust image registration for compositing high
%  dynamic range photographs from hand-held exposures. journal of graphics
%  tools, 8(2):17?30, 2003.
%  [2] Erum Arif Khan, Ahmet Oguz Akyuz, and Erik Reinhard. Ghost
%  removal in high dynamic range im- ages. In IEEE International Conference on 
%  Image Procesing, 2006.
%  [3] Eric Reinhard, Greg Ward, Sumanta Pattanaik, and Paul Debevec (August 2005). 
%  High Dynamic Range Imaging: Acquisition, Display, and Image-Based Lighting. 
%  Westport, Connecticut: Morgan Kaufmann. ISBN 0125852630., 
% 
function run_hdr_flow( fusion_select, tone_select, fnames, fpath )

%% HDR Image fusion section

    % Select the ldr images
    if nargin < 1
        fusion_select = 'linear';
    end
    
    if nargin < 3
        [fnames,fpath] = img_acquire.jpggetfiles( );
    end
    
    hdr_img = run_hdr_fusion(fnames, fpath, fusion_select);
    
%% Camera calibration curve linearization


%% Tone Mapping section
    if nargin < 2
        tone_select = 'drago';
    end
    
    ldr_img = run_hdr_to_ldr(hdr_img, tone_select);

%% Show on the screen
    srgb_img = hdr_fusion.ldr2srgb(ldr_img);
    
    imshow( imrotate(srgb_img,90) );   

end
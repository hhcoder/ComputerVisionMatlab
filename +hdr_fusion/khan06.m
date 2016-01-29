function hdr = khan06( fnames,fpath )

    if nargin < 1
        [fnames,fpath] = img_acquire.jpggetfiles( );
    end

    fnames = sort(fnames);
    len = length(fnames);

    imlabetas = cell(len,1);
    imsrgbs = cell(len,1);
    exps = cell(len,1);
    for i=1:len
        fname = strcat(fpath,fnames{i});
        exps{i} = img_analyzer.im2exptime(fname);
        imsrgbs{i} = im2double(imread( fname ));
        imlabetas{i} = color_appearance.srgb2labeta( imsrgbs{i} );
    end
    
    improbs = khan06_prob( imlabetas );
    
    hdr = zeros(size(imlabetas{1}));
    for i=1:len
        improb = cat(3,improbs{i},improbs{i},improbs{i});
        hdr = hdr + improb .* ( (imsrgbs{i}.^2.2)./exps{i} );
    end
    
end

function improbs = khan06_prob( imlabetas )
    h = waitbar(0,'Applying Khan 06 hdr image fusion...');
    set(h,'Name','Khan06 in Progress');

    ih = size(imlabetas{1},1);
    iw = size(imlabetas{1},2);
    % border size
    n = 3;
    
    % All probability maps
    improbs = cell(length(imlabetas),1);
    
%    w = @(Z)( mean((1-(2.*Z./255-1)).^12) );
    w = @(Z)( mean(Z) );
    Kh = @(H,x)( norm(H).^(-1/2) .* (2*pi()).^(-5/2) .* exp(-1/2.*x'*inv(H)*x) );

    % All boundaries
    R = length(imlabetas);
    S = R;
    % neighborhood size (index form)
    P = -1:1;
    Q = -1:1;
    for r = 1:R
        % Single image probability map
        improb = zeros( ih, iw );

        imx = imlabetas{r};

        % To speed up, change exposure after whole image is calculated
        for s = 1:S
        %cnt = 0;
        prob = zeros( ih, iw );
        imy = imlabetas{s};

        % Calculate each pixel on each location
        for j = n:ih-n-1
            parfor i = n:iw-n-1

            xijr = imx(j,i,1).*ones(3,3);
            ypqs = imy(j-1:j+1,i-1:i+1,1);
            tsum = 0.0101 .* exp( -.5 .* sum(sum( (xijr-ypqs).^2 )) );
            
            wei = length(P)*length(Q);
            prob(j,i) = tsum./wei;
            % waitbar progress
            %cnt = cnt+1; waitbar( cnt ./ ((ih-2*n)*(iw-2*n)*S) );
            end
        end
        
        improb = improb + prob;
        
        end
        
        improbs{r} = improb;
        waitbar(r./R);
    end
    
    close(h);
end
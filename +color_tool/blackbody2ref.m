% BLACKBODY2REF - calculate the reflectance of black-body radiator
%
% This function returns the reflectance of a black-body radiator with
% specified temperature and wavelengths. The Planck's black-body radiation
% is famous function and can be found easily by goooooogle it.
%
% Usage: 
%    mreturn = blackbody2ref( T, lambda, mopcode )
%
% Arguments:
%    T - the absolute temperature
%    lambda - the wavlength range (in nm) want to be calculated, for example,
%             400:10:700
%    mopcode - operation code for output format, including:
%              'relative'
%              'zero one'
%              'absolute'

function mreturn = blackbody2ref( T, lambda, mopcode )

% if length(T)>1
%     error('Temperature has to be a scalar');
% end

if sum(T==0)
    T(find(T==0)) = 100;
end

if nargin < 3
    mopcode = 'relative';
end

h = 6.88e-34;
k = 1.38e-23;
c = 2.99e+8;

lambdanm = lambda .* 10.^(-9);

% Create the T and lambda
[dxL,dxT] = meshgrid(lambdanm,T);

% Planck's black-body radiator equation
% It is said that this equations starts the quantum physics...
% I don't understand this at all... SHAME!!
bb_absolute = ( 2*pi*h*c.^2 ) ./ ...
    ( (dxL.^5).*(exp((h.*c)./(dxL.*k.*dxT)) -1) );

switch mopcode
    case 'relative'
        mreturn = bb_absolute./ ( sum(bb_absolute')'*ones(1,length(lambda)) );
    case 'zero one'
        mreturn = bb_absolute./max(max(bb_absolute));
    case 'absolute'
        mreturn = bb_absolute;

end

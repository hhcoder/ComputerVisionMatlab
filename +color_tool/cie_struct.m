% CIE_STRUCT - create easily accessible CIE related information in a data
%              struct
%
% This function is created by Shizhe Shen, last modified on 10/21/2006
%
% Usage:
%    cie = cie_struct(lambdadata)
%
% Arguments:
%    lambdadata - measured wavelength range; for example, 400:10:700 
%                 generates the color matching function withing this range.
%

function cie = cie_struct(lambdadata)

%Get the default data

data_cmf2Deg = load('./+color_tool/CIE_2Deg_380-780-5nm.txt');
data_cmf10Deg = load('./+color_tool/CIE_10Deg_380-780-5nm.txt');
data_illA = load('./+color_tool/CIE_IllA_380-780-5nm.txt');
data_illD65 = load('./+color_tool/CIE_illD65_380-780-5nm.txt');
data_illF = load('./+color_tool/CIE_IllF_1-12_380-780-5nm.txt');
data_eigD = load('./+color_tool/CIE_eigD_380-780-5nm.txt');


cie.lambda = data_cmf2Deg(:,1)';
cie.cmf2deg = data_cmf2Deg(:,2:end);
cie.cmf10deg = data_cmf10Deg(:,2:end);
cie.illA = data_illA(:,2:end);
cie.illD65 = data_illD65(:,2:end);
cie.illE = zeros(size(cie.illD65))+100;
cie.illF = data_illF(:,2:end);
cie.eigD = data_eigD(:,2:end);

%Judge whether there is new input lambda data
if nargin == 0 
else
    %Interpolate
    cie.cmf2deg = interp1(cie.lambda',cie.cmf2deg,lambdadata');
    
    cie.cmf10deg = interp1(cie.lambda',cie.cmf10deg,lambdadata');
    cie.illA = interp1(cie.lambda',cie.illA,lambdadata');
    cie.illD65 = interp1(cie.lambda',cie.illD65,lambdadata');
    cie.illE = interp1(cie.lambda',cie.illE,lambdadata');
    cie.illF = interp1(cie.lambda',cie.illF,lambdadata');
    cie.eigD = interp1(cie.lambda',cie.eigD,lambdadata');
    
    cie.lambda = lambdadata;
end



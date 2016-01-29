%% By Shizhe Shen  10/10/2006
%% Implement DeltaE*94
%% Input: two 3-by-n matrices of CIELAB values, and varargin: mode switch
%% Output: a 1-by-n of CIE94 color differences
%% Reference: PoCT page 121 & 72
%% Last update: July 10, 2007

function ret = lab2dE94(LabBat,LabStd,varargin);


delta_L = LabBat(1,:) - LabStd(1,:);

c_Standard = (LabStd(2,:).^2 + LabStd(3,:).^2).^0.5;
c_Batch = (LabBat(2,:).^2 + LabBat(3,:).^2).^0.5;

delta_C = c_Batch - c_Standard;
delta_Eab = deltaEab(LabBat,LabStd);
delta_H = (delta_Eab.^2-delta_L.^2-delta_C.^2).^0.5;

%Two ways to calculate the C*
if any(strcmp(varargin,'geometric mean'))
    c_star = (c_Standard.*c_Batch).^0.5;
elseif     any(strcmp(varargin,'double side'))
     c_star = (c_Standard+c_Batch)./2;
else
   
      c_star = c_Standard;
end

S_L = 1;
S_C = 1 + 0.045.*c_star;
S_H = 1 + 0.015.*c_star;
k_L = 1;
k_C = 1;
k_H = 1;

%Calculate the DeltaE94
ret = ((delta_L./(k_L*S_L)).^2 + (delta_C./(k_C*S_C)).^2 + (delta_H./(k_H*S_H)).^2).^0.5;




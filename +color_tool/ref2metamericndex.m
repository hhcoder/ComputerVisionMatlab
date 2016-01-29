function [ mi ] = ref2metamericndex( N_batch, N_std, obs, ref_ill, test_ill )
%METAMERICINDEX is a function that returns the metameric index of two sets
%of nearily identical colors from their spectral reflectances.  
%
%It works by converting reflectances to fundamental colors for the
%observer/reference illumininant.
%
%Then gets the batch metemaric black by
%subtracting the batch fundamental from the batch.
%
%The batch metameric black is then added to the standard fundamental to get
%an approximate metameric batch.
%
%The metamericIndex is then calculated as the color difference between the
%standard reflectance and the fixed batch under a test illuminant.
%
% Written April 2009 by Max Derhak

%Calculate projection matrix to convert spectral reflectance to fundamental
%color for the provided observer under the reference illuminant
A = obs .* (ref_ill*[1 1 1]);
R = A*pinv(A'*A)*A';

%Get fundamental colors for both standard and batch 
Nstar_std = R*N_std;
Nstar_batch = R*N_batch;

%Subtract out fundamental color from batch to get metameric black for batch
B_batch = N_batch - Nstar_batch;

%Add black to standard fundamental to get pseudo batch that is metameric to
%standard
N_fix = Nstar_std + B_batch;

%Setup to calculate color difference of N_std and N_fix under test
%illuminant
Lab_std = ref2Lab(N_std, obs, test_ill);
Lab_fix = ref2Lab(N_fix, obs, test_ill);

%MI is color difference under test illuminant
mi = deltaE00(Lab_fix, Lab_std);

end


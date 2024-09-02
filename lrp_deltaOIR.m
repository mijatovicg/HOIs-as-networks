%% computation of delta of the O-information rate when the block Xj is added to the group X-j 
%% input parameters:
% Am, Su: VAR model parameters (theoretical or estimated with lrp_idVAR)
% q: number of lags used to represent the past states of the processes
% ij -  complete vector of indexes
% j - index of the target to analyze within ij

function out = lrp_deltaOIR(Am, Su, q, iQ, j)

assert(ismember(j,iQ)) % verify target belongs to group
ii = setdiff(iQ,j); % source indexes
N = length(iQ); % order of the OIR to compute

ret = lrp_MIR(Am, Su, q, ii, j); % computation of dO(X-j;Xj)

i_cs = nchoosek(ii ,N-2); % n. of combinations to compute the sum of the deltaO 
dO12 = 0;  
for cnt = 1:N-1
    outtmp = lrp_MIR(Am, Su, q, i_cs(cnt,:), j);
    dO12 = dO12 + outtmp.Ixy;
end

dO12 = dO12+(2-N)*ret.Ixy;
out.dO12 = dO12;





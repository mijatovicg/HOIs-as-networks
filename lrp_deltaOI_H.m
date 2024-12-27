%% computation of delta of the (static) O-information when the block Xj is added to the group X-j 
%% input parameters:
% SigmaX: zero-lag covariance matrix of the analyzed process X (theoretical or estimated from data)
% ix - index of the target 

function out = lrp_deltaOI_H(SigmaX, ix)

out1 =  lrp_OI_H(SigmaX);
OI = out1.OI_H;

SigmaX(ix, :) = []; % Remove the ith row
SigmaX(:, ix) = []; % Remove the ith column

out2 = lrp_OI_H(SigmaX);
OI_red = out2.OI_H;

deltaOI = OI - OI_red;

out.deltaOI = deltaOI;




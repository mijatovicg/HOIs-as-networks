%% computation of the local OIR for all pairs of series in a multivariate proces (MIR between each pair of processes, and conditional MIR given all other processes)
%% input parameters
% q: number of lags used to represent the past states of the processes
% Am, Su: VAR model parameters (theoretical or estimated with lrp_idVAR)
% ix, iy: two  nodes of interest


function out = lrp_localOIR(Am, Su, q, ix, iy)

Q = size(Su,1); % number of of processes

iz = setdiff(1:Q, [ix iy]);
retx_y = lrp_MIR(Am, Su, q, ix, iy);
Ixy = retx_y.Ixy; % MIR btw processes ix and iy

retx_z = lrp_MIR(Am, Su, q, ix, iz); % MIR btw processes ix and iz
retx_yz = lrp_MIR(Am, Su, q, ix ,[iy iz]); % MIR btw processes ix and [iy, iz]
Ixy_z = retx_yz.Ixy - retx_z.Ixy; % cMIR btw processes ix and iy given processes iz

local_OIR = Ixy - Ixy_z;
out.local_OIR = local_OIR;

out.Ixy = Ixy;
out.Ixy_z = Ixy_z;

out.Ix_z = retx_z.Ixy;
out.Ix_yz = retx_yz.Ixy;



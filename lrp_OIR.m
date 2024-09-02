%% computation of O-information rate
%% input parameters
% Am, Su: VAR model parameters (theoretical or estimated with lrp_idVAR)
% q: number of lags used to represent the past states of the processes
% iQ: complete vector of indexes

function out = lrp_OIR(Am, Su, q, iQ)

Q = numel(iQ);
dO = nan*ones(Q,1);
for N = 3:Q % vary target inside the multiplet
    out = lrp_deltaOIR(Am, Su, q, iQ(1:N), iQ(N));
    dO(N-1) = out.dO12;
end

OIR = nan*ones(Q,1); % OIR
OIR(3) = dO(2);
for N = 4:Q % OIR using recursion
    OIR(N) = OIR(N-1)+dO(N-1);
end

out.OIR = OIR(Q);


   




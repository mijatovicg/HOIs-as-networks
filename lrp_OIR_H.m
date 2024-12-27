%% computation of O-information rate based on Entropy Rates formulation (Eq. 4)
%% input parameters
% Am, Su: VAR model parameters (theoretical or estimated with lrp_idVAR)
% q: number of lags used to represent the past states of the processes
% iQ: complete vector of indexes

function out =  lrp_OIR_H(Am, Su, q, iQ)

Q = numel(iQ);
ER_diff = [];
for ii = 1 : Q % vary target inside the multiplet


   [Sj, Sigmaj_i] = lrp_LinReg(Am, Su, q, iQ(ii), iQ(ii));
   Hx_ii = 0.5*log(((2*pi*exp(1))^size(Sj,1))*det(Sigmaj_i)); 


   ii_Q = setdiff(iQ, iQ(ii));
   [Sj, Sigmaj_i] = lrp_LinReg(Am, Su, q, ii_Q, ii_Q);
   Hx_Q_ii = 0.5*log(((2*pi*exp(1))^size(Sj,1))*det(Sigmaj_i)); 
   

   ER_diff = [ER_diff; Hx_ii - Hx_Q_ii];
end

[Sj, Sigmaj_i] = lrp_LinReg(Am, Su, q, iQ, iQ);
Hx = 0.5*log(((2*pi*exp(1))^size(Sj,1))*det(Sigmaj_i)); % ER

OIR_H = (Q-2)*Hx + sum(ER_diff);
out.OIR_H = OIR_H;


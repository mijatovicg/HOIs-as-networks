%% computation of O-information based on Entropies (Rosas et al 2019)
% input parameter - SigmaX: zero-lag covariance matrix of the analyzed process X (theoretical or estimated from data)

function out =  lrp_OI_H(SigmaX)

Q = size(SigmaX,1);
E_diff = [];
for ii = 1 : Q

   Hx_ii = 0.5*log(2*pi*exp(1)*SigmaX(ii,ii)); 

   ii_Q = setdiff(1:Q, ii);
   SigmaX_red=SigmaX(ii_Q, ii_Q);
   Hx_Q_ii = 0.5*log(((2*pi*exp(1))^size(SigmaX_red,1))*det(SigmaX_red)); 

   E_diff = [E_diff; Hx_ii - Hx_Q_ii];
end

Hx = 0.5*log(((2*pi*exp(1))^size(SigmaX,1))*det(SigmaX)); 

OI_H = (Q-2)*Hx + sum(E_diff);
out.OI_H = OI_H;


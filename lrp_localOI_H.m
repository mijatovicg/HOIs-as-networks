%% computation of the zero-lag local OI for all pairs of series in a multivariate proces (MI between each pair of processes, and conditional MI given all other processes)
%% input parameters
% SigmaX: zero-lag covariance matrix of the analyzed process X (theoretical or estimated from data)
% ix, iy: two  nodes of interest

function out = lrp_localOI_H(SigmaX, ix, iy)

Sigma = SigmaX; % all 
Hx_iQ = 0.5*log(((2*pi*exp(1))^size(Sigma,1))*det(Sigma));
%%
Sigma = SigmaX(ix, ix); % just x
Hx_ix = 0.5*log(((2*pi*exp(1))^size(Sigma,1))*det(Sigma));
%%
Sigma = SigmaX(iy, iy); % just y
Hx_iy = 0.5*log(((2*pi*exp(1))^size(Sigma,1))*det(Sigma));
%%
SigmaX1 = SigmaX;
SigmaX1([ix, iy], :) = []; 
SigmaX1(:, [ix, iy]) = []; 
Sigma = SigmaX1; % no x, no y
Hx_no_ixiy = 0.5*log(((2*pi*exp(1))^size(Sigma,1))*det(Sigma));

%%
SigmaX2 = SigmaX;
SigmaX2(ix, :) = [];
SigmaX2(:, ix) = [];
Sigma = SigmaX2; % no x
Hx_no_ix = 0.5*log(((2*pi*exp(1))^size(Sigma,1))*det(Sigma));

%%
SigmaX3 = SigmaX;
SigmaX3(iy, :) = []; 
SigmaX3(:, iy) = []; 
Sigma = SigmaX3; % no y
Hx_no_iy = 0.5*log(((2*pi*exp(1))^size(Sigma,1))*det(Sigma));

%%
Sigma = SigmaX([ix, iy], [ix, iy]); % x and y
Hx_ixiy = 0.5*log(((2*pi*exp(1))^size(Sigma,1))*det(Sigma));

%%
localOI_H = Hx_iQ + Hx_ix + Hx_iy + Hx_no_ixiy - Hx_no_ix - Hx_no_iy - Hx_ixiy;
out.localOI_H = localOI_H;









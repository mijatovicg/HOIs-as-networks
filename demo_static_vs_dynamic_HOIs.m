clear; close all; clc;

%% Input parameters
pmax = 1; % maximum lag
Q = 5; % n. of processes
q = 20;

config='c'; % 'a' or 'b'

row = 2; col = 3;

min_l = -0.1;
max_l = 0.1;
nodeNames = {'1','2','3','4','5'};
x_coor = [0 -1 -1 1 1];
y_coor = [0 1 -1 -1 1];
lo = 'force';

%% simulation design

a11 = 0.2; a22 = -0.7; a33 = 0.7; a44 = 0.2; a55 = 0.7; % self dependencies (only for simu 'b')
a21 = 0.3; a12 = 0;
a31 = 0.3; a13 = 0;
a41 = 0; a14 = 1;
a51 = 0; a15 = 1;
p=1; % order of the VAR process


Ak = zeros(Q, Q, pmax); % blocks of coefficients

scen_array = [1, 2, 3]; % three possible scenarions, see below

for sa = 1 : numel(scen_array)
        if sa == 2 %% time-lagged
        Su = eye(Q);
        % effects originating from 1 (at lag 1)
        Ak(2,1,1) = a21;
        Ak(3,1,1) = a31;
        Ak(4,1,1) = a41;
        Ak(5,1,1) = a51;
        % effects directed to 1 (at lag 1)
        Ak(1,2,1) = a12;
        Ak(1,3,1) = a13;
        Ak(1,4,1) = a14;
        Ak(1,5,1) = a15;
        elseif sa == 3 %% time-lagged plus self dependencies
        Su = eye(Q);
        % effects originating from 1 (at lag 1)
        Ak(2,1,1) = a21;
        Ak(3,1,1) = a31;
        Ak(4,1,1) = a41;
        Ak(5,1,1) = a51;
        % effects directed to 1 (at lag 1)
        Ak(1,2,1) = a12;
        Ak(1,3,1) = a13;
        Ak(1,4,1) = a14;
        Ak(1,5,1) = a15;
        % self dependencies (at lag 1)
        Ak(1,1,1) = a11;
        Ak(2,2,1) = a22;
        Ak(3,3,1) = a33;
        Ak(4,4,1) = a44;
        Ak(5,5,1) = a55;
        elseif sa == 1 % zero-lag only
        Su = [1 0.5 0.3 0.3 0.3; 0.5 1 -0.2 0 0; 0.3 -0.2 1 0 0; 0.3 0 0 1 0.5; 0.3 0 0 0.5 1];
        else
        end

Am = [];
for kk = 1 : pmax
    Am = [Am Ak(:,:,kk)];
end

% stability check
E=eye(Q*p);AA=[Am;E(1:end-Q,:)];lambda=eig(AA);lambdamax=max(abs(lambda));
if lambdamax>=1, error('The simulated VAR process is not stable'); end

%% **************************** STATIC ANALYSIS **************************** 

R = lrp_Yule(Am,Su,q); % Lambda(0),...,Lambda(q) - dim: M*M*(q+1)
SigmaX = R(:,:,1); % lag-zero covariance of all processes


%  OI-gradient
deltaOI = nan*ones(1,Q);
for in = 1 : Q
    out1 = lrp_deltaOI_H(SigmaX, in);
    deltaOI(in) = out1.deltaOI;
end

% local OI
OI_link = nan*ones(Q,Q);
for ix = 1 : Q
    for iy = ix+1 : Q
        out2 = lrp_localOI_H(SigmaX, ix, iy);
        OI_link(ix, iy) =  out2.localOI_H;
    end
end

% OI
out3 =  lrp_OI_H(SigmaX);
OI = out3.OI_H;

 %% ***************************** DYNAMIC ANALYSIS **************************

%  OIR-gradient
deltaOIR = nan*ones(1,Q);
for in = 1 : Q
    sources = (1 : Q); sources(in)=[];
    target = in;
    multiplet = [sources target];
    out2 = lrp_deltaOIR(Am, Su, q, multiplet, target);
    deltaOIR(in)=out2.dO12;
end

% local OIR
OIR_link = nan*ones(Q,Q);
for ix = 1 : Q
    for iy = ix+1 : Q
        out = lrp_localOIR(Am, Su, q, ix, iy);
        lOIR = out.local_OIR; % original
        OIR_link(ix, iy) = lOIR;
    end
end

% OIR based on iterative procedure (Eqs. 5 and 6)
iQ = 1:Q;
out = lrp_OIR(Am, Su, q, iQ);
OIR = out.OIR;

% OIR based on ER (Eq. 4)
% iQ = 1:Q;
% out =  lrp_OIR_H(Am, Su, q, iQ);
% OIR_H = out.OIR_H;

%% display results
disp('STATIC ANALYSIS');
disp('OI gradient (LRP):');
disp(deltaOI);
disp('local OI (LRP):');
disp(OI_link);
disp('OI (LRP):');
disp(OI);

disp('DYNAMIC ANALYSIS');
disp('OIR gradient (LRP):');
disp(deltaOIR);
disp('local OIR (LRP):');
disp(OIR_link);
disp('OIR (LRP):');
disp(OIR);

fig_name = 3;
plot_graphs(deltaOI, OI_link, OI, fig_name, row, col, sa, nodeNames, min_l, max_l,  x_coor, y_coor, lo);
plot_graphs(deltaOIR, OIR_link, OIR, fig_name, row, col, sa+3, nodeNames, min_l, max_l,  x_coor, y_coor, lo);

width = 1150;  height = 550;
fig1 = figure(fig_name);
set(fig1, 'Position', [100, 200, width, height]);

end






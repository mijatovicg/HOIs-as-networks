clear; close all; clc;

%% Input parameters
pmax = 1; % maximum lag
Q = 5; % n. of processes
q = 20;
p1 = 1;
p2 = 1;

row = 1; col = 3;

min_l = -0.65;
max_l = 0.65;
fig_name = 2;
nodeNames = {'1','2','3','4','5'};
x_coor = [0 -1 -1 1 1];
y_coor = [0 1 -1 -1 1];
lo = 'force';

scen_array = [1, 2, 3]; % three possible scenarions, see below

for sa = 1 : numel(scen_array)

    if sa == 1 %% full REDUNDANCY
        a21 = 1; a12 = 0;
        a31 = 1; a13 = 0;
        a41 = 1; a14 = 0;
        a51 = 1; a15 = 0;
        p1 = 1;
        p2 = 1;
    elseif sa == 2 %% full SYNERGY
        a21 = 0; a12 = 1;
        a31 = 0; a13 = 1;
        a41 = 0; a14 = 1;
        a51 = 0; a15 = 1;
        p1 = 1;
        p2 = 1;
    elseif sa == 3 % MIX
        a21 = 0.3; a12 = 0;
        a31 = 0.3; a13 = 0;
        a41 = 0; a14 = 2;
        a51 = 0; a15 = 2;
        p1 = 1;
        p2 = 1;
    else
    end


    %% simulation design
    Su = eye(Q);
    Ak = zeros(Q, Q, pmax); % blocks of coefficients
    % effects originating from 1 (at lag 1)
    Ak(2,1,p1) = a21;
    Ak(3,1,p1) = a31;
    Ak(4,1,p1) = a41;
    Ak(5,1,p1) = a51;
    % effects directed to 1 (at lag 1)
    Ak(1,2,p2) = a12;
    Ak(1,3,p2) = a13;
    Ak(1,4,p2) = a14;
    Ak(1,5,p2) = a15;


    Am = [];
    for kk = 1 : pmax
        Am = [Am Ak(:,:,kk)];
    end

    %% COMPUTATION OF:
    %%  OIR-gradient
    delta_node = nan*ones(1,Q);
    for in = 1 : Q
        sources = (1 : Q); sources(in)=[];
        target = in;
        multiplet = [sources target];
        out2 = lrp_deltaOIR(Am, Su, q, multiplet, target);
        delta_node(in)=out2.dO12;
    end
    %% local OIR
    lOIR_link = nan*ones(Q,Q);
    for ix = 1 : Q
        for iy = ix+1 : Q
            out = lrp_localOIR(Am, Su, q, ix, iy);
            lOIR = out.local_OIR; % original
            lOIR_link(ix, iy) = lOIR;
        end
    end
    %% OIR
    iQ = 1:Q;
    out = lrp_OIR(Am, Su, q, iQ);
    OIR = out.OIR;

    %% display results
    disp('OIR gradient (LRP):');
    disp(delta_node);
    disp('local OIR (LRP):');
    disp(lOIR_link);
    disp('OIR (LRP):');
    disp(OIR);

    %% VISUALIZATION
    fig_name1 = 2;
    plot_graphs(delta_node, lOIR_link, OIR, fig_name1, row, col, sa, nodeNames, min_l, max_l,  x_coor, y_coor, lo);

end

width = 1250;  height = 250;
fig1 = figure(fig_name);
set(fig1, 'Position', [100, 300, width, height]);



clear; close all; clc;

%% Input parameters
pmax = 1; % maximum lag
Q = 5; % n. of processes
q = 20;
SelCrit ='aic';

N = 100;
numsurr = 100;

a31 = 0;

%% simulation coefficients
a21 = 0.3; a12 = 0; % from 1 and to 1
a13 = 0;
a41 = 0; a14 = 2;
a51 = 0; a15 = 2;
p1 = 1; p2 = 1;

%%
Su = eye(Q);
Ak = zeros(Q, Q, pmax); % blocks of coefficients
%% ESTIMATION

    %% simulation design
    %effects originating from 1 (at lag 1)
    Ak(2,1,p1) = a21;
    Ak(3,1,p1) = a31;
    Ak(4,1,p1) = a41;
    Ak(5,1,p1) = a51;
    %effects directed to 1 (at lag 1)
    Ak(1,2,p2) = a12;
    Ak(1,3,p2) = a13;
    Ak(1,4,p2) = a14;
    Ak(1,5,p2) = a15;

    Am = [];
    for kk = 1 : pmax
        Am = [Am Ak(:,:,kk)];
    end

    %% THEORETICAL VALUES:
    %% OIR-gradient
    theor = nan*ones(1,Q); % gradient for each node
    for in = 1 : Q %index of node
        sources = (1 : Q); sources(in)=[]; % indexes of the N-1 blocks forming X-j
        target = in; % Index of the block Xj
        multiplet = [sources target]; % assigned group of block processes X^N
        out2 = lrp_deltaOIR(Am, Su, q, multiplet, target);
        theor(in)= out2.dO12;
    end

    U = mvnrnd(zeros(Q, 1), Su, N)'; % U: Q*N matrix of innovations
    Y = MVARfilter(Am, U); % simulated time series
    data = Y';

    X = data - mean(data);

    [pottaic,pottbic] = mos_idMVAR(X',pmax,0); % model order selection
    switch SelCrit
        case 'aic'
            p = pottaic;
        case 'bic'
            p = pottbic;
    end


    [Am_data, Su_data, ~, U_data] = idMVAR(X', p, 0);

    %% delta OIR and delta OIR surrogates
    delta_orig = []; delta_surr = [];
    for in = 1 : Q %index of node
        i_sources = 1:Q;
        i_sources(in) = [];
        i_target = in;
        iQ = [i_sources i_target];

        out = lrp_deltaOIR(Am_data, Su_data, q, iQ, i_target);  % original
        delta_orig = [delta_orig out.dO12]; % for all nodes

        surr = [];
        for ii = 1 : numsurr % surrigates for ii_th node

            [Am_surr, Su_surr] = surr_bootstrap(U', Am_data, p);
            out = lrp_deltaOIR(Am_surr, Su_surr, q, iQ, i_target);  % original
            surr = [surr; out.dO12];
        end

        delta_surr = [delta_surr surr]; % for all nodes

    end % for each node

    CI_1 =  prctile(delta_surr, 2.5); % for all nodes
    CI_2 =  prctile(delta_surr, 97.5); % for all nodes

    flag = [];
    for ff = 1 : Q
        if 0 >= CI_1(ff) & 0 <= CI_2(ff)
            flag = [flag 0]; % if 0 belongs to CI --> non-significant
        else
            flag = [flag 1]; % otherwise it is significant
        end
    end

    disp('a31 parameter:'); disp(a31); disp('OIR-gradient values (for each node):'); disp(delta_orig); 
    disp('OIR-gradient statistical significance (for each node):'); disp(flag); disp ('(0:non-significant; 1:significant)');



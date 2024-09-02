function [Am_surr, Su_surr] = surr_bootstrap(U, Am_data, p)

% U: innovation matrix, must be organized by columns

num_rows = size(U, 1);
random_indices = datasample(1:num_rows, num_rows, 'Replace', true);
Us = U(random_indices, :);

Ys = MVARfilter(Am_data, Us'); % simulated time series
datash = Ys';

Xsh = datash - mean(datash);

[Am_surr, Su_surr, ~, ~] = idMVAR(Xsh',p, 0);




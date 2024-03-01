function [h, p, stats] = tc_shapetest(data, varargin)
%tc_shapetest performs a permutation test on the hypothesis that a given order
%   of data points explains the data.
%
%   In a scenario where multiple means need to be compared, common ways are
%   multiple comparisons of 2 means (and correction for multiple comparison) or
%   advanced solutions like a cluster based permutation test. The first approach
%   has the advantage that the size of the difference between multiple means can
%   be obtained, but for multiple comparisons statistical power decreases with
%   the number of comparisons. This problem can be dealt with using e.g. cluster
%   based permutation tests. However, adjacent data points need to be correlated
%   and obtained clusters can only be interpreted as such and no conclusions
%   about the difference between points within a cluster can be drawn.
%
%   tc_shapetest aims to combine positive and negative aspects of both test
%   such, that conclusions about the difference between multiple means can be
%   drawn, but sacrificing the size of that difference. This means that the
%   result can only be interpreted as a whole and the size of difference between
%   means cannot be obtained. However, the general shape (in terms of rank
%   order) of how means qualitively relate to each other can be obtained with
%   high statistical power.
%
%   This is achieved by fittig the rank order of multiple means back on the raw
%   data and obtaining an initial fit if that rank order. In a second
%   permutation step, the same procedure is performed, but the data is shuffled
%   across groups.
%
%   Example:
%       Assume you have a matrix of size 100 x 5. You are interested in whether
%       the 5 columns on average follow a certain profile. Since you want to
%       avoid 5! ttests and you are not intersted in the magnitude of the
%       difference anyway, you decide for tc_shapetest. The shape is obtained
%       by computing the average over all 100 observations and the resulting
%       vector is transformed into a rank order, where the lowest values
%       receives a 1 and the highest a 5. For example your resulting rank order
%       might be [3, 2, 5, 1, 4]. tc_shapetest, tests for the 0-hypothesis that
%       this profile could have been obtained just as likely if you would
%       shuffle the columns. If the 0-hypothesis is rejected, it means that this
%       profile ([3, 2, 5, 1, 4]) explains the data better than it would if the
%       column order was meaningless. Just to reiterate: the test does not tell
%       you how big difference between e.g. the 2nd and 4th column is, nor does
%       it allow for any individual comparison. The only conclusion valid to
%       draw is that the data follows this general pattern.
%
%   [h, p, stats] = tc_shapetest(data, varargin)
%
%   Input:
%       data: m x n matrix. m is the number of examples and n the dimensionality
%       of the shape.
%
%   Possible argument pairs:
%       'permutations', p: number of permutations to build distribution
%       'alpha', a: alpha level on which significance is declared
%       'shape', s: vecor of length n to use as shape to test against (rather
%           than the average shape)
%       'normalize_rankorder', nr: true or false on whether to normalize rank
%           order values between 0 and 1. Note that the difference between 0 and
%           the smallest value and 1 and the highest value will be equal. 0 and
%           1 will thus not be included in the normalized shape.
%       'n_ranks', nr: 'adaptive' or a single value representing the number of
%           ranks (i.e.) steps on which the shape will be built on. If n_ranks
%           is smaller than n, than values closest together will be assigned the
%           same rank value. 'adaptive' determines the shape (varying the rank
%           order) that best fits the data.
%
%   Output:
%       h: 0 or 1 on whether the H1 was accepted or rejected.
%       p: p value of the test
%       stats: structure including the following fields:
%           distribution: the permutation ditribution
%           alpha: the chosen alpha value
%           thresh: the value at which significance is reach
%           rankorder: the shape transformed into a rank order
%           rankorder_fit: the fit of the rank order shape on the original data

% check for function
try
    tc_rankvalue(1);
catch
    error('please make sure tc_rankvalue can be accessed. See: github.com/TommyClausner/tc_functions')
end
%% Defaults
alpha_val = 0.05;
n_perm = 10000;
n_ranks = size(data, 2);
test_shape = [];
normalize_ranks = true;
adaptive_fit = false;
method = 'lineq';

% set input arguments
if ~isempty(varargin)
    for arg = 1:2:length(varargin)
        switch varargin{arg}
            case 'permutations'
                n_perm = varargin{arg + 1};
            case 'alpha'
                alpha_val = varargin{arg + 1};
            case 'shape'
                test_shape = varargin{arg + 1};
            case 'normalize_ranks'
                normalize_ranks = varargin{arg + 1};
            case 'method'
                method = varargin{arg + 1};
            case 'n_ranks'
                if ischar(varargin{arg + 1})
                    if strcmpi(varargin{arg + 1}, 'adaptive')
                        adaptive_fit = true;
                    end
                end
                n_ranks = varargin{arg + 1};
            otherwise
                error('unknown argument %s', varargin{arg})
        end
    end
end

%% define functions
meanfct = @(x) mean(x, 1, 'omitnan'); % data avg shortcut

% function to replace values of the same cluster with the average
transform2kdata = @(a, c) arrayfun(@(x) mean(a(c==x)), c)';

% normlizing function
if normalize_ranks
    norm_fct = @(x, d) x./(max(x) + 1); % same distance between 0 values and 1
else
    norm_fct = @(x) x;
end

% use k means clustering to find nearest data points and assign to cluster. This
% is necessary to ensure that close by data is grouped together if the number of
% ranks is lower than the maximum.
if n_ranks < size(data, 2)
    kranks = @(a, n) norm_fct(tc_rankvalue(transform2kdata(a, kmeans(a', n))));
else
    kranks = @(a, n) norm_fct(tc_rankvalue(a));
end

switch lower(method)
    case 'lineq'
        fitfct = @(x, y) mean(arrayfun(@(z) y(z, :)'\x', 1:size(y, 2)), 'omitnan'); % data fit shortcut
        thresh_fun = @(x, a, i) prctile(x, abs(((i > 0)-a)*100));
        p_fun = @(x, i) mean(i > x)*(i < 0) + mean(i < x)*(i > 0) + 1*(i == 0);
    case 'mse'
        fitfct = @(x, y) mean(arrayfun(@(z) mean(((y(z, :) - mean(y(z, :))) - (x - mean(x))).^2), 1:size(y, 2)), 'omitnan'); % data fit shortcut
        thresh_fun = @(x, a, i) prctile(x, a*100);
        p_fun = @(x, i) mean(i > x);
    case 'r2'
        fitfct = @(x, y) mean(arrayfun(@(z) r2_helper(@() fit(y(z, :)', x', 'poly1')), 1:size(y, 2)), 'omitnan');
        thresh_fun = @(x, a, i) prctile(x, (1-a)*100);
        p_fun = @(x, i) mean(i < x);
        data = double(data);
    otherwise
        error('unknown method %s', method)
end
%% initial computation
% adaptive fit searches for the best fit given a variable number of ranks
if adaptive_fit
    % initial condition is to use as many ranks as there are dimensions
    n_ranks = size(data, 2);
    data_shape = kranks(meanfct(data), n_ranks);
    initial_fit = fitfct(data_shape, data);
    
    % find shape with highest fit value
    for r = 2:size(data, 2)-1
        tmp_shape = kranks(meanfct(data), r);
        tmp_fit = fitfct(tmp_shape, data);
        if initial_fit < 0
            if tmp_fit < initial_fit
                initial_fit = tmp_fit;
                data_shape = tmp_shape;
                n_ranks = r;
            end
        else
            if tmp_fit > initial_fit
                initial_fit = tmp_fit;
                data_shape = tmp_shape;
                n_ranks = r;
            end
        end
    end
    
    % use found shape later as well
    test_shape = data_shape;
else
    % if no shape is provide test against the shape resulting from the average
    if isempty(test_shape)
        data_shape = kranks(meanfct(data), n_ranks);
    else
        data_shape = test_shape;
    end
    
    % obtain reference value
    initial_fit = fitfct(data_shape, data);
    
end

%% permutation part

% initialize variables
ref_distr = zeros(1, n_perm);
tmp_data = zeros(size(data));

% make index vector (faster than iterating through all rows)
dim_1_inds = reshape(((1:size(data, 1))'*ones(1, size(data, 2)))', [], 1);

for n = 1:n_perm
    
    % make second index vector to shuffle columns per row
    dim_2_inds = cell2mat(arrayfun(@randperm, ones(1, size(data, 1))*size(data, 2), 'unif', 0))';
    
    % set data according to shuffled columns per row
    tmp_data(sub2ind(size(data), dim_1_inds, dim_2_inds)) = data;
    
    % define shape to test against see part above
    if isempty(test_shape)
        tmp_shape = kranks(meanfct(tmp_data), n_ranks);
    else
        tmp_shape = test_shape;
    end
    
    % fill value into distribution vector
    ref_distr(n) = fitfct(tmp_shape, tmp_data);
end

% compute critical value based on permutation distribution
thresh_val = thresh_fun(ref_distr, alpha_val, initial_fit);

%% make output
stats = struct;
stats.distribution = ref_distr;
stats.alpha = alpha_val;
stats.thresh = thresh_val;
stats.rankorder = data_shape;
stats.rankorder_fit = initial_fit;
p = p_fun(ref_distr, initial_fit);
h = p < alpha_val;
stats.p = p;
    function r2 = r2_helper(fun)
        [~,gof] = fun();
        r2 = abs(gof.adjrsquare);
    end
end

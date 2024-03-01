function results = tc_cluster_permutation_test(dataA, varargin)
%tc_cluster_permutation_test performs ND cluster based permutation test. 
%   The first step is to compute the t statistic for the data, which is
%   thresholded given a certain alpha value. Afterwards the resulting
%   binary ndarray is labelled, given a minimal connectivity. A cluster
%   value for each cluster is computed by the sum of all t values within a
%   certain cluster. To compute the test statistic a permutation
%   distribution is computed similar to what is discribed above, except
%   that the data is randomly shuffled between the two groups.
%
%   results = tc_cluster_permutation_test(data) single sample cluster based
%   permutation test. The comparison is made relative to an equally sized
%   array of zeros, which is equivalent to randomly multiplying each
%   subject with -1 or 1. The default subject dimension is 1.
%
%   results is a structure with the following fields:
%
%       tmap            t statistic used to form initial clusters.
%
%       pos.h           0 or 1 for whether to reject H0 for each cluster. 
%
%       pos.p           p value for each cluster.
%
%       pos.stats       Cluster statistic for each cluster (sum of t
%                       values)
%
%       pos.clusters    Clusters found in the data. The last dimension of
%                       this binary array separates the different clusters,
%                       where a 1 indicates the cluster. 
%
%       neg.?           Similar to pos, but for negative clusters.
%
%   results = tc_cluster_permutation_test(dataA, dataB) computes cluster
%   based permutation test for the comparison of dataA and dataB. The
%   default subject dimension is 1.
%
%   results = tc_cluster_permutation_test(data,...,'dim',DIM) set the
%   dimension over which the test is computed. Default is 1.
%
%   results = tc_cluster_permutation_test(data,...,'alpha',ALPHA) set the
%   test alpha. Default is 0.05.
%
%   results = tc_cluster_permutation_test(data,...,'tail',TAIL) set the
%   test tail of the distribution. Can be either:
%       -1 - Test left tail of the distribution.
%        1 - Test right tail of the distribution.
%        0 - Two sided test (Default). ALPHA is devided by 2. 
%
%   results = tc_cluster_permutation_test(data,...,'permutations',N) set
%   the number of permutations to be performed in order to obtain the test
%   distribution. Default is 10000.
%
%   results = tc_cluster_permutation_test(subject,...,'link',LINK)
%   dimension to be linked. The clusters will be computed and afterwards
%   all clusters will be speparated that are not connected over the LINK
%   dimension. If set to 0 (Default), no dimension will be linked.
%
%   Example:
%       results = tc_cluster_permutation_test(data, 'dim', 2, 'tail', -1, 'link', 3)

% check second data argument. If none, use array of zeros.
warning('off')
if nargin > 1
    if ~ischar(varargin{1})
        dataB = varargin{1};
        vararginds = 2:2:length(varargin);
    else
        dataB = zeros(size(dataA));
        vararginds = 1:2:length(varargin);
    end
else
    dataB = zeros(size(dataA));
    vararginds = [];
end

% default parameter settings
subjects_dim = 1;
alpha_thresh = 0.05;
clusteralpha = 0.05;
tail = 0;
n_permutations = 10000;
link_dim = 0;

% check input parameters key value pairs and override defaults.
for varargind = vararginds
    switch varargin{varargind}
        case 'dim'
            subjects_dim = varargin{varargind + 1};
        case 'alpha'
            alpha_thresh = varargin{varargind + 1};
        case 'tail'
            tail = varargin{varargind + 1};
        case 'permutations'
            n_permutations = varargin{varargind + 1};
        case 'clusteralpha'
            clusteralpha = varargin{varargind + 1};
        case 'link'
            link_dim = varargin{varargind + 1};
    end
end

t_crit = tinv(1-alpha_thresh, 2*size(dataA, subjects_dim) - 2);
results = struct;

% cluster conectivity (-1 because 1 dimension gets reduced by the ttest)
if (ndims(dataA) - 1) < 2
    conn = [];
else
    conn = conndef(ndims(dataA) - 1, 'minimal');
end

% get relevant statistics and clusters.
[tmap, c_stats_p, c_stats_n, c_labels_p, c_labels_n] = get_stats(...
    dataA, dataB, alpha_thresh, subjects_dim, tail, t_crit, conn, link_dim);

if isempty(c_stats_p)
    c_stats_p = 0;
end
if isempty(c_stats_n)
    c_stats_n = 0;
end
results.tmap = squeeze(tmap);
results.pos.clusters = squeeze(stack_clusters(c_labels_p));
results.neg.clusters = squeeze(stack_clusters(c_labels_n));

results.pos.stats = c_stats_p;
results.neg.stats = c_stats_n;

% prepare permutation distribution. If no cluster was found the respective
% permutation receives the most extreme value.
rand_stats_p = -Inf(1, n_permutations);
rand_stats_n = Inf(1, n_permutations);

% concatenate data over subject dimension for shuffling.
data4shuffle = cat(subjects_dim, dataA, dataB);

t = tic;
for perm = 1:n_permutations
    if toc(t) > 1
        fprintf('iteration %d\n', perm)
        t = tic;
    end
    
    % shuffle indices of subject dimension
    rand_inds = randperm(size(data4shuffle, subjects_dim));
    
    % get 1st half of shuffled data
    dataA_shuffle = tc_get_from_unknown(data4shuffle, subjects_dim, ...
        rand_inds(1:end/2));
    
    % get 2nd half of shuffled data
    dataB_shuffle = tc_get_from_unknown(data4shuffle, subjects_dim, ...
        rand_inds(end/2+1:end));
    
    % obtain cluster stats
    [~, rand_stat_p, rand_stat_n] = get_stats(...
        dataA_shuffle, dataB_shuffle, alpha_thresh, subjects_dim, tail, ...
        t_crit, conn, link_dim);
    
    % set highest (lowest) cluster value if random cluster(s) were formed
    if ~isempty(rand_stat_p)
        rand_stats_p(perm) = max(rand_stat_p);
    end
    
    if ~isempty(rand_stat_n)
        rand_stats_n(perm) = min(rand_stat_n);
    end
end

% compute p value as the fraction of how many random cluster sums exceed
% the data cluster sum.
results.pos.p = sum(repmat(rand_stats_p, size(c_stats_p, 1), 1) > ...
    repmat(c_stats_p, 1, size(rand_stats_p, 2)), 2) / n_permutations;

results.neg.p = sum(repmat(rand_stats_n, size(c_stats_n, 1), 1) < ...
    repmat(c_stats_n, 1, size(rand_stats_n, 2)), 2) / n_permutations;

% check hypothesis for p < alpha
if tail == 0
   clusteralpha = clusteralpha / 2; 
end
results.pos.h = results.pos.p < clusteralpha;
results.neg.h = results.neg.p < clusteralpha;

    function [ts, sp, sn, cp, cn] = get_stats(da, db, a, d, t, tc, c, ld)
        % standard ttest
        [~,~,~,ts] = ttest(da, db, 'dim', d, 'alpha', a, 'tail', t);
        ts=squeeze(ts.tstat);
        
        % find clusters given a certain connectivity (minimal)
        if isempty(c)
            cp = bwlabeln(ts>tc);
            cn = bwlabeln(ts<-tc);
        else
            cp = bwlabeln(ts>tc, c);
            cn = bwlabeln(ts<-tc, c);
        end
        
        % if desired, split clusters that are not connected along the link 
        % dimension 
        if ld > 0
            % because of the squeeze of the tmap
            if ld > d
               ld = ld - 1; 
            end
            cp = tc_link_corr_clust(cp, ld);
            cn = tc_link_corr_clust(cn, ld);
        end
        
        % compute cluster sums for all clusters
        sp = arrayfun(@(x) sum(ts(cp == x), 'all'), unique(cp(cp>0)))';
        sn = arrayfun(@(x) sum(ts(cn == x), 'all'), unique(cn(cn>0)))';
    end

    function stacked_c = stack_clusters(raw_clusters)
        % helper function to stack clusters along new dimension
        stack_dim = ndims(raw_clusters) + 1;
        
        % transform cluster labels map into stacked binary data map
        stacked_c = [];
        for val = unique(raw_clusters(raw_clusters>0))'
            stacked_c = cat(stack_dim, stacked_c, raw_clusters == val);
        end
    end
end

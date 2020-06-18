function results = tc_cluster_permutation_test(data_A, data_B, varargin)
%results = TC_CLUSTER_PERMUTATION_TEST(data_A, data_B, varargin)
%
%   Implementation of the non-parametric cluster permutation test [1]. See:
%
%   Performs a non-parametric cluster permutation test for paired or
%   independend data.
%
%   results = TC_CLUSTER_PERMUTATION_TEST(data_A) performs a single sample
%   cluster permutation test for the hypothesis H0 that data_A has a mean
%   of 0.
%   
%   data_A must be a N x D matrix, where N is the number of observations.
%   If data_A is a 2-dimensional matrix, clusters will be found along the
%   second dimension of data_A. If data_A is a 3-dimensional matrix, data
%   will be clustered based on 2-dimensional data in dimensions 2 and 3 of
%   data_A.
%
%   results = TC_CLUSTER_PERMUTATION_TEST(data_A, data_B) performs an 
%   independend sample cluster permutation test for the hypothesis H0 that 
%   data_A and data_B are independend random samples from normal
%   distributions with equal mean and variance.
%
%   results = TC_CLUSTER_PERMUTATION_TEST(data_A, data_B, 'NAME',value) 
%   specifies one or more of the following name/value pairs:
%
%       Parameter           Value
%       'alpha'             A value ALPHA between 0 and 1 specifying the
%                           significance level as (100*ALPHA)%. Default is
%                           0.05 for 5% significance.
%       'num_clusters'      Number of clusters to be considered. Clusters 
%                           are sorted (descending). Default is 1.
%       'tail'              Directionality of test:
%           0               positive and negative clusters (default)
%           1               only negative clusters
%           -1              only positive clusters
%       'test'              String specifying the test:
%           'paired'        Paired sample test (default).
%           'independend'   Independend samples test.
%       'min_cluster_size'  Minimum size of cluster (adjacent cells) for it
%                           to be considered. Default is 0.
%       'n_permutations'    Number of permutations. Default is 1000.
%
%   results = TC_CLUSTER_PERMUTATION_TEST(...) returns a structure with the 
%   following fields:
%      'H'           -- whether to reject H0
%      'p'           -- p-values on which the decision about H0 was made
%      'clusters'    -- positive and negative clusters. Found clusters will
%                       be indicated by constructing a vector of zeros of
%                       size data_A(1, :), indicating each cluster with
%                       incrementing integers at the respective position.
%      'T'           -- t-value map on which the permutation test was 
%                       performed.
%      'test_stat'   -- the test (paired or independend) that was chosen
%
%   References:
%
%      [1] Maris E., Oostenveld R. Nonparametric statistical testing of 
%      EEG- and MEG-data. J Neurosci Methods. 2007 Apr 10

%   Copyright 2020 Tommy Clausner (tommy.clausner@gmail.com)

%% default variables
alpha_thresh = 0.05;
num_clusters = 1;
tail = 0;
test = 'independend';
min_cluster_size = 0;
n_permutations = 1000;

%% accept input in form of name/value pairs
if nargin > 2
    for val_pair=1:2:length(varargin)
        switch varargin{val_pair}
            case 'alpha'
                alpha_thresh = varargin{val_pair + 1};
            case 'num_clusters'
                num_clusters = varargin{val_pair + 1};
            case 'tail'
                tail = varargin{val_pair + 1};
            case 'test'
                test = varargin{val_pair + 1};
            case 'min_cluster_size'
                min_cluster_size = varargin{val_pair + 1};
            case 'n_permutations'
                n_permutations = varargin{val_pair + 1};
        end
    end
end

if tail == 0
    alpha_thresh = alpha_thresh / 2;
end

% critical value to threshold t map
t_crit = tinv(1-alpha_thresh, 2*size(data_A, 1) - 2);

% create data for single sample test
if isempty(data_B)
    data_B=zeros(size(data_A));
    test = 'paired';
end

independend_test = strcmpi(test, 'independend');

% initial t map
if independend_test
    [~,~,~,test_stats] = ttest2(data_A,data_B);
else
    [~,~,~,test_stats] = ttest(data_A,data_B);
end

T=test_stats.tstat;

% find clusters
[cluster_stats, cluster_labels] = find_clusters(T, double(T>t_crit));

% find max cluster
[pos_cluster_stats, pos_cluster] = compute_cluster_stats(cluster_stats, cluster_labels, tail, num_clusters, min_cluster_size, 'descend');

% same as above for negative clusters
[cluster_stats, cluster_labels] = find_clusters(T, double(T<-t_crit));
[neg_cluster_stats, neg_cluster] = compute_cluster_stats(cluster_stats, cluster_labels, tail, num_clusters, min_cluster_size, 'ascend');

% prepare permutation
pos_perm_stats = zeros(1,n_permutations);
neg_perm_stats = zeros(1,n_permutations);

% Compute the permutation distribution
for perm_ind=1:n_permutations
    
    % shuffle data
    if independend_test
        data_concat = [data_A;data_B];
        shuffle_inds=randperm(size(data_concat,1));
        shuffle_data=data_concat(shuffle_inds,:, :);
        shuffle_data_A=shuffle_data(1:end/2,:, :);
        shuffle_data_B=shuffle_data(end/2+1:end,:, :);
        [~,~,~,test_stats] = ttest2(shuffle_data_A,shuffle_data_B);
    else
        shuffle_data_A = [];
        shuffle_data_B = [];
        for n = 1:size(data_A, 1)
            data_concat = [data_A(n, :),data_B(n, :)];
            shuffle_inds=randperm(size(data_concat, 2));
            shuffle_data=data_concat(shuffle_inds);
            shuffle_data_A = cat(1, shuffle_data_A, shuffle_data(shuffle_inds(1:end/2)));
            shuffle_data_B =cat(1, shuffle_data_B, shuffle_data(shuffle_inds(end/2 + 1:end)));
        end
        shuffle_data_A = reshape(shuffle_data_A, n, size(data_A, 2), numel(data_A)/size(data_A, 1)/size(data_A, 2));
        shuffle_data_B = reshape(shuffle_data_B, n, size(data_B, 2), numel(data_B)/size(data_B, 1)/size(data_B, 2));
        [~,~,~,test_stats] = ttest(shuffle_data_A,shuffle_data_B);
    end
    tstats=test_stats.tstat;
    
    % same as before
    cluster_stats = find_clusters(tstats, double(tstats>t_crit));
    
    if ~isempty(cluster_stats) && (tail == 0 || tail == 1)
        pos_perm_stats(perm_ind)=max(cluster_stats);
    else
        pos_perm_stats(perm_ind)=-Inf; % -Inf is a value that is exceeded by all positive cluster statistics
    end
    
    cluster_stats = find_clusters(tstats, double(tstats<-t_crit));
    
    if ~isempty(cluster_stats) && (tail == 0 || tail == -1)
        neg_perm_stats(perm_ind)=min(cluster_stats);
    else
        neg_perm_stats(perm_ind)=Inf; % Inf is a value that is larger than all negative cluster statistics
    end
end

% calculate permutation p-values, separately for the positive and the negative cluster statistics
permutation_p = compute_permutation_p(pos_cluster_stats, pos_perm_stats, tail, num_clusters, n_permutations, 'gt');

pos_permutation_p = permutation_p;
h_pos=double(permutation_p<alpha_thresh); % devide by two for two sided

permutation_p = compute_permutation_p(neg_cluster_stats, neg_perm_stats, tail, num_clusters, n_permutations, 'lt');

neg_permutation_p = permutation_p;
h_neg=double(permutation_p<alpha_thresh);

% make results
results = struct('H', struct('pos', h_pos, 'neg', h_neg), ...
    'p', struct('pos', pos_permutation_p, 'neg', neg_permutation_p),...
    'clusters', struct('pos', pos_cluster, 'neg', neg_cluster), ...
    'T', T, 'test_stat', test);
    
    function [cluster_stats, cluster_labels] = find_clusters(tstats, tstats_thresh)
        % finds clusters in thresholded t-map and determines their size.
        [cluster_labels,n_clusters] = bwlabeln(tstats_thresh);
        cluster_stats=zeros(1,n_clusters);
        
        for cluster_ind=1:n_clusters
            cluster_sel=(cluster_labels==cluster_ind);
            cluster_stats(cluster_ind)=sum(tstats(cluster_sel), 'all');
        end
        
    end

    function [cluster_stats, cluster] = compute_cluster_stats(cluster_stats, cluster_labels, tail, num_clusters, min_cluster_size, direction)
        % computes cluster statistics, sorts and selects cluster. 
        cluster = zeros(size(cluster_labels));
        
        if ~isempty(cluster_stats) && (tail == 0 || tail == 1)
            [cluster_stats, inds] = sort(cluster_stats, direction);
            cluster_counter = 1;
            if length(cluster_stats)<num_clusters
                tmp_n_clusters = length(cluster_stats);
            else
                tmp_n_clusters = num_clusters;
            end
            counter = 0;
            for ind = inds(1:tmp_n_clusters)
                counter = counter + 1;
                if sum(cluster_labels == ind, 'all') >= min_cluster_size
                    cluster(cluster_labels == ind) = cluster_counter;
                    cluster_counter = cluster_counter + 1;
                else
                    cluster(cluster_labels == ind) = 0;
                    cluster_stats(counter) = [];
                end
            end
        else
            cluster_stats = [];
        end
    end

    function permutation_p = compute_permutation_p(cluster_stats, perm_stats, tail, num_clusters, n_permutations, direction)
       % computes permutation p value, used to decide on H0.
        if ~isempty(cluster_stats) && (tail == 0 || tail == 1)
            permutation_p = [];
            if length(cluster_stats)<num_clusters
                tmp_n_clusters = length(cluster_stats);
            else
                tmp_n_clusters = num_clusters;
            end
            for cluster_stat = cluster_stats(1:tmp_n_clusters)
                if strcmpi(direction, 'gt')
                    permutation_p=cat(2, permutation_p, sum(double(perm_stats>cluster_stat), 'all')/n_permutations);
                elseif strcmpi(direction, 'lt')
                    permutation_p=cat(2, permutation_p, sum(double(perm_stats<cluster_stat), 'all')/n_permutations);
                end
            end
        else
            permutation_p=1;
        end 
    end
end
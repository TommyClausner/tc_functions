function [Hs, ps, clusters, T] = tc_cluster_permutation_test(data_A, data_B, alpha_thresh)
%% [Hs, ps, clusters, T] = tc_cluster_permutation_test(dataA, dataB, alpha_thresh)
%
% first dimension must be observations
%
% input: data_A and data_B of same size; alpha threshold
%
% if data_B is empty, it will be replaced with normal distributed random
% dat with zero mean.
%
% returns: Hs (whether to reject H0); ps (p values); clusters; T (t values)
%
% note that for Hs, ps, and clusters the first dimension is the sign of the
% cluster, where e.g. Hs(1, :) is for positive and Hs(2, :) for negative
% clusters (similar for ps and clusters). T is bidirectional.

% simulation parameters
n_permutations = 1000;
t_crit = tinv((1-alpha_thresh/2),(2*size(data_A, 1) - 2));

% create zero mean normal distributed data for single sample test
if isempty(data_B)
    data_B = randn(size(data_A));
end

% initial t map
[~,~,~,test_stats] = ttest(data_A,data_B);
T=test_stats.tstat;

% find clusters
[cluster_stats, cluster_labels] = find_clusters(T, double(T>t_crit));

% find max cluster
pos_cluster = zeros(size(cluster_labels));
if ~isempty(cluster_stats)
    [pos_cluster_stats, ind] = max(cluster_stats);
    pos_cluster(cluster_labels == ind) = 1;
else
    pos_cluster_stats = [];
end

% same as above for negative clusters
[cluster_stats, cluster_labels] = find_clusters(T, double(T<-t_crit));

neg_cluster = zeros(size(cluster_labels));
if ~isempty(cluster_stats)
    [neg_cluster_stats, ind] = min(cluster_stats);
    neg_cluster(cluster_labels == ind) = 1;
else
    neg_cluster_stats = [];
end

% prepare permutation
pos_perm_stats = zeros(1,n_permutations);
neg_perm_stats = zeros(1,n_permutations);

data_concat = [data_A;data_B];
length_concat_data = size(data_concat,1);

% Compute the permutation distribution
for perm_ind=1:n_permutations
    
    % shuffle data
    shuffle_inds=randperm(length_concat_data);
    shuffle_data=data_concat(shuffle_inds,:, :);
    shuffle_data_A=shuffle_data(1:end/2,:, :);
    shuffle_data_B=shuffle_data(end/2+1:end,:, :);

    [~,~,~,test_stats] = ttest(shuffle_data_A,shuffle_data_B);
    tstats=test_stats.tstat;
    
    % same as before
    cluster_stats = find_clusters(tstats, double(tstats>t_crit));
    
    if ~isempty(cluster_stats)
        pos_perm_stats(perm_ind)=max(cluster_stats);
    else
        pos_perm_stats(perm_ind)=-Inf; % -Inf is a value that is exceeded by all positive cluster statistics
    end
    
    cluster_stats = find_clusters(tstats, double(tstats<-t_crit));
    
    if ~isempty(cluster_stats)
        neg_perm_stats(perm_ind)=min(cluster_stats);
    else
        neg_perm_stats(perm_ind)=Inf; % Inf is a value that is larger than all negative cluster statistics
    end
end

% calculate permutation p-values, separately for the positive and the negative cluster statistics
if ~isempty(pos_cluster_stats)
    permutation_p=sum(double(pos_perm_stats>pos_cluster_stats), 'all')/n_permutations;
else
    permutation_p=1;
end

pos_permutation_p = permutation_p;
h_pos=double(permutation_p<(alpha_thresh/2)); % devide by two for two sided

if ~isempty(neg_cluster_stats)
    permutation_p=sum(double(neg_perm_stats<neg_cluster_stats), 'all')/n_permutations;
else
    permutation_p=1;
end

neg_permutation_p = permutation_p;
h_neg=double(permutation_p<(alpha_thresh/2));

% make results
Hs = [h_pos;h_neg];
ps = [pos_permutation_p;neg_permutation_p];
clusters = [pos_cluster;neg_cluster];

    function [cluster_stats, cluster_labels] = find_clusters(tstats, tstats_thresh)
        [cluster_labels,n_clusters] = bwlabeln(tstats_thresh);
        cluster_stats=zeros(1,n_clusters);
        
        for cluster_ind=1:n_clusters
            cluster_sel=(cluster_labels==cluster_ind);
            cluster_stats(cluster_ind)=sum(tstats(cluster_sel), 'all');
        end
        
    end
end
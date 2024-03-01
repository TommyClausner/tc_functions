function results = tc_nd_cluster_permutation_test(data, data2, dim, tail, n_permutations, alpha, cluster_alpha)
%%
if nargin < 7; cluster_alpha = 0.05;end
if nargin < 6; alpha = 0.05;end
if nargin < 5; n_permutations = 1000;end
if nargin < 4; tail = 'both';end
if nargin < 3; dim = 1;end
if nargin < 2; data2 = 0;end
%%

dims = 1:ndims(data);
swap_dims = [dim dims(dims~=dim)];
data = permute(data, swap_dims);

if ~isscalar(data2)
    data2 = permute(data2, swap_dims);
end

[t_sig, ~, ~, t_stat] = ttest(data, data2, 'dim', 1, 'tail', tail, 'alpha', alpha);
t_stat = t_stat.tstat;

cluster_ref = bwlabeln(t_sig, conndef(ndims(t_sig),'minimal'));
cluster_vals_ref = arrayfun(@(x) sum(t_stat(cluster_ref==x), 'all'), unique(nonzeros(cluster_ref)))';

cluster_val_distr = zeros(1, n_permutations);

for p = 1:n_permutations
    if mod(p, 50) == 0
        fprintf('progress: %.2f %% \n', p/n_permutations*100)
    end
    if isscalar(data2)
        mul_val = ones(size(data, 1), 1);
        rand_neg = randperm(length(mul_val));
        mul_val(rand_neg(1:end/2)) = -1;
        ref_data = data.*repmat(mul_val, [1, size(data, 2:ndims(data))]);
    else
        ref_data = cat(1, data, data2);
        shuffle_inds = randperm(size(ref_data, 1));
        ref_data = ref_data(shuffle_inds, :);
        ref_data = ref_data(1:end/2, :) - ref_data(end/2+1:end, :);
        
        ref_data = reshape(ref_data, size(data));
    end
    [t_sig, ~, ~, t_stat] = ttest(ref_data, 0, 'dim', 1, 'tail', tail, 'alpha', alpha);
    t_stat = t_stat.tstat;
    
    cluster = bwlabeln(t_sig);
    cluster_vals = arrayfun(@(x) sum(t_stat(cluster==x), 'all'), unique(nonzeros(cluster)));
    
    if ~isempty(cluster_vals)
        [~, I] = max(abs(cluster_vals));
        cluster_val_distr(p) = cluster_vals(I);
    end
end

switch tail
    case 'both'
        sig_clusters = cluster_vals_ref<prctile(cluster_val_distr, cluster_alpha*100) | cluster_vals_ref>prctile(cluster_val_distr, 100-cluster_alpha*100);
    case 'left'
        sig_clusters = cluster_vals_ref<prctile(cluster_val_distr, cluster_alpha*100);
    case 'right'
        sig_clusters = cluster_vals_ref>prctile(cluster_val_distr, 100-cluster_alpha*100);
end

clust_ind_vals = unique(nonzeros(cluster_ref));
clust_ind_vals = clust_ind_vals(sig_clusters);

[~, back_swap] = sort(swap_dims);
results = arrayfun(@(x) cluster_ref==x,clust_ind_vals, 'unif', 0);
for r = 1:length(results)
    results{r} = permute(results{r}, back_swap);
end


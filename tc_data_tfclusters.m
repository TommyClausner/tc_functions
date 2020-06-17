function [clustered_data, cluster_inds] = tc_data_tfclusters(log_ratio_data, max_or_min, min_width)

% invert TF data when looking for minima
if strcmpi(max_or_min, 'min')
    data = -log_ratio_data;
else
    data = log_ratio_data;
end

data(data < 0 ) = 0;

% find islands (clusters) of data
if ~isempty(data(data>0))
    power_cluster = bwlabel(imextendedmax(data, nanmean(data(data>0)), 4));
else
    clustered_data = [];
    cluster_inds = false(size(data));
    return
end

% evaluate clusters and make new data array with only clusters and zeros
cluster_inds = false(size(data));
cluster_found = false;
for cluster = unique(nonzeros(power_cluster))'
    if sum(mean(power_cluster == cluster, 1)>0) >= min_width
        cluster_inds = cluster_inds | power_cluster == cluster;
        cluster_found = true;
    end
end

% replace non data clusters with NaN
data(~cluster_inds) = NaN;

if ~cluster_found || nanmax(data(:)) <=0
    clustered_data = [];
else
    clustered_data = data;
end

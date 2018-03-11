function [smooth_data]=tc_mediansmooth(data,kernelwidth)
%% [smooth_data]=tc_mediansmooth(data,kernelwidth)
%
% median filter to smooth one-dimensional data
%
% Input:
%   data: one-dimensional data
%   kernelwidth: width of the smoothing kernel in data points
%
% Ouput: smoothed data

if size(data,1)>1 && size(data,2)>1
    error('only one-dimensional data is supported')
elseif size(data,2)>1 && size(data,1)==1 % speeds up the computation later on
    data=data';
end

padd_beg=ceil(kernelwidth/2); % to avoid 0 indexing if kernelwidth = 1
padd_end=floor(kernelwidth/2); % compensate for above, when odd kernelwidths were chosen

data=[nan(padd_beg,1);data;nan(padd_end,1)]; % padding the data with NaN to allow filter transition on edges

tmp=nan(max(size(data)),kernelwidth);

for n=1:kernelwidth
    tmp(1:end-n+1,n)=data(n:end);
end

smooth_data=nanmedian(tmp(2:end-kernelwidth+1,:),2);
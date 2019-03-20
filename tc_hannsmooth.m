function [smooth_data]=tc_hannsmooth(data, hannwidth)
%% [smooth_data]=tc_mediansmooth(data,hannwidth)
%
% median filter to smooth one-dimensional data
%
% Input:
%   data: one-dimensional data
%   hannwidth: width of the smoothing kernel in data points
%
% Ouput: smoothed data

if size(data,1)>1 && size(data,2)>1
    error('only one-dimensional data is supported')
elseif size(data,2)>1 && size(data,1)==1 % speeds up the computation later on
    data=data';
end

hannWindow=hann(hannwidth)';

padd_beg=ceil(hannwidth/2); % to avoid 0 indexing if hannwidth = 1
padd_end=floor(hannwidth/2); % compensate for above, when odd kernelwidths were chosen

data=[nan(padd_beg,1);data;nan(padd_end,1)]; % padding the data with NaN to allow filter transition on edges

tmp=nan(max(size(data)),hannwidth);

for n=1:hannwidth
    tmp(1:end-n+1,n)=data(n:end);
end
tmp(isnan(tmp))=0;
smooth_data=tmp*hannWindow;



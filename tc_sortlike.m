function [sorted_a, I] = tc_sortlike(a, b, varargin)
%% [sorted, I] = tc_sortlike(a, b)
%
% Sort array a like array b
sort_order = 'ascend';

if ~isempty(varargin)
    sort_order = varargin{1};
end

[~, I] = sort(b, sort_order);
[~, I] = sort(I);
[~, I2] = sort(a);
I = I2(I);

sorted_a = a(I);
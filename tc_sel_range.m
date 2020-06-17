function inds = tc_sel_range(vector, limits)
%% inds = tc_sel_range(limits, vector)
% Selects a range of limits = [lower upper] of all values in vector.
%
% example:
%
% vector = [-2, -1, 0, 1, 2, 3, 4, 5];
% limits = [-1 3];
%
% >> tc_sel_range(limits, vector)
% ans =
%
%  1x8 logical array
%
%   0   1   1   1   1   1   0   0
inds = vector >= limits(1) & vector <= limits(2);
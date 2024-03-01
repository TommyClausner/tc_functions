function rankvals = tc_rankvalue(data, varargin)
%% rankvals = tc_rankvalue(data)
%
% or
%
% rankvals = tc_rankvalue(data, direction)
%
% direction can be 'ascend' or 'descend';
if ~isempty(varargin)
    sort_dir = varargin{1};
else
    sort_dir = 'ascend';
end

[~, ~, rankvals]=unique(data);
rankvals = reshape(rankvals, size(data));
if strcmpi(sort_dir, 'descend')
    rankvals = max(rankvals) - rankvals + 1 ;
end

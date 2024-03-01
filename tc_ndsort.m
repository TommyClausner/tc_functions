function [B, I] = tc_ndsort(A, varargin)
%% [B, I] = tc_ndsort(A, varargin)
% Sorts multi dimensional data by treating values of each dimension as
% coordinates. The overall lowest value in the data will be subtracted,
% such that the origin of the coordinate system is at 0 for each dimension.
% The sorting of A is achieved by sorting the distances relative to the 
% origin of the coordinate system. A must be of shape N x D.
if ~isempty(varargin)
    sorting = varargin{1};
else
    sorting = 'ascend';
end

% euclidean distance to origin
[~, I] = sort(sum((A - min(A(:))).^2, 2).^.5, sorting);
B = A(I, :);
end
function split_data = tc_split_array(data, parts, varargin)
%% function split_data = tc_split_array(data, parts, partsel)
%
% Splits 2D array along first dimension into 'parts' mostly evenly sized 
% parts.
%
% example:
% data = rand(100, 10);
% split_data = tc_split_array(data, 10)
%
% Splits array into 10 parts of size 10x10
%
% Specify additional integer <= 'parts' to select a specific part to be
% returned.
%
% example:
% split_data = tc_split_array(data, 10, 3)
%
% Splits array into 10 parts of size 10x10 and returns the 3rd part.

size_array = size(data, 1);
ind_sel = 1:size_array;

elements_per_part = floor(size_array / parts);
part_array=ones(1, parts) * elements_per_part;

rest = size_array - sum(part_array);
if rest > 0
    for n = 1:rest
        part_array(n) = part_array(n) + 1;
    end
end
ind_sel = mat2cell(ind_sel', part_array, 1);

split_data = cellfun(@(ind) data(ind, :) ,ind_sel, 'unif', 0);

if ~isempty(varargin)
    split_data = split_data{varargin{1}};
end

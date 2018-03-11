function [row_ind]=tc_findrowindices(data,values_)
%% [row_ind]=tc_findrowindices(data,values_)
%
% finds the first vector indices in one dimensional clustered data for the respective
% values given in values_
%
% Example:
% [row_ind]=tc_findrowindices([1 1 2 3 3 4 5 5 6 7 7 5 5 8 9 9 10]',[1,5,7])
%
% ans =
%
%  1×3 cell array
%
%    [1]    [2×1 double]    [10]
%
% ans{2}
%
% ans =
%
%      7
%     12

triggers=unique(data);
if isempty(values_)
    values_=triggers;
end
triggers=triggers(ismember(triggers,values_));

trial_onset={};
for n=1:size(triggers,1)
    trial_tmp=find(data==triggers(n));
    trial_tmp=trial_tmp([1;find((trial_tmp(2:end)-trial_tmp(1:end-1))~=1)+1],1);
    trial_onset{1,end+1}=(trial_tmp);
end

row_ind=trial_onset;
end
function cohens_d = tc_cohens_d(data_A, varargin)
%cohens_d = TC_COHENS_D(data_A, varargin)
%
%   Computes effect size for paired or independen samples (Cohen's d).
%
%   cohens_d = TC_COHENS_D(data_A) performs effect size computation for a 
%   single against 0.
%   
%   cohens_d = TC_COHENS_D(data_A, data_B) performs effect size computation 
%   for two indepenend samples. 
%
%   cohens_d = TC_COHENS_D(data_A, data_B, 'paired') performs effect size 
%   computation for two paired samples. 
%
%   Note: according to Cohen and Sawilowsky:
%
%      d = 0.01  --> very small effect size
%      d = 0.20  --> small effect size
%      d = 0.50  --> medium effect size
%      d = 0.80  --> large effect size
%      d = 1.20  --> very large effect size
%      d = 2.00  --> huge effect size
%
%   Copyright 2020 Tommy Clausner (tommy.clausner@gmail.com)

independend_test = 1;

if nargin < 2
   data_B = zeros(size(data_A));
elseif nargin == 2 && ischar(varargin{1})
    data_B = zeros(size(data_A));
    independend_test = isindependend(varargin{1});
elseif nargin == 2 && ~ischar(varargin{1})
    data_B = varargin{1};
elseif nargin == 3
    if ischar(varargin{2})
        data_B = varargin{1};
        independend_test = isindependend(varargin{2});
    else
        data_B = varargin{2};
        independend_test = isindependend(varargin{3});
    end
else
    error('Unrecognized input.')
end

if independend_test
    cohens_d = (nanmean(data_A) - nanmean(data_B)) ./ ...
        sqrt((...
        (numel(data_A)-1).*nanvar(data_A)+(numel(data_B)-1).*nanvar(data_B)) ...
        ./ (numel(data_A) + numel(data_B) - 2));
else
    cohens_d = (nanmean(data_A) - nanmean(data_B)) ./ nanstd(data_A - data_B);
end


function check = isindependend(check)
    if strcmpi(check, 'paired')
        check = 0;
    elseif strcmpi(check, 'independend')
        check = 1;
    else
        error('Unrecognized test. Must be "paired" or "independend"')
    end
end
end
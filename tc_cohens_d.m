function cohens_d = tc_cohens_d(data_A, varargin)
independend_test = 1;

if nargin < 2
   data_B = zeros(size(data_A));
elseif nargin == 2 && ischar(varargin{1})
    data_B = zeros(size(data_A));
    independend_test = isindependend(varargin{1});
elseif nargin == 2 && ~ischar(varargin{1})
    data_B = varargin{2};
elseif nargin == 3
    if ischar(varargin{2})
        data_B = varargin{3};
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
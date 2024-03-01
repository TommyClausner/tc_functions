function [adjusted_h, adjusted_p, adjusted_alpha] = tc_multicomp(p, procedure, alpha)
%%
if nargin < 3; alpha = 0.05;end
if nargin < 2; procedure = 'fdr';end

shape = size(p);
p = p(:);

num_tests = length(p);
cum_num_tests = 1:num_tests;
[sorted_p, I] = sort(p,'ascend');

switch procedure
    case 'fwer'                
        adjusted_p = zeros(shape);
        adjusted_p(I) = min(sorted_p.*fliplr(cum_num_tests)',1);

        adjusted_alpha = zeros(shape);
        adjusted_alpha(I) = alpha./(num_tests+1-cum_num_tests);
        
        adjusted_h = zeros(shape);
        adjusted_h(I) = adjusted_p < alpha;  
        
    case 'fdr'
        p_scale = num_tests./cum_num_tests;
        a_scale = cum_num_tests./num_tests;

        adjusted_p = zeros(shape);
        adjusted_p(I) = sorted_p'.*p_scale;

        adjusted_alpha = zeros(shape);
        adjusted_alpha(I) = alpha.*a_scale;

        adjusted_h = adjusted_p < adjusted_alpha;
end


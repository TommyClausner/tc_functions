function out = tc_changem(in, new, old)
%tc_changem mimics functionality of changem
%
%   Replaces each value k of "old(k)" in "in" with "new(k)"
%
%   out = tc_changem(in, new, old)

%%
out = in;
for k = 1:numel(old)
    out(in == old(k)) = new(k);
end


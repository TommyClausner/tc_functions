function out = tc_set_to_unknown(a, dim, ind, val)
S.subs = repmat({':'},1,ndims(a));
S.type = '()';
S.subs{dim} = ind;
out = subsasgn(a,S, val);
function out = tc_get_from_unknown(a, dim, ind)
S.subs = repmat({':'},1,ndims(a));
S.type = '()';
S.subs{dim} = ind;
out = subsref(a,S);
function l = tc_link_corr_clust(l, link_dim)
%%
for ind = 1:size(l, link_dim)-1
    ref_slice = tc_get_from_unknown(l, link_dim, ind);
    next_slice = tc_get_from_unknown(l, link_dim, ind + 1);
    
    same_val_slice = (next_slice > 0) == (ref_slice > 0);
    same_val_slice(next_slice == 0) = 0;
    
    tmp = tc_get_from_unknown(l, link_dim, ind+1:size(l, link_dim)) + 1;
    tmp(tc_get_from_unknown(l, link_dim, ind+1:size(l, link_dim))==0) = 0;
    
    l = tc_set_to_unknown(l, link_dim, ind+1:size(l, link_dim), tmp);
    
    tmp = tc_get_from_unknown(l, link_dim, ind + 1);
    tmp(same_val_slice) = ref_slice(same_val_slice);
    
    l = tc_set_to_unknown(l, link_dim, ind+1, tmp);
end
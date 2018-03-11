function [hook_pos_out]=tc_polydiscretize(initvertices,order,num_discr)
%%
num_hooks=num_discr;
coord_vertices=initvertices;
k = order;
edge_lengths=sqrt((coord_vertices(k(1:end-1),1)-coord_vertices(k(2:end),1)).^2+(coord_vertices(k(1:end-1),2)-coord_vertices(k(2:end),2)).^2);
edge_lengths=edge_lengths./sum(edge_lengths);
hooks_per_edge=round(num_hooks.*edge_lengths);
if sum(hooks_per_edge)~=num_hooks
    num_diff=abs(num_hooks-sum(hooks_per_edge));
    rand_sel=randperm(size(hooks_per_edge,1));
    rand_sel=rand_sel(1:num_diff);
    hooks_per_edge(rand_sel)=hooks_per_edge(rand_sel)+(num_hooks-sum(hooks_per_edge))./num_diff;
end

hook_pos=zeros(num_hooks,2);
tmp_ind=[1;cumsum(hooks_per_edge)];
tmp_ind(2:end)=tmp_ind(2:end)+1;
for n=1:size(k,1)-1
x=linspace(min(coord_vertices(k(n),1)),max(coord_vertices(k(n+1),1)),hooks_per_edge(n));
y=linspace(min(coord_vertices(k(n),2)),max(coord_vertices(k(n+1),2)),hooks_per_edge(n));
hook_pos(tmp_ind(n):tmp_ind(n+1)-1,:)=[x',y'];
end
hook_pos_out=hook_pos;
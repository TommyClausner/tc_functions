function [voxel_list_expanded]=tc_expandVoxelSelection(dim,voxel_list_to_expand,expand_factors)
%% [voxel_list_expanded]=tc_expandVoxelSelection(dim,voxel_list_to_expand,expand_factors)
% selects voxel around a given set of voxel. E.g. if a 3x3x3 box around 1
% voxel V in a 10x10x10 volume is asked to be selected, then call
% V_new = tc_expandVoxelSelection([10,10,10],V,[3,3,3]);
% V_new will contain 9 indices of the initial volume centering around V

if numel(dim)~=numel(expand_factors) && numel(expand_factors)~=1
    error('Please provide valid expansion vector')
end

if numel(expand_factors)==1
    expand_factors=ones(size(dim))*expand_factors;
end

if numel(dim)==2
    [seedX,seedY]=ind2sub(dim,voxel_list_to_expand);
    add_those=repmat(combvec(-expand_factors(1):1:expand_factors(1),-expand_factors(2):1:expand_factors(2)),1,size(voxel_list_to_expand,2));
    inds=repmat([seedX;seedY],1,size(add_those,2)/size(voxel_list_to_expand,2))+add_those;
elseif numel(dim)==3
    [seedX,seedY,seedZ]=ind2sub(dim,voxel_list_to_expand);
    
    % compute all possible deviations from the center voxel
    add_those=repmat(combvec(-expand_factors(1):1:expand_factors(1),-expand_factors(2):1:expand_factors(2),-expand_factors(3):1:expand_factors(3)),1,size(voxel_list_to_expand,2));
    
    % add all those combinations
    inds=repmat([seedX;seedY;seedZ],1,size(add_those,2)/size(voxel_list_to_expand,2))+add_those;
else
    error('please provide valid dimensions')
end

for n=1:numel(dim)
    inds(n,inds(n,:)>dim(n))=dim(n);
end
inds(inds<1)=1;

if numel(dim)==2
    voxel_list_expanded=sub2ind(dim,inds(1,:),inds(2,:));
else
    voxel_list_expanded=sub2ind(dim,inds(1,:),inds(2,:),inds(3,:));
end

function vec_=tc_combvec(values_,type)
%% vec_=tc_combvec(values_,type)
% computes the MATLAB combvec function
% if type is set to 1, only unidirectional and not equal combinations will
% be returned
if type==1
    
    vec_=combvec(values_,values_);
    vec_(:,1)=[];
    
    a=find(vec_(1,:)==vec_(2,:))-[find(vec_(1,:)==vec_(2,:))./min(find(vec_(1,:)==vec_(2,:)))];
    b=find(vec_(1,:)==vec_(2,:));
    
    c=cell2mat(arrayfun(@(x) a(x):b(x),1:size(a,2),'Unif',0));
    
    vec_(:,c)=[];
else
    
    vec_=combvec(values_,values_);
    
end
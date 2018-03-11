function [indices]=tc_dataIndex(column_,value,data)
%% [indices]=tc_dataIndex(column_,value,data)
% can be used to select rows of tables, by findings value combinations in
% the columns
%
% e.g. A=[1,'a',4;1,'b',4;2,'c',2]; tc_dataIndex(column_,value,data)

ind_=0;
for m=length(column_)
for n=length(value{m})
ind_=ind_+data(:,column_(m))==value{m}(n);
end
ind_(ind_>0)=ind_(ind_>0)+1;
end
indices=(ind_==max(ind_(:)) & ind_>0);
end
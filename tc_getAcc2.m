function [Acc] = tc_getAcc2( real,model )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

count=0;
count2=0;
for n=1:size(real,1)

multipl=real(n,1)/model(n,1);

model_tmp=model*multipl;
TransMat(:,n)=model_tmp;
Multipl(:,n)=multipl;

select=n:size(real,1)-1;
%select(:,n)=[];

for m=select
count=count+1;
AccMat(count,1)=1-abs(1-real(m,1)/model_tmp(m,1));

end

for m=select
count2=count2+1;
AccDist(count2,1)=real(m,1)/model_tmp(m,1);

end

end


Acc.AccMean=mean(AccMat);
Acc.DistMean=mean(AccDist);
Acc.AccMat=AccMat;
Acc.DistMat=AccDist;
Acc.AccStd=std(AccMat);
Acc.DistStd=std(AccDist);
Acc.TransMat=TransMat;
Acc.Multipl=Multipl;



end


function [D_trans, inpol]=tc_tetragon2square(V, D)
%% morphs points in D limited by four vertices V into a space limited by 
% 0 and 1 in x and y direction
%

inpol = inpolygon(D(:,1),D(:,2),V(:,1),V(:,2));
% order in quadrants starting with 1
targetPoints=[1,1;0,1;0,0;1,0];

% normalize

D=D./max(V(:));
V=V./max(V(:));

% find closest to any target point
dist_=pdist2(targetPoints,V);

order=zeros(4,1);

for n=1:4
[~,I]=min(dist_,[],2);
order(n)=I(n);
dist_(:,I(n))=99;
end

V_ordered=V(order,:); % order like targetPoints (points closest to target)

% fit linear functions for boundaries
coefficients = polyfit([V_ordered(1,1), V_ordered(2,1)], [V_ordered(1,2), V_ordered(2,2)], 1);
beta1 = coefficients (1);
m1 = coefficients (2);

coefficients = polyfit([V_ordered(3,1), V_ordered(4,1)], [V_ordered(3,2), V_ordered(4,2)], 1);
beta2 = coefficients (1);
m2 = coefficients (2);

linFct1=@(x) beta1*x+m1;
linFct2=@(x) beta2*x+m2;

coefficients = polyfit([V_ordered(2,1), V_ordered(3,1)], [V_ordered(2,2), V_ordered(3,2)], 1);
beta3 = coefficients (1);
m3 = coefficients (2);

coefficients = polyfit([V_ordered(1,1), V_ordered(4,1)], [V_ordered(1,2), V_ordered(4,2)], 1);
beta4 = coefficients (1);
m4 = coefficients (2);

linFct3=@(y) (y-m3)/beta3;
linFct4=@(y) (y-m4)/beta4;

% scale distance between linear functions from 0 to 1
multY=@(x) 1/(linFct1(x)-linFct2(x));
multX=@(y) 1/(linFct4(y)-linFct3(y));

transD=@(D) [(D(1)-linFct3(D(2))) * multX(D(2)),(D(2)-linFct2(D(1))) * multY(D(1))];

% transform data
D_trans=zeros(size(D));

for n=1:size(D,1)
    D_trans(n,:) = transD(D(n,:));
end

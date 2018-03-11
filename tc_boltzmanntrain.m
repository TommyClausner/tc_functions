function [w,T,m_c]=tc_boltzmanntrain(train_data,noise)
% [w,p]=boltzmann(train_data,train_labels,test_data,test_labels,noise)
% Input:    train_data = n x m (dimensions x patterns) having values
%           between 0 and 1
%
%           noise = level of noise to be added (0 - 1)
% Output:   w (weights)
%           T (theta)
%           m_c (clamped average)


P   = size(train_data,2);
N   = size(train_data,1);
X   = train_data;

noise_level=noise;
noiseind=(rand(size(X))>=(1-noise_level));

X(noiseind)=rand(sum(noiseind(:)),1);

C_c = (1/P)*X*X';
m_c = mean(X,2)';

C=C_c-(m_c'*m_c);
w=diag(1./(1-(m_c.^2)))-inv(C);
T=atanh(m_c)-(w*m_c')';

end
function [p]=tc_boltzmanntest(test_data,w,T,m_c)
% [p]=tc_boltzmanntest(test_data,w,T)
% Input:    test_data = n x m (dimensions x patterns)
%           w = weights obtained from tc_boltzmanntrain
%           T = theta obtained from tc_boltzmanntrain
%           m_c (clamped average)
% Output:   log(p) 

X   = test_data;
%m_c=mean(X,2);

w_term=(w*m_c)'*m_c;
theta_term=m_c'*T';
log_term=(1+m_c).*log(0.5.*(1+m_c))+(1-m_c).*log(0.5.*(1-m_c));
F=-0.5.*w_term-theta_term+0.5.*sum(log_term);
theta_term=X'*T';
w_term=sum((w*X).*X);

p=0.5.*w_term+theta_term'+F; %computing log(p)

end
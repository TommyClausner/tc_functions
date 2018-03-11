function [Y,plot_f,P1,t,h]=tc_easyfft(Fs,x)
% [Y,plot_f,P1,t,h]=tc_easyfft(Fs,L,x)
% Input:
% Fs = sampling frequency
% x = data
%
% Output:
% Y = fft(x)
% plot_f = x-axis values
% P1 = y-axis values
% h = plot handle

T = 1/Fs;
L = length(x);
t = (0:L-1)*T; 
Y=fft(x);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

plot_f = Fs*(0:(L/2))/L;
h=plot(plot_f,P1);
end
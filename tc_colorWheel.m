function [x,y,thetag]=tc_colorWheel(nr, ntheta)
%% [x,y,thetag]=tc_colorWheel(nr, ntheta)
r = linspace(0,1,nr);
theta = linspace(0, 2*pi, ntheta);
[rg, thetag] = meshgrid(r,theta);
[x,y] = pol2cart(thetag,rg);
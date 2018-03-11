function [I_out,Co_out]=tc_colorcluster(I,thresh)
%% [I_out,Co_out]=tc_colorcluster(I,thresh)
%
% Example
% clc
% clear
% close all
% [I_out,Co]=tc_colorcluster(imread('~/Desktop/Unbenannt-1.jpg'),15);

if size(size(I),2)>2
    I=rgb2gray(I);
end
subplot(121)
imshow(I)
U=double(unique(I));

C=bwlabel((U(2:end)-U(1:end-1))<=thresh);
C(end+1)=0;
Cv=unique(C(C~=0));
C(C==0)=Cv;

Co=arrayfun(@(x) mean(U(C==x)),Cv);

for n=Cv'
    I(ismember(I,U(C==n)))=Co(n);
end

subplot(122)
imshow(I)
suptitle(['reduced ' num2str(size(U,1)) ' colors to ' num2str(size(Cv,1)) ' colors'])

I_out=I;
Co_out=round(Co)./255;
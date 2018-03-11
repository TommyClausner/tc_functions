function wavelet_=tc_wavelet(freq,samples,varargin)
%% wavelet_=tc_wavelet(freq,samples,varargin)
% creates Morlet wavelet
%
% varargin{1}=center of gaussian
% varargin{2}=std of gaussian
% e.g. wavelet_=tc_wavelet(freq,samples,0,0.25)
carrier_freq=cos(linspace(0,1,samples).*freq.*2.*pi);
if rem(freq,2) %center peak at x=zero in positive direction
    carrier_freq=carrier_freq.*-1;
end
if size(varargin,2)>1
    mean_=varargin{1};
    std_=varargin{2};
elseif size(varargin,2)>0
    mean_=varargin{1};
    std_=0.25;
else
    mean_=0;
    std_=0.25;
end
wavelet_=normpdf(linspace(-1,1,samples),mean_,std_).*carrier_freq; %Gaussian times carrier frequency
end

function [FFT_out]=tc_multiFFT(fieldtrip_struct,xLimit,compute)

%computes fast furier transform for fieldtrip-structure
%for each channel / component / etc.
%
%[FFT_out]=tc_multiFFT(fieldtrip_struct,xLimit,compute)
%
%fieldtrip_struct: fieldtrip strcture containing field 'trial', that has
%channel x time structure; 'fsample'; 'time'
%
%xLimit: maximum frequency that is displayed: xlim([0 xLimit])
%
%compute: variable takes strings 'compute' or 'plot'
%'compute' computes and plots; 'plot' only plots
%
%when specifying 'plot', input must be trial x channel x frequency matrix
%
%FFT_out contains a trial x channel x frequencies matrix
%
%Results are average over trials for plotting
Fs=fieldtrip_struct.fsample;
L=round(abs(fieldtrip_struct.time{1,1}(1)-fieldtrip_struct.time{1,1}(end)).*1000);
T = 1/Fs;
t = (0:L-1)*T;  
f = Fs*(0:(L/2))/L;
if strcmpi(compute,'compute')

data=zeros(size(fieldtrip_struct.trial,2),size(fieldtrip_struct.trial{1,1},1),size(1:L/2+1,2));

for trial=1:size(fieldtrip_struct.trial,2)
    disp(['compute FFT for trial: ' num2str(trial)])
    for channel=1:size(fieldtrip_struct.trial{1,1},1)
    Signal_=fieldtrip_struct.trial{1,trial}(channel,:);
    Y = fft(Signal_);
    P2 = abs(Y/L);
    data(trial,channel,:) = P2(1:L/2+1); 
    data(trial,channel,2:end-1) = 2*data(trial,channel,2:end-1);
    end
end
elseif strcmpi(compute,'plot')
    data=fieldtrip_struct.FFT;
else
    error('please specify whether to compute or plot')
end
fig_ = figure('Units','normalized','Position',[0 0 1 1]);
tgroup = uitabgroup('Parent', fig_);
for tabs=1:ceil(size(data,2)./16)
tab(tabs) = uitab('Parent', tgroup, 'Title', ['Component' num2str((tabs-1).*16+1) ' - ' num2str((tabs-1).*16+16)]);
for n=1:16    
    if (n+(tabs-1).*16)<=size(data,2)
        subplot(4,4,n,'Parent',tab(tabs))
        plot(f,squeeze(mean(data(:,n+(tabs-1).*16,:),1)));
        title(['Component' num2str(n+16.*(tabs-1))])
        xlim([0 xLimit])
        xlabel('frequency f (Hz)')
        ylabel('Power |P(f)|')
    end
end
end

FFT_out=data;

end
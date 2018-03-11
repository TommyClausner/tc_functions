function [ ] = tc_pirelease2dir( varargin )
%tc_pirelease2dir
%
%executes predefined shell scripts on a connected Raspberry Pi
%Raspberry Pi must be connected to the same Wifi network as the host


unix(['arp -a']);
[~,cmdout]=unix('ifconfig |grep ''inet 192.168''');
disp(['Your IP: ' cmdout])
answer = inputdlg('set Raspberry Pi IP','',1,{'192.168.0.19'});

if ~isempty(answer)
if size(sscanf(answer{1,1}, '%d.%d.%d.%d'),1)==4
    
    PI_IP=answer{1,1};
    unix(['ssh pi@' PI_IP ' ./release_camera.py']);
    pause(3)
    unix(['ssh pi@' PI_IP  ' ./get_images.sh']);
    path=[uigetdir('~','select directory to save') filesep];
    unix(['scp -r -nc pi@' PI_IP ':/home/pi/images_from_SLR/tmp/ ' path]);
    else
    error('no valid IPv4 address - type ''help tc_pirelease2dir'' into hte command window for more information')
end


end
end


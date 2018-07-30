function sens = tc_janus3D2sens(pathorfile, include)
%% sens = tc_janus3D2sens(pathorfile, include)
% converts janus3D electrodes into fieldtrip sens
if ischar(pathorfile)
    load(pathorfile)
else
    Electrodes=pathorfile;
end
points=Electrodes.MRI.points(include,:);
label=Electrodes.MRI.label(include,:);

sens=[];
sens.chanpos = points;
sens.chantype = arrayfun(@(x) {'eeg'}, 1:size(points,1))';
sens.chanunit = arrayfun(@(x) {'V'}, 1:size(points,1))';
sens.elecpos = points;
sens.label = label;
sens.unit = 'mm';
sens.tra = eye(numel(label))
end

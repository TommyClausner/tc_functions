function stims_resliced=tc_reslice_vistadisp_stimuli(images, params, stimseq)
%% stims_resliced=tc_reslice_vistadisp_stimuli(images, params, stimseq)
% 
% creates a matrix of stimuli, that can be used as regressor for retinotopy
% analyses. The output matrix will be of size m x n x N, were lower case
% letters are the image dimensions and N is the number of stimuli.

% full scanning duration
duration=params.period+params.prescanDuration;

% number of scans
numscans=duration/params.framePeriod;

% number of pre-scans
numscans_pre=params.prescanDuration/params.framePeriod;

% skip pre-scans
skip_until=numscans_pre*size(stimseq,1)/numscans;

% select all but pre-scan and binarize
stims=images(:,:,stimseq(skip_until+1:end))~=128;

% compute change rate for stimulation in frames
frames_per_unique=size(stims,3)/(numscans-numscans_pre);

% select image regressors
stims_resliced=stims(:,:,1:frames_per_unique:end);

end
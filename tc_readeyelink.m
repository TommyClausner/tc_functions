function [data_out]=tc_readeyelink(pathraw, varargin)
%% [data_out]=tc_readeyelink(pathraw, varargin)
% Input:
% pathraw: Path to the eye link .txt file as exported from the eye link software
% varargin: name(s) of the column(s) that need to be extracted (e.g.'SAMPLE_INDEX','SAMPLE_INPUT','LEFT_GAZE_X')
% the last input argument must be a cell array specifying the format specs
% of the input file (e.g. {'%s %f %f %f %f %f %f %f %f %f %f'})
% 
% Example:
% [data_out]=tc_readeyelink('~/eyelink.txt','SAMPLE_INDEX','SAMPLE_INPUT','LEFT_GAZE_X','LEFT_GAZE_Y','LEFT_IN_BLINK','LEFT_IN_SACCADE',format_spec_orig_file_col)
%
% Output:
% data_out: nxc matrix of n datapoints for c selected columns. Columns are
% sorted according to the input variables
% header_out: name of the selected columns

if size(varargin,2)<1 % check if any column was selected
    error('no columns selected')
end
tic
format_spec_orig_file_col=varargin{end};

disp(['processing ' pathraw])

delimiter = sprintf('\t',''); % set column delimiter
fid = fopen([pathraw],'rt');
numCols=sum(format_spec_orig_file_col{1}=='%');
header_string=repmat('%s ',1,numCols);
header_string=header_string(1:end-1);
header_string=textscan(fid, header_string, 1);
data_raw=textscan(fid,format_spec_orig_file_col{1},'HeaderLines', 1,'EmptyValue',NaN,'delimiter',delimiter,'TreatAsEmpty',{'.'});
fclose(fid);
data=[];
for n=1:size(varargin,2)
    sel_col=cell2mat(cellfun(@(x) strcmpi(x,varargin{n}),header_string,'unif',0));
    sel_col=find(sel_col);
    data=[data data_raw(:,sel_col)];
end

data_out=cell2mat(data);
disp(['time consumed ' num2str(toc) 's'])
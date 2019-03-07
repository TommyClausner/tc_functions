function tc_save(filename,varargin)
%% tc_save(filename,varargin)
%
% saves versions of a file by checking the existance and incrementing a
% version number by 1 or overwriting the version specified afterwards,
% using '-<number>'
% where '-0' corresponds to a filename without version number and '-Inf' to the
% latest
%
% As last the matlab file version can be specified. E.g. '-v7.3'
%
% example:
%
% tc_save(filename,'myvar')
%   saves without version number if the file does not exist, otherwise
%   increments by 1
%
% tc_save(filename,'myvar','-4')
%   overwrites version 4
%
% tc_save(filename,'myvar','myothervar','-0','-v7.3')
%   overwrites file without version number in matlab file version 7.3
%
% tc_save(filename,'myvar','-Inf')
%   ovwerwrites the highest existing number

useOriginalFileName=0;
useLatestVersionNumber=0;
useThisVersionNumber=0;

% check if matlab file version was provided
if strcmp(varargin{end}(1:2),'-v')
    matlabFileVersion=varargin{end};
    minusFromEnd=1;
else
    matlabFileVersion='';
    minusFromEnd=0;
end

versionSet=varargin{end-minusFromEnd};

% check if file version was provided
if strcmp(versionSet(1),'-')
    versionToBeUsed=str2double(versionSet(2:end));
else
    versionToBeUsed=NaN;
end

% check which file version was provided (first, last or specific)
if ~isnan(versionToBeUsed)
    var=strjoin({varargin{1:end-1-minusFromEnd}},"','");
    if versionToBeUsed==0
        useOriginalFileName=1;
    elseif versionToBeUsed==Inf
        useLatestVersionNumber=1;
    else
        useThisVersionNumber=versionToBeUsed;
    end
else
    var=strjoin({varargin{1:end-minusFromEnd}},"','");
end

if isempty(dir(filename)) || useOriginalFileName
    
    % if file doesn't already exist, just save it
    evalin('base', "save('" + filename + "', '"+var+"', '"+matlabFileVersion+"');");
else
    
    % if file exist, check multiple versions
    filename=[filename(1:end-4) '*.mat'];
    allFiles=dir(filename);
    
    % find max version number
    maxVersionNumber=max(cell2mat(cellfun(@(x) str2double(regexp(x,'\d*','Match')),{allFiles.name},'unif',0)));
    
    % if no version number was added so far assume '0'
    if isempty(maxVersionNumber)
        maxVersionNumber=0;
        newFileName=filename(1:end-5);
    else
        newFileName=strsplit(filename,'*.mat');
        newFileName=newFileName{1};
    end
    
    newVersionNumber=maxVersionNumber+1;
    
    % overwrite highest version number
    if useLatestVersionNumber
        newVersionNumber=newVersionNumber-1;
    end
    
    % overwrite specific version number
    if useThisVersionNumber~=0
        newVersionNumber=useThisVersionNumber;
    end
    
    if newVersionNumber==0
        newFileName=[newFileName '.mat'];
    else
        newFileName=[newFileName num2str(newVersionNumber) '.mat'];
    end
    
    evalin('base', "save('"+newFileName+"', '"+var+"', '"+matlabFileVersion+"');");
end
end
function wsStruct=tc_ws2struct(ws,varargin)
%%
% usage:
%
% wsStruct = tc_ws2sruct(ws, varargin);
%
% returns a structure from all workspace variables in workspace ws (e.g. 'base').
%
% value pairs:
%
% 'MaxVarSize', value only include variables smaller than value (in byte)
% 'Exclude', 'ans' include all variables except 'ans'
% 'Include', {'thisVar', 'andThat'} include only defined variables
%
% note that the inclusion hierarchy is according to the order in which the 
% arguments were provided.

% get workspace variable information
wsVars=evalin(ws,'whos');

% prepare index vectors for variable inclusion
includeThoseVars=ones(size({wsVars.name}));
includeThoseBasedOnSize=ones(size({wsVars.name}));
excludeThose=zeros(size({wsVars.name}));
includeThose=ones(size({wsVars.name}));

% iterate over key-value pairs
for argNum=1:2:length(varargin)
    
    % get key value pair
    key=lower(varargin{argNum});
    value=varargin{argNum+1};
    
    switch key
        case 'maxvarsize'
            includeThoseBasedOnSize=horzcat(wsVars.bytes)<=value;
        case 'exclude'
            excludeThose=ismember({wsVars.name},value);
        case 'include'
            includeThose=ismember({wsVars.name},value);
            
            % if no matching key was found, but an argument was provided
        otherwise
            error('invalid key value')
    end
end

% combine index vector for variable inclusion
includeThoseVars=(includeThoseVars&includeThoseBasedOnSize&~excludeThose&includeThose)>0;

% obtain selected workspace variable names
wsVars={wsVars.name};
wsVars=wsVars(includeThoseVars);

% obtain workspace variable values
wsVarsValues=cellfun(@(x) {evalin(ws,x)},wsVars,'unif',0);
wsStruct=[wsVars',wsVarsValues'].';

% make struct from name-value pairs
wsStruct=struct(wsStruct{:});

end
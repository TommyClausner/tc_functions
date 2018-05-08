function timeRemain=tc_toc(varargin)
%% timeRemain=tc_toc(varargin)
% input as name value pairs
%
% 'tic', instance of tic
%
% 'process', [currentCounter, numberOfSteps]
% 
% example: timeRemain = tc_toc('tic',ticInstance, 'process',[5,100])
%
% -> will estimate, based on the current process step (5 of 100) how much
% time can be expected to be remaining (in seconds).
ticSet=0;
procSet=0;
if numel(varargin)==0
    toc
else
    for n=1:2:numel(varargin)
        switch varargin{n}
            case 'tic'
                ticSet=1;
                ticID=n+1;
            case 'process'
                procSet=1;
                procID=n+1;
        end
    end
    
    if ticSet && procSet
        timeRemain=toc(varargin{ticID})/varargin{procID}(1)*varargin{procID}(2)-toc(varargin{ticID});
    elseif ticSet && ~procSet
        toc(varargin{ticID})
    elseif ~ticSet && procSet
        timeRemain=toc/varargin{procID}(1)*varargin{procID}(2)-toc;
    else
        error('invalid name value pairs')
    end
end

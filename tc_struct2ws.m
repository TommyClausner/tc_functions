function tc_struct2ws(ws,matlabStruct)
    %% tc_sruct2ws(struct,ws)
    % creates variables from structure in workspace ws
    varNames=fieldnames(matlabStruct);
    for n = 1:length(varNames)
        eval(['tmpVar=matlabStruct.' varNames{n} ';']);
        assignin(ws,varNames{n},tmpVar);
    end
end
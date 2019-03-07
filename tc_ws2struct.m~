function wsStruct=tc_ws2struct(ws)
    %% fieldsAndValues=tc_ws2sruct(ws)
    % returns a structure from all workspace variables in workspace ws,
    % except for 'ans'
    wsVars=cellfun(@(x) {evalin(ws,x)},evalin(ws,'who'),'unif',0);
    wsStruct=[evalin(ws,'who'),wsVars].';
    wsStruct=struct(wsStruct{:});
    wsStruct=rmfield(wsStruct,'ans');
end
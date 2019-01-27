function index = tc_ftChannel2Index(origLabels, ftLabels)
%% index = tc_ftChannel2Index(origLabels, ftLabels)
index=ones(size(origLabels));
indexEx=cellfun(@(toExclude) find(cellfun(@(fromExclude) strcmpi(strip(fromExclude,''''),strip(toExclude(2:end),'''')),origLabels)),ftLabels,'unif',0);
indexEx=cell2mat(indexEx(~cellfun(@isempty,indexEx)));
index(indexEx)=0;

end
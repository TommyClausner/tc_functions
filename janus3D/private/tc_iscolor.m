function [ logical_out ] = tc_iscolor( color )

%[ logical ] = tc_iscolor( color )
%
%tests if color is a valid MATLAB color value
color=lower(color);
logical_out=(isnumeric(color) && (sum(size(color)==[1 3])==2 || ...
    sum(size(color)==[3 1])==2) && sum((color<=[1 1 1] & ...
    color>=[0 0 0]))==3) || sum(strcmpi({'y','m','c','r','g','b','w','k',...
    'yellow','magenta','cyan','red','green','blue','white','black'},color))>0;
end



function [varargout]=tfig
%% [varargout] = tfig
%  creates a white full screen figure
handle=figure('Color',[1, 1, 1],'Units','normalized','Position',[0 0 1 1]);
if nargout>0
    varargout = {handle};
end
end
function [h]=tc_errorbar(varargin)
%% [h,l]=tc_errorbar(Y,E)
% [h,l]=tc_errorbar(X,Y,E)
%
% [h,l]=tc_errorbar([],Y,E,C)
% [h,l]=tc_errorbar(X,Y,E,C)

input_det=sum(cellfun(@(x) isnumeric(x), varargin));
color_=[.3 .3 .3];
if input_det>2 && ~isempty(varargin{1})
    x=varargin{1}';
    y=varargin{2}';
    dy=varargin{3}';
    if max(size(varargin))>3
        color_=varargin{4};
    end
    hold on
    h=fill([x;flipud(x)],[y-dy;flipud(y+dy)],color_,'linestyle','none','facealpha',0.5); 
    line(x,y,'color',color_,'Linewidth',2);
else
    if isempty(varargin{1})
        y=varargin{2};
        x=(1:max(size(y)))';
        dy=varargin{3};
    else
        y=varargin{1};
        x=(1:max(size(y)))';
        dy=varargin{2}';
    end
    if max(size(varargin))>3
        color_=varargin{4};
    end
    hold on
    h=fill([x;flipud(x)],[y-dy;flipud(y+dy)],color_,'linestyle','none','facealpha',0.5);
    line(x,y,'color',color_,'Linewidth',2);
end
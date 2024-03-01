function rgb = tc_cmap2rgb(cmap, cdata, varargin)
if numel(varargin) > 0
    cmin = varargin{1}(1);
    cmax = varargin{1}(2);
else
    cmin = min(cdata(:));
    cmax = max(cdata(:));
end

index = floor((cdata-cmin)/(cmax-cmin)*length(cmap) + 1);
rgb = ind2rgb(index,cmap);
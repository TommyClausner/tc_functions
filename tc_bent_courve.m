function [x_out, y_out] = tc_bent_courve(x, y, varargin)
interp_points = 100;
width = 1;
amplitude = 1;

if ~isempty(varargin)
    if ~ischar(varargin{1})
        vararginds = 2:2:length(varargin);
    else
        vararginds = 1:2:length(varargin);
    end
else
    vararginds = [];
end

for varargind = vararginds
    switch varargin{varargind}
        case 'interp_points'
            interp_points = varargin{varargind + 1};
        case 'width'
            width = varargin{varargind + 1};
        case 'amplitude'
            amplitude = varargin{varargind + 1};
    end
end

curve = (1-cos(linspace(0, pi, interp_points)))./2;

y_out = (y(:, 1) + (y(:, 2) - y(:, 1)).*repmat(curve, size(y, 2), 1))';

x_out = cell2mat(arrayfun(@(t) linspace(x(t, 1), x(t, 2), interp_points), 1:size(x, 1), 'UniformOutput', false)')';
end 
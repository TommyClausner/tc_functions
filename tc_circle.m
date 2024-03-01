function [f, e] = tc_circle(center, r, color, edgecolor)
x_circle = r * cos(0:pi/50:2*pi) + center(1);
y_circle = r * sin(0:pi/50:2*pi) + center(2);
hold on
e = plot(x_circle, y_circle, 'color', edgecolor);
f = fill(x_circle, y_circle, color);
hold off
function PlotCircle2(xc, yc, r ,P, c)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[X, Y] = cylinder(r, 100);
axis equal
hold on
plot(X(1,:) + xc, Y(1,:) + yc, c, 'LineWidth', 1)

end



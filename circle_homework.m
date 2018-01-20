% Paula Kochañska
% Photonics
% Faculty of Physics
% 17.01.2018

clear all;
load('input_circle.mat'); %loading variable
imagesc(circ1);
title('Input data');

% first solution
[row col] = find(circ1);
P = [col row];
B = [(P.*P) * [1 1]',P, ones(length(P),1)];

% svd decomposition
[U, S, V] = svd(B);

% przek¹tna macierzy s
d = diag(S);

% wasrtosci wspolczynnikow a, bx, by i c
res1 = V(:, find(d==min(d)));

a = res1(1);
b1 = res1(2);
b2 = res1(3);
c = res1(4);

% wspolczynniki okrêgu
x1 = -b1/(2*a);
x2 = -b2/(2*a);
radius = sqrt((b1*b1+b2*b2)/(4*a*a) - c/a);

% wysowanie okrêgu
figure;
plotcircle(x1, x2, radius, P, '-r');
title('First method - analytic')

% metoda gaussa-newtona, pierwsze przybli¿enie to to, co ju¿ policzyliœmy w
% poprzedniej analitycznej metodzie
res2 = [x1; x2; radius];
%res = [0; 0; 2];
% minimalizacja dystansu geometrycznego

% R- residua
% J- jakobian

max_iters = 20;
max_diff = 10^(-6);

for i = 1:max_iters
    J = Jacobian(res2, P);
    R = Residual(res2, P);
    
    prev = res2;    
    res2 = res2 - J\R;
    % wzgledna roznica
    diff = abs((prev - res2)./res2);
    if diff < max_diff
        i
        break 
    end
end
figure;
plotcircle(res2(1), res2(2), res2(3), P, '-g');
title('Second method - Gauss-Newton')

% ostatnia metoda
% linearized geometric approach
[n, m] = size(P);

b = [P, ones(n, 1)];
x = (P.*P)*[1, 1]';
z = b\x;
xc = z(1)/2;
yc = z(2)/2;
r = sqrt(z(3)+xc^2 + yc^2);
figure;
plotcircle(xc, yc, r, P, '-b');
res3 = [xc; yc; r];
title('Third method - linearized geometric')


% HOMEWORK

figure;
title('Methods comparision')
hold on;

% cut part of the circle
P = P(P(:,1)<60,:);
B = [(P.*P) * [1 1]',P, ones(length(P),1)];

[U,S,V] = svd(B);
d= diag(S);
res = V(:, find(d == min(d)));
a = res(1); b1 = res(2); b2 = res(3); c = res(4);
xc = - b1./(2*a); yc = - b2./(2*a);
r = sqrt((b1^2 + b2^2)./( 4 * a.^2) - c./a )';

% first method - analytical
plotcircle(xc, yc, r ,P,'-b');

Res = [xc, yc, r];
Res = Res';
max_iters = 20;
max_dif = 10 ^(-6);
for i = 1 : max_iters
    J = Jacobian(Res,P);
    R = Residual(Res,P);
    
    prev = Res;
    Res = Res - J\R;
    dif = abs((prev - Res)./Res);
    if dif < max_dif
        break
    end 
end

% Second method
xc = Res(1);
yc = Res(2);
r = Res(3);
    
[X, Y] = cylinder(r, 100);
axis equal
hold on
plot(X(1,:) + xc, Y(1,:) + yc, '-y', 'LineWidth', 1)
    
[n,m] = size(P); 
B =[P, ones(n,1)];
x = (P.*P) * [1 1]';
z = B\x;

xc = z(1)./2;
yc = z(2)./2;
r = sqrt(z(3) + xc^2 + yc^2);

% Third method
[X, Y] = cylinder(r, 100);
axis equal
hold on
plot(X(1,:) + xc, Y(1,:) + yc, '-r', 'LineWidth', 1)
legend('Cut data', '1st method','2nd method', '3rd method')

% Proper chosing set of data stongly influences accuracy of used methods. 
% When cut part of the circle is small then those methods very much differ
% from each other. For the shole part of the circle methods provide almost
% identical solutions. 
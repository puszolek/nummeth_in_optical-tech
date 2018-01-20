%Tomasz Zalewski 16.01.18
%Circle Fit to the cirlce from previous part of the exercise
clear all;
load('Circ1.mat'); %loading variable
imagesc(circ1);
title('Circ1 Input circle');

%I solution
%Finding the indexes of detected points
[row col] = find(circ1);
P = [col row]; %Vector of raw data
%P = P(P(:,1)<20,:)
B = [(P.*P) * [1 1]',P, ones(length(P),1)]; %Matrix B, from slide

%Decomposition svd
[U,S,V] = svd(B);

d= diag(S);
res = V(:, find(d == min(d)));
%Parameters from slide
a = res(1);
b1 = res(2);
b2 = res(3);
c = res(4);

xc = - b1./(2*a);
yc = - b2./(2*a);

r = sqrt((b1^2 + b2^2)./( 4 * a.^2) - c./a )';
figure;
PlotCircle(xc, yc, r ,P,'-r');
title('I method algebraic')

%Part II
%Minimizing the geometric distance 
%x1c = x, x2c = y
%Beta = [xc, yc, r]
%First solution from previous method
%[xc, yc, r]
Res = [xc, yc, r];
Res = Res';

%For different start conditions this works badly. Good Estimation of the
%initial conditions is critical in obtaing correct covergence. 
    %Res = [0;2;3 ] %- dziala gorzej
max_iters = 20;
max_dif = 10 ^(-6);

for i = 1 : max_iters
    J = Jacobian(Res,P); %Jacobian(xc,yc coordinates)
    R = Residual(Res,P); %
    
    prev = Res;
    Res = Res - J\R; %Main iteration

    dif = abs((prev - Res)./Res); %Abs from relative difference
    if dif < max_dif
        break
    end 
end
    figure;
    PlotCircle(Res(1), Res(2), Res(3) ,P,'-r');
    title('II method Minimizing the geometric distance ')
    
    %Part III
%Linearized geometric approach
%B*z = x

[n,m] = size(P); 
B =[P, ones(n,1)];
x = (P.*P) * [1 1]';
z = B\x;
%In this case problem cannot be solved completly - only analitical solution
%is possible (in fact in only one step). It is better than first, algebraic
%method. It is specific compromise. It works worse in case of optimisation,
%however it is much easier to calculate and solution is more stable.

xc = z(1)./2;
yc = z(2)./2;
r = sqrt(z(3) + xc^2 + yc^2);
figure;
PlotCircle(xc, yc, r ,P,'-r');
title('III Method Linearized geometric approach')

%For many points, as in this case all methods works very well. There are no
%recognizable differences between them. 

%In case for small part of data 
figure;
title('Method comparision ')
hold on;
    PlotCircle2(Res(1), Res(2), Res(3) ,P,'-g');

    %____________________________________________-
    %Here filtration part, critical in this section
%P = P(P(:,1)<45 | P(:,1)>305 ,:) ;  %Filtration from both X sides
P = P(P(:,1)<45,:); %One side filtration

B = [(P.*P) * [1 1]',P, ones(length(P),1)];

[U,S,V] = svd(B);
d= diag(S);
res = V(:, find(d == min(d)));
a = res(1); b1 = res(2); b2 = res(3); c = res(4);
xc = - b1./(2*a); yc = - b2./(2*a);
r = sqrt((b1^2 + b2^2)./( 4 * a.^2) - c./a )';
%first method
PlotCircle(xc, yc, r ,P,'-r');

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
%Second method
    PlotCircle2(Res(1), Res(2), Res(3) ,P,'-y');
    
[n,m] = size(P); 
B =[P, ones(n,1)];
x = (P.*P) * [1 1]';
z = B\x;

xc = z(1)./2;
yc = z(2)./2;
r = sqrt(z(3) + xc^2 + yc^2);
%Third method
    PlotCircle2(xc, yc, r ,P,'-m');
legend('Full data set fit','Cuted data', 'I method','II method', 'III method')

% Solutions depend very much on chosen points, and the data set. Proper set
% of points - points in different regions of circles, for example for both
% sides (Example of filtration above in the comment) are giving good
% results for all methods. However if the data set is only in one art of
% the circle, and points are rather close to itself all three algorithms
% have problems. Their covergance to good solution is rather similar.
% However it should be noticed that II algorithm uses I algorithm as a
% initial condition. So if I-st algorithm solution is bad it inlfuence on
% II algorithm solution. 
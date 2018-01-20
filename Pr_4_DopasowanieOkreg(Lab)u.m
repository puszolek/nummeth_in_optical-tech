P = [1 7; 2 6; 5 8; 7 7; 9 5; 3 7]; %Macierz wejsciowa
P'; %transpozycja
B = [(P.*P) * [1 1]',P, ones(6,1)]; %Macierz B tak jak na slajdzie z czynnikiem kwadratowym 

%Dekompozycja svd
[U,S,V] = svd(B);

d= diag(S);
res = V(:, find(d == min(d)));

% do policzenia promien i srodek okregu
% na slajdach te nazwy 
a = res(1);
b1 = res(2);
b2 = res(3);
c = res(4);

xc = - b1./(2*a);
yc = - b2./(2*a);

r = sqrt((b1^2 + b2^2)./( 4 * a.^2) - c./a )';

%PlotCircle(xc, yc, r ,P,'-r');

%Czesc II

%Minimizing the geometric distance 
%x1c = x, x2c = y
%Beta = [xc, yc, r]
%Potrzebne jest pierwsze przybli�enie - bierzemy to z poprzedniej metody
%[xc, yc, r]
Res = [xc, yc, r];
Res = Res';

% Inne warunki poczatkowe 
    %Res = [0;2;3 ] %- dziala gorzej
%Trzeba znac dobre oszacowanie warunkow poczatkowych, by uzyskac poprawna
%zbie�no��. 

max_iters = 20;
max_dif = 10 ^(-6);



for i = 1 : max_iters
    J = Jacobian(Res,P); %Jacobian(xc,yc, wspolrzedne punktow)
    R = Residual(Res,P); %
    
    prev = Res;
    Res = Res - J\R; %Glowna iteracja chcemy zamknac to w petl
    
   % PlotCircle(Res(1), Res(2), Res(3) ,P,'-r');
    dif = abs((prev - Res)./Res); %Abs z  wzglednej roznicy
    if dif < max_dif
        break
    end 
end


%Czesc III
%Linearized geometric approach
%B*z = x

[n,m] = size(P); 
B =[P, ones(n,1)];
x = (P.*P) * [1 1]';
z = B\x;
%Zagadnienie nie do konca rozwiazane scisle, ale mozna bylo otrzymac je
%analitycznie i w jednym kroku. Jest tez na pewno lepsze od rozwiazania
%algebraicznego. Jest to swoisty kompromis - gorzej pod k�tem
%optymalizacji, ale mo�na policzy� to pro�ciej i bardziej stabilnie. 
xc = z(1)./2;
yc = z(2)./2;
r = sqrt(z(3) + xc^2 + yc^2);
PlotCircle(xc, yc, r ,P,'-r');

%W domu na za 2 tygodnie
% Wzi�� kt�rykolwiek z obraz�w soczewek i spr�bowa� wyznaczy� �rodek okr�gu
% tymi trzema metodami. Po binaryzacji b�dzie kraw�d�, do wyznaczania
% bierzemy wszystkie punkty. Wi�c najpewniej wielkiej r�nicy mi�dzy tymi
% metodami nie bedzie. Zrobi� trzeba wi�c dla ca�ego okr�gu, a p�niej dla
% wycinka. Algabraiczna najpewniej szybko odpadnie, ale sprawdzic kiedy
% zaczyna sie od siebie  roznic liniowa i nieliniowa.  

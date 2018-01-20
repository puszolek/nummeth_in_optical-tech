%Project 2 lenses Tomzal 06.12.17
clear all;
load('NMiOT_po_autofocusingu.mat');

plot(unph(:,420));
%imagesc(unph);
%bin = imbinarize(unph); %progowanie metoda Otsu 
imagesc(unph);
%Wykrycie krawedzi - filtr gorno przepustowy np Sobel'a
%filtr drugiej pochodnej Laplacian of Gaussian LOG
%lub dog - difference of gaussian

BW = im2bw(unph);
%dog = imgaussfilt(unph);


imagesc(BW);
BW = edge(BW,'log');

gaussianSize = 30;
gaussSigma = gaussianSize/3;
gaussKernel = fspecial('gaussian', gaussianSize , gaussSigma);

gaussKernel2 = fspecial('gaussian', 6 , 2);
dog = imfilter(unph,gaussKernel)- imfilter(unph,gaussKernel2);

bin = im2bw(dog);

%Detection of Circles
[centers,radii,metric] = imfindcircles(bin,[152, 163],'Sensitivity', 0.99,'ObjectPolarity','bright');
%zoptymalizowac by byly tylko te co trzeba
imagesc(bin);

%Choosing only one picture
%cf = centers(radii>155,:);
%Specific filtartion to ensure that cirlces which are close to edges will
%not be taken
cf = centers(centers(:,1)>300 & centers(:,2)>200 & centers(:,1)<1800 & centers(:,2)<1900 ,:);
rf = radii(centers(:,1)>300 & centers(:,2)>200 & centers(:,1)<1800 & centers(:,2)<1900 );

%Visualisation of circles

viscircles(centers(1,:),radii(1));
viscircles(cf,rf);
title("Choosen and detected circles")
%Chosing only first circle

circ1 = bin(cf(1,2)-rf(1)-1:cf(1,2)+rf(1)+1,cf(1,1)-rf(1)-1:cf(1,1)+rf(1)+1);
%Loop which enables cutting every circle in to the different window
for i = 1 : length(cf)
    circ = (bin(cf((i),2)-rf(i):cf(i,2)+rf(i)+1 , cf(i,1)-rf(i):cf(i,1)+rf(i)+1));
end
figure;
imagesc(circ);
title("Section of last detected circle")

%circ1 is used in the second part 
figure;
imagesc(circ1);
title("Circ1 section used to next part of exercise");
save('Circ1.mat','circ1');

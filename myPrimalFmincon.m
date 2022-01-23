clc;
clear all;
close all;

%  Ax+By+Cz+D=0
A=1;
B=1;
C=1;
D=1;
baseRatios=[A,B,C,D];

amountOfPointsAbove =100;
amountOfPointsBelow =100;

[pointsAbove,pointsBelow, points,pointsAboveTest,pointsBelowTest,pointsTest,y] = generateData(amountOfPointsAbove,amountOfPointsBelow,baseRatios);

A1=zeros(amountOfPointsAbove+amountOfPointsBelow,4);
b=zeros(amountOfPointsAbove+amountOfPointsBelow,1);
for k=1:amountOfPointsAbove
    A1(k,:)=[pointsAbove(k,1),pointsAbove(k,2),pointsAbove(k,3),1];
    b(k)=-1;
end
for k=1:(amountOfPointsBelow)   
    A1(k+amountOfPointsAbove,:)=-[pointsBelow(k,1),pointsBelow(k,2),pointsBelow(k,3),1];
    b(k)=-1;
end

fun= @(x)sqrt(x(1)^2+x(2)^2+x(3)^2+ x(4)*0);

x0=[0,0,0,0];
tic
ratios = fmincon(fun,x0,A1,b)
functionDuration=toc

chartTitle="ZADANIE PRYMALNE 3 WYMIARY" +newline + "FMINCON";
drawSurface(chartTitle,functionDuration,ratios,baseRatios,pointsAbove,pointsBelow)
clc;
clear all;
close all;

%  Ax+By+Cz+D=0
A=2;
B=1;
C=1;
D=1;

amountOfPointsAbove =100;
amountOfPointsBelow =100;

pointsAbove =zeros(amountOfPointsAbove,3);
pointsBelow=zeros(amountOfPointsBelow,3);

up=20;
amplitude=up/2;

for k=1:amountOfPointsAbove
    points=rand(2,1)*up-amplitude;
    z=(A*points(1)+B*points(2)+D)/(-C);
    z=z+rand(1)*amplitude;
    pointsAbove(k,:)=[points',z];
end

for k=1:amountOfPointsBelow
    points=rand(2,1)*up-amplitude;
    z=(A*points(1)+B*points(2)+D)/(-C);
    z=z-rand(1)*amplitude;
    pointsBelow(k,:)=[points',z];
end


A1=zeros(amountOfPointsAbove+amountOfPointsBelow,4);
b=zeros(amountOfPointsAbove+amountOfPointsBelow,1);
% p.Constraints=optimconstr(amountOfPointsAbove+amountOfPointsBelow);
for k=1:amountOfPointsAbove
    A1(k,:)=[pointsAbove(k,1),pointsAbove(k,2),pointsAbove(k,3),1];
    b(k)=-1;
end
for k=1:(amountOfPointsBelow)   
    A1(k+amountOfPointsAbove,:)=-[pointsBelow(k,1),pointsBelow(k,2),pointsBelow(k,3),1];
    b(k)=-1;
end

fun= @(x)sqrt(x(1)^2+x(2)^2+x(3)^2+ x(4)*0);
f1=@(x)optimizeThis(x,pointsAbove,pointsBelow);


x0=[1,1,1,1];
x3 = fmincon(f1,x0,A1,b)

% x4 = fmincon(fun,x0,A1,b)

 syms x y

[X,Y] = meshgrid(-amplitude:1:amplitude,-amplitude:1:amplitude);
Z = (A*X+B*Y+D)/(-C);

Z1=(x3(1)*X+x3(2)*Y+x3(4))/(-x3(3));


figure
% surf(X,Y,Z)
% hold on
surf(X,Y,Z1)
hold on
for k=1:amountOfPointsAbove
    scatter3(pointsAbove(k,1),pointsAbove(k,2),pointsAbove(k,3),'r')
hold on
end
for k=1:amountOfPointsBelow
    scatter3(pointsBelow(k,1),pointsBelow(k,2),pointsBelow(k,3),'b')
hold on
end
hold off

function [result]=optimizeThis(variables,x1,x2)
    divider=length(x1)+length(x2);
    lambda=0.1;
    sumX1=0;
    for k=1: length(x1)
        fValue=x1(k,1)*variables(1)+x1(k,2)*variables(2)+x1(k,3)*variables(3)+variables(4);
        fi=max(0,(1-fValue));
        sumX1=sumX1+fi;
    end
     sumX2=0;
    for k=1: length(x2)
        fValue=x1(k,1)*variables(1)+x1(k,2)*variables(2)+x1(k,3)*variables(3)+variables(4);
        fi=max(0,(1+fValue));
        sumX1=sumX1+fi;   
    end
    result=(sumX1+sumX2)/divider;
    
    result = result +lambda*(variables(1)^2+variables(2)^2+variables(3)^2);
    
%     lambda=1;
%     result =result+ lambda*sqrt(  variables(1)^2+ variables(2)+ variables(3));
end
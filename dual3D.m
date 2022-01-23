clc;
clear all;
close all;

A=2;
B=1;
C=1;
D=1;

baseRatios=[A,B,C,D];

amountOfPointsAbove =15;
amountOfPointsBelow =15;

amountOfPoints=amountOfPointsAbove+amountOfPointsBelow;

[pointsAbove,pointsBelow, points,pointsAboveTest,pointsBelowTest,pointsTest,y] = generateData(amountOfPointsAbove,amountOfPointsBelow,baseRatios);

flow = optimvar('c',amountOfPoints);

p = optimproblem('Objective', optimizeThis(flow,points,y),'ObjectiveSense','maximize');

p.Constraints.constr1=optimconstr(amountOfPoints);
p.Constraints.constr2=optimconstr(amountOfPoints);

for k=1:amountOfPoints
    p.Constraints.constr1(k)=flow(k)>=0;
    p.Constraints.constr2(k)=flow(k)<=1/(2*amountOfPoints);
end
p.Constraints.equality=y'*flow==0;

x0.c=zeros(amountOfPoints,1);

tic
sol= solve(p);
toc


cc=dualQuadprog(points,y);

adding=sol.c(1:amountOfPointsAbove);
substracting =sol.c(amountOfPointsAbove+1:end);

W=adding'*pointsAbove-substracting'*pointsBelow
W1=cc(1:amountOfPointsAbove)'*pointsAbove-cc(amountOfPointsAbove+1:end)'*pointsBelow;

w=zeros(amountOfPoints,1);
distFactor=sqrt(W(1)^2+W(2)^2+W(3)^2);
for k=1:amountOfPoints
    w(k)=abs(W(1)*points(k,1)+W(2)*points(k,2)+W(3)*points(k,3))/distFactor;
end

bUp=zeros(amountOfPointsAbove,1);
for k=1: amountOfPointsAbove
    bUp(k)=-(W*pointsAbove(k,:)')+1; 
end
bDown=zeros(amountOfPointsBelow,1);
for k=1: amountOfPointsBelow
    bDown(k)=-(W*pointsBelow(k,:)')-1;   
end

b=(min(bUp)+max(bDown))/2;
W=[W,b]

[X,Y] = meshgrid(-100:5:100,-100:5:100);
Z = (A*X+B*Y+D)/(-C);

Z1=(W(1)*X+W(2)*Y+W(4))/(-W(3));


CO(:,:,:) = ones(length(X)); % red
CO(:,:,2) = ones(length(X)).*linspace(0.5,0.6,length(X)); % green
CO(:,:,3) = ones(length(X)).*linspace(0,1,length(X)); % blue
figure
surf(X,Y,Z,CO)
hold on
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
title("ZADANIE DUALNE 3 WYMIARY")
legend(["PŁASZCZYZNA ZADANA", "PŁASZCZYZNA WYZNACZONA"])
hold off


function [result]=optimizeThis(c,points,y)
    sumIJ=0;
    for i=1: length(points)
      for j=1: length(points)  
          sumIJ=sumIJ+y(i)*c(i)*points(i,:)*points(j,:)'*y(j)*c(j);
      end
    end
    result =(sum(c)-0.5*sumIJ);
end


function [ alpha, functionDuration, fval, exitflag, output  ] = dualQuadprog( points, y )
    C = 1;
    N = length(y);
    K = points*points';
    H = 2*diag(y)*K*diag(y);
    f = -ones(N,1);
    Aeq = y';
    beq = [0];
    LB = zeros(N,1);
    UB = C*ones(N,1);
    
    tic
    [alpha,fval,exitflag,output] = quadprog(H, f, [], [], Aeq, beq, LB, UB, []);
    functionDuration=toc
end


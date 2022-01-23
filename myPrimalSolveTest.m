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

f1=@(x)optimizeThis(x,pointsAbove,pointsBelow);

flow = optimvar('W',4);

fun= @(x)sqrt(x(1)^2+x(2)^2+x(3)^2);
obj =fun(flow);

problem = optimproblem('Objective', obj,'ObjectiveSense','minimize');

problem.Constraints=optimconstr(amountOfPointsAbove+amountOfPointsBelow);
for k=1:amountOfPointsAbove
    problem.Constraints(k) = (pointsAbove(k,1)*flow(1)+pointsAbove(k,2)*flow(2)+pointsAbove(k,3)*flow(3)+flow(4))>=1;
end
for k=1:amountOfPointsBelow
    problem.Constraints(k+amountOfPointsAbove) = -(pointsBelow(k,1)*flow(1)+pointsBelow(k,2)*flow(2)+pointsBelow(k,3)*flow(3)+flow(4))>=1;
end

x0.W=[1,1,1,1];

tic;
sol= solve(problem,x0);
functionDuration=toc;

ratios=sol.W;

points=[pointsAbove;pointsBelow];
for k=1:length(points)
  res=  [points(k, :),1]*sol.W;
  if(res*y(k) <=0)
      disp("bad")
      k
      res
  end
end

chartTitle="ZADANIE PRYMALNE 3 WYMIARY" +newline + "SOLVE";
drawSurface(chartTitle,functionDuration,ratios,baseRatios,pointsAbove,pointsBelow)


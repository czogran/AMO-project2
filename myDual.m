clc;
clear all;
close all;

amountOfPointsAbove =15;
amountOfPointsBelow =15;

amountOfPoints=amountOfPointsAbove+amountOfPointsBelow;

baseRatios=[1 1 1 1 1];

[pointsAbove,pointsBelow, points,pointsAboveTest,pointsBelowTest,pointsTest,y] = generateData(amountOfPointsAbove,amountOfPointsBelow,baseRatios);

flow = optimvar('c',amountOfPoints);
obj=optimizeThis(flow,points,y);
p = optimproblem('Objective', obj,'ObjectiveSense','maximize');

p.Constraints.constr1=optimconstr(amountOfPoints);
p.Constraints.constr2=optimconstr(amountOfPoints);

for k=1:amountOfPoints
    p.Constraints.constr1(k)=flow(k)>=0;
    p.Constraints.constr2(k)=flow(k)<=1/(2*amountOfPoints);
end
p.Constraints.equality=y'*flow==0;

x0.c=zeros(amountOfPoints,1);

sol= solve(p,x0);

adding=sol.c(1:amountOfPointsAbove);
substracting =sol.c(amountOfPointsAbove+1:end);

W=adding'*pointsAbove-substracting'*pointsBelow

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

countBadOrg=0;
countBadTest=0;
for k=1:amountOfPoints
  res=  [points(k, :),1]*W';
  if(res*y(k) <=0)
      disp("bad")
      k
      countBadOrg=countBadOrg+1;
  end
  
  resTest=  [pointsTest(k, :),1]*W';
  if(res*y(k) <=0)
      disp("bad TEST")
      k
    countBadTest=countBadTest+1;
  end
end

function [result]=optimizeThis(c,points,y)
    sumIJ=0;
    for i=1: length(points)
      for j=1: length(points)  
          sumIJ=sumIJ+y(i)*c(i)*points(i,:)*points(j,:)'*y(j)*c(j);
      end
    end
    result =(sum(c)-0.5*sumIJ);
end



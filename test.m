clc;
clear all;
close all;

%  Ax+By+Cz+D=0
A=1;
B=1;
C=1;
D=1;

amountOfPointsAbove =10;
amountOfPointsBelow =10;

pointsAbove =zeros(amountOfPointsAbove,3);
pointsBelow=zeros(amountOfPointsBelow,3);

for k=1:amountOfPointsAbove
    points=rand(2,1)*200-100;
    z=(A*points(1)+B*points(2)+D)/(-C);
    z=z+rand(1)*100;
    pointsAbove(k,:)=[points',z];
end

for k=1:amountOfPointsBelow
    points=rand(2,1)*200-100;
    z=(A*points(1)+B*points(2)+D)/(-C);
    z=z-rand(1)*100;
    pointsBelow(k,:)=[points',z];
end

% p = optimproblem('ObjectiveSense', 'min');

% type draw




f1=@(x)optimizeThis(x,pointsAbove,pointsBelow);


flow = optimvar('W',4);

obj=optimizeThis(flow,pointsAbove,pointsBelow);

fun= @(x)sqrt(x(1)^2+x(2)^2+x(3)^2);
obj =fun(flow);


p = optimproblem('Objective', obj,'ObjectiveSense','minimize');
% flow = optimvar('W',4);

% p.Objective = optimizeThis(flow,pointsAbove,pointsBelow);
% p.Objective = optimizeThis2(flow(1:3));


p.Constraints=optimconstr(amountOfPointsAbove+amountOfPointsBelow);
for k=1:amountOfPointsAbove
%     p.Constraints(k) = (1-pointsAbove(k,1)*flow(1)-pointsAbove(k,2)*flow(2)-pointsAbove(k,3)*flow(3)+flow(4))>=0;
    p.Constraints(k) = (pointsAbove(k,1)*flow(1)+pointsAbove(k,2)*flow(2)+pointsAbove(k,3)*flow(3)+flow(4))>=1;
end
for k=1:amountOfPointsBelow
%         p.Constraints(k+amountOfPointsAbove) = (1+pointsBelow(k,1)*flow(1)+pointsBelow(k,2)*flow(2)+pointsBelow(k,3)*flow(3)-flow(4))>=0;

    p.Constraints(k+amountOfPointsAbove) = -(pointsBelow(k,1)*flow(1)+pointsBelow(k,2)*flow(2)+pointsBelow(k,3)*flow(3)+flow(4))>=1;
end

x0.W=[1,1,1,1];

% sol = solve(p, x0);
sol= solve(p,x0);

points=[pointsAbove;pointsBelow];
for k=1:length(points)
  res=  [points(k, :),1]*sol.W;
  if(res <=0)
      disp("bad")
      k
      res
  end
end


 syms x y
%  z = (A*x+B*y+D)/(-C);

[X,Y] = meshgrid(-100:5:100,-100:5:100);
Z = (A*X+B*Y+D)/(-C);

Z1=(sol.W(1)*X+sol.W(2)*Y+sol.W(4))/(-sol.W(3));

figure
surf(X,Y,Z)
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
hold off



% p.Constraints.cons1 = (1-pointsAbove(k,1)*flow(1)-pointsAbove(k,2)*flow(2)-pointsAbove(k,3)*flow(3)+flow(3))>=0;
% p.Constraints.cons2 = (1+pointsBelow(k,1)*flow(1)+pointsBelow(k,2)*flow(2)+pointsBelow(k,3)*flow(3)-flow(3))>=0;

% p.Constraints.BOS = rand(1,4)*flow(:,'BOS') <= 12;
% p.Constraints.LAX = rand(1,4)*flow(:,'LAX') <= 35;

% function [result]=optimizeThis(variables,x1,x2)
%     divider=length(x1)+length(x2);
%     sumX1=0;
%     for k=1: length(x1)
%         sumX1=sumX1+(1-x1(k,1)*variables(1)-x1(k,2)*variables(2)-x1(k,3)*variables(3)+variables(4));
%     end
%      sumX2=0;
%     for k=1: length(x2)
%         sumX2=sumX2+(1+x2(k,1)*variables(1)+x2(k,2)*variables(2)+x2(k,3)*variables(3)-variables(4));
%     end
%     result=(sumX1+sumX2)/divider;
%     
% %     lambda=1;
% %     result =result+ lambda*sqrt(  variables(1)^2+ variables(2)+ variables(3));
% end

function [result]=optimizeThis(variables,x1,x2)
    divider=length(x1)+length(x2);
    lambda=1;
    sumX1=0;
%     for k=1: length(x1)
%         fValue=x1(k,1)*variables(1)+x1(k,2)*variables(2)+x1(k,3)*variables(3)+variables(4);
% %         fi=max(0,(1-fValue));
%         fi=1-fValue;
% %         if fi<=0
% %             fi=0;
% %         end
%         sumX1=sumX1+fi;
%     end
%      sumX2=0;
%     for k=1: length(x2)
%         fValue=x1(k,1)*variables(1)+x1(k,2)*variables(2)+x1(k,3)*variables(3)+variables(4);
% %         fi=max(0,(1+fValue));
%          fi=1+fValue;
% %             if fi<=0
% %                 fi=0;
% %             end
%         sumX1=sumX1+fi;   
%     end
%     result=(sumX1+sumX2)/divider;
%     
%     result = result +lambda*(variables(1)^2+variables(2)^2+variables(3)^2);
    
%     lambda=1;
%     result =result+ lambda*sqrt(  variables(1)^2+ variables(2)+ variables(3));

    result = sqrt(  variables(1)^2+ variables(2)^2+ variables(3)^2);
end
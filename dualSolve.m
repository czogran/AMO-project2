function [cRatios,functionDuration] = dualSolve(points,y)   
    amountOfPoints=length(points);

    flow = optimvar('c',amountOfPoints);
    
    obj=solveOptimizeThis(flow,points,y);
    p = optimproblem('Objective', obj,'ObjectiveSense','maximize');

    p.Constraints.constr1=optimconstr(amountOfPoints);
    p.Constraints.constr2=optimconstr(amountOfPoints);

    for k=1:amountOfPoints
        p.Constraints.constr1(k)=flow(k)>=0;
        p.Constraints.constr2(k)=flow(k)<=1/(2*amountOfPoints);
    end
    p.Constraints.equality=y'*flow==0;

    x0.c=zeros(amountOfPoints,1);
    
    tic
    sol= solve(p,x0);
    functionDuration =toc;
    cRatios=sol.c;
    
end


function [ratios,functionDuration] = primalSolve(pointsAbove,pointsBelow,planeDimension)
    amountOfPointsAbove=length(pointsAbove);
    amountOfPointsBelow=length(pointsBelow);
    
    flow = optimvar('W',planeDimension+1);

    % HARD MARGIN
    fun= @(x)sqrt(sum(x(1:end-1).^2));

    obj =fun(flow);

    problem = optimproblem('Objective', obj,'ObjectiveSense','minimize');

    problem.Constraints=optimconstr(amountOfPointsAbove+amountOfPointsBelow);
    for k=1:amountOfPointsAbove
        problem.Constraints(k) = (pointsAbove(k,:)*flow(1:end-1)+flow(end))>=1;
    end
    for k=1:amountOfPointsBelow
        problem.Constraints(k+amountOfPointsAbove) = -(pointsBelow(k,:)*flow(1:end-1)+flow(end))>=1;
    end

    x0.W=ones(1,planeDimension+1);

    tic;
    sol= solve(problem,x0);
    functionDuration=toc;

    ratios=sol.W';
end

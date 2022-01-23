function [ratios,functionDuration] = primalFmincon(pointsAbove,pointsBelow,planeDimension)
    amountOfPointsAbove=length(pointsAbove);
    amountOfPointsBelow=length(pointsBelow);
    amountOfPoints=amountOfPointsAbove+amountOfPointsBelow;

    A=zeros(amountOfPoints,planeDimension+1);
    b=zeros(amountOfPoints,1);
    for k=1:amountOfPointsAbove
        A(k,:)=[pointsAbove(k,:),1];
        b(k)=-1;
    end
    for k=1:(amountOfPointsBelow)   
        A(k+amountOfPointsAbove,:)=-[pointsBelow(k,:),1];
        b(k+amountOfPointsAbove)=-1;
    end

    % HARD MARGIN
    fun= @(x)sqrt(sum(x(1:end-1).^2));

    x0=zeros(1,planeDimension+1);
    tic
    % I DO NOT KNOW WHY BUT FOR VALIDATION SIGN MATTERS
    ratios = -fmincon(fun,x0,A,b);
    functionDuration=toc;
end


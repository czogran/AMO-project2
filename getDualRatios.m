function [ratios] = getDualRatios(pointsAbove,pointsBelow,cRatios)
    amountOfPointsAbove=length(pointsAbove);
    amountOfPointsBelow=length(pointsBelow);
    
    adding=cRatios(1:amountOfPointsAbove);
    substracting =cRatios(amountOfPointsAbove+1:end);

    W=adding'*pointsAbove-substracting'*pointsBelow;
    
    bUp=zeros(amountOfPointsAbove,1);
    for k=1: amountOfPointsAbove
        bUp(k)=-(W*pointsAbove(k,:)')+1; 
    end
    
    bDown=zeros(amountOfPointsBelow,1);
    for k=1: amountOfPointsBelow
        bDown(k)=-(W*pointsBelow(k,:)')-1;   
    end

    b=(min(bUp)+max(bDown))/2;
    ratios=[W,b];
end


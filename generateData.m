function [pointsAbove,pointsBelow, pointsLearn,pointsAboveTest,pointsBelowTest,pointsTest,y] = generateData(amountOfPointsAbove,amountOfPointsBelow,baseRatios)
    dimensionsAmount=length(baseRatios)-1;

    pointsAbove =zeros(amountOfPointsAbove,dimensionsAmount);
    pointsBelow=zeros(amountOfPointsBelow,dimensionsAmount);

    pointsAboveTest =zeros(amountOfPointsAbove,dimensionsAmount);
    pointsBelowTest=zeros(amountOfPointsBelow,dimensionsAmount);

    for k=1:amountOfPointsAbove
        points=rand(dimensionsAmount-1,1)*200-100;
        z=(baseRatios(1:end-2)*points+baseRatios(end))/(-baseRatios(end-1));
        z=z+rand(1)*100;
        pointsAbove(k,:)=[points',z];

        points=rand(dimensionsAmount-1,1)*200-100;
        z=(baseRatios(1:end-2)*points+baseRatios(end))/(-baseRatios(end-1));
        z=z+rand(1)*100;
        pointsAboveTest(k,:)=[points',z];
    end

    for k=1:amountOfPointsBelow
        points=rand(dimensionsAmount-1,1)*200-100;
        z=(baseRatios(1:end-2)*points+baseRatios(end))/(-baseRatios(end-1));
        z=z-rand(1)*100;
        pointsBelow(k,:)=[points',z];

        points=rand(dimensionsAmount-1,1)*200-100;
        z=(baseRatios(1:end-2)*points+baseRatios(end))/(-baseRatios(end-1));
        z=z-rand(1)*100;
        pointsBelowTest(k,:)=[points',z];
    end

    pointsLearn=[pointsAbove; pointsBelow];
    pointsTest=[pointsAboveTest; pointsBelowTest];

    y=[ones(amountOfPointsAbove,1);-ones(amountOfPointsBelow,1)];
end


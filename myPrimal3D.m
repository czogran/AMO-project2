clear all;

% DECLARE PLANE
%  Ax+By+Cz+D=0
A=-10;
B=10;
C=20;
D=30;
baseRatios=[A,B,C,D];
planeDimension=length(baseRatios)-1;

amountOfPointsAbove =100;
amountOfPointsBelow =100;

%  GENERATE DATA
[pointsAbove,pointsBelow, pointsLearn,pointsAboveTest,pointsBelowTest,pointsTest,y] = generateData(amountOfPointsAbove,amountOfPointsBelow,baseRatios);

% FIND PLANE FACTORS
[ratiosFmincon,functionDurationFmincon] = primalFmincon(pointsAbove,pointsBelow,planeDimension);
clearAllMemoizedCaches; % CLEARING CACHES, BECAUSE SOLVE USES CACHE FROM FMINCON
[ratiosSolve,functionDurationSolve] = primalSolve(pointsAbove,pointsBelow,planeDimension);

% COUNT WRONGLY CLASSIFIED DATA
[countBadlyClassifiedLearnDataFmincon,countBadlyClassifiedTestDataFmincon] = validateResults(pointsLearn,y,pointsTest,y,ratiosFmincon);
[countBadlyClassifiedLearnDataSolve,countBadlyClassifiedTestDataSolve] = validateResults(pointsLearn,y,pointsTest,y,ratiosSolve);

% DRAW DATA
chartTitle="ZADANIE PRYMALNE, DANE UCZĄCE" +newline + "FMINCON";
drawSurface(chartTitle,functionDurationFmincon,ratiosFmincon,baseRatios,pointsAbove,pointsBelow,countBadlyClassifiedLearnDataFmincon)

chartTitle="ZADANIE PRYMALNE, DANE TESTOWE" +newline + "FMINCON";
drawSurface(chartTitle,functionDurationFmincon,ratiosFmincon,baseRatios,pointsAboveTest,pointsBelowTest,countBadlyClassifiedTestDataFmincon)


chartTitle="ZADANIE PRYMALNE, DANE UCZĄCE" +newline + "SOLVE";
drawSurface(chartTitle,functionDurationSolve,ratiosSolve,baseRatios,pointsAbove,pointsBelow,countBadlyClassifiedLearnDataSolve)

chartTitle="ZADANIE PRYMALNE, DANE TESTOWE" +newline + "SOLVE";
drawSurface(chartTitle,functionDurationSolve,ratiosSolve,baseRatios,pointsAboveTest,pointsBelowTest,countBadlyClassifiedTestDataSolve)
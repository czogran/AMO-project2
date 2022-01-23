clear all;

% DECLARE PLANE
A=-10;
B=10;
C=20;
D=30;

baseRatios=[A,B,C,D];

amountOfPointsAbove =100;
amountOfPointsBelow =100;

amountOfPoints=amountOfPointsAbove+amountOfPointsBelow;

% GENERATE DATA
[pointsAbove,pointsBelow, pointsLearn,pointsAboveTest,pointsBelowTest,pointsTest,y] = generateData(amountOfPointsAbove,amountOfPointsBelow,baseRatios);

% FIND PLANE FACTORS WITHOUT b
[cRatiosSolve,functionDurationSolve] = dualSolve(pointsLearn,y);
clearAllMemoizedCaches; % CLEARING CACHES, BECAUSE SOLVE USES CACHE FROM FMINCON
[cRatiosQuadprog, functionDurationQuadprog]=dualQuadprog(pointsLearn,y);

% ADD b TO PLANE FACTORS
ratiosQuadprog=getDualRatios(pointsAbove,pointsBelow,cRatiosQuadprog);
ratiosSolve=getDualRatios(pointsAbove,pointsBelow,cRatiosSolve);

% COUNT WRONGLY CLASSIFIED DATA
[countBadlyClassifiedLearnDataQuadprog,countBadlyClassifiedTestDataQuadprog] = validateResults(pointsLearn,y,pointsTest,y,ratiosQuadprog);
[countBadlyClassifiedLearnDataSolve,countBadlyClassifiedTestDataSolve] = validateResults(pointsLearn,y,pointsTest,y,ratiosSolve);

% DRAW DATA
chartTitle="ZADANIE DUALNE, DANE UCZĄCE" +newline + "QUADPROG";
drawSurface(chartTitle,functionDurationQuadprog,ratiosQuadprog,baseRatios,pointsAbove,pointsBelow,countBadlyClassifiedLearnDataQuadprog)

chartTitle="ZADANIE DUALNE, DANE TESTOWE" +newline + "QUADPROG";
drawSurface(chartTitle,functionDurationQuadprog,ratiosQuadprog,baseRatios,pointsAboveTest,pointsBelowTest,countBadlyClassifiedTestDataQuadprog)


chartTitle="ZADANIE DUALNE, DANE UCZĄCE" +newline + "SOLVE";
drawSurface(chartTitle,functionDurationSolve,ratiosSolve,baseRatios,pointsAbove,pointsBelow,countBadlyClassifiedLearnDataSolve)

chartTitle="ZADANIE DUALNE, DANE TESTOWE" +newline + "SOLVE";
drawSurface(chartTitle,functionDurationSolve,ratiosSolve,baseRatios,pointsAboveTest,pointsBelowTest,countBadlyClassifiedTestDataSolve)
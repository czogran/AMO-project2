clear all;

planeDimension=30;

% READ DATA
dataLearn=readtable('wdbcLearn.dat');
pointsAboveLearn=table2array(dataLearn(strcmpi(dataLearn.Var31,{'B'})>0,1:planeDimension));
pointsBelowLearn=table2array(dataLearn(strcmpi(dataLearn.Var31,{'M'})>0,1:planeDimension));
pointsLearn=[pointsAboveLearn;pointsBelowLearn];
amountPointsAboveLearn=length(pointsAboveLearn);
amountPointsBelowLearn=length(pointsBelowLearn);
amountOfPointsLearn=amountPointsAboveLearn+amountPointsBelowLearn;
yLearn=[ones(amountPointsAboveLearn,1);-ones(amountPointsBelowLearn,1)];

dataTest=readtable('wdbcTest.dat');
pointsAboveTest=table2array(dataTest(strcmpi(dataTest.Var31,{'B'})>0,1:planeDimension));
pointsBelowTest=table2array(dataTest(strcmpi(dataTest.Var31,{'M'})>0,1:planeDimension));
pointsTest=[pointsAboveTest;pointsBelowTest];
amountPointsAboveTest=length(pointsAboveTest);
amountPointsBelowTest=length(pointsBelowTest);
amountOfPointsTest=amountPointsAboveTest+amountPointsBelowTest;
yTest=[ones(amountPointsAboveTest,1);-ones(amountPointsBelowTest,1)];


% FIND PLANE FACTORS
[cRatiosQuadprog,functionDurationQuadprog] = dualQuadprog(pointsLearn,yLearn);
clearAllMemoizedCaches; % CLEARING CACHES, BECAUSE SOLVE USES CACHE FROM QUADPROG
[cRatiosSolve,functionDurationSolve] = dualSolve(pointsLearn,yLearn);

% ADD b TO PLANE FACTORS
ratiosQuadprog=getDualRatios(pointsAboveLearn,pointsBelowLearn,cRatiosQuadprog);
ratiosSolve=getDualRatios(pointsAboveLearn,pointsBelowLearn,cRatiosSolve);


% COUNT WRONGLY CLASSIFIED DATA
[countBadlyClassifiedLearnDataQuadprog,countBadlyClassifiedTestDataQuadprog] = validateResults(pointsLearn,yLearn,pointsTest,yTest,ratiosQuadprog);
[countBadlyClassifiedLearnDataSolve,countBadlyClassifiedTestDataSolve] = validateResults(pointsLearn,yLearn,pointsTest,yTest,ratiosSolve);

% DISPLAY RESULTS
disp("ZADANIE DUALNE, WDBC, QUADPROG");
disp("CZAS: " + functionDurationQuadprog);
disp("LICZBA PUNKTÓW UCZĄCYCH: "+ amountOfPointsLearn);
disp("LICZBA PUNKTÓW TESTOWYCH: "+ amountOfPointsTest);
disp("WYZNACZONA PŁASZCZYZNA: "+strjoin(string(ratiosQuadprog), ', '))
disp("BŁĘDNIE ZAKWALIKOWANE DANE UCZĄCE: " + countBadlyClassifiedLearnDataQuadprog);
disp("BŁĘDNIE ZAKWALIKOWANE DANE TESTOWE: " + countBadlyClassifiedTestDataQuadprog);

disp(newline)

disp("ZADANIE DUALNE, WDBC, SOLVE");
disp("CZAS: " + functionDurationSolve);
disp("LICZBA PUNKTÓW UCZĄCYCH: "+ amountOfPointsLearn);
disp("LICZBA PUNKTÓW TESTOWYCH: "+ amountOfPointsTest);
disp("WYZNACZONA PŁASZCZYZNA: "+strjoin(string(ratiosSolve), ', '))
disp("BŁĘDNIE ZAKWALIKOWANE DANE UCZĄCE: " + countBadlyClassifiedLearnDataSolve);
disp("BŁĘDNIE ZAKWALIKOWANE DANE TESTOWE: " + countBadlyClassifiedTestDataSolve);
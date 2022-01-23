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
[ratiosFmincon,functionDurationFmincon] = primalFmincon(pointsAboveLearn,pointsBelowLearn,planeDimension);
clearAllMemoizedCaches; % CLEARING CACHES, BECAUSE SOLVE USES CACHE FROM FMINCON
[ratiosSolve,functionDurationSolve] = primalSolve(pointsAboveLearn,pointsBelowLearn,planeDimension);


% COUNT WRONGLY CLASSIFIED DATA
[countBadlyClassifiedLearnDataFmincon,countBadlyClassifiedTestDataFmincon] = validateResults(pointsLearn,yLearn,pointsTest,yTest,ratiosFmincon);
[countBadlyClassifiedLearnDataSolve,countBadlyClassifiedTestDataSolve] = validateResults(pointsLearn,yLearn,pointsTest,yTest,ratiosSolve);


disp("ZADANIE PRYMALNE, WDBC, FMINCON");
disp("CZAS: " + functionDurationFmincon);
disp("LICZBA PUNKTÓW UCZĄCYCH: "+ amountOfPointsLearn);
disp("LICZBA PUNKTÓW TESTOWYCH: "+ amountOfPointsTest);
disp("WYZNACZONA PŁASZCZYZNA: "+strjoin(string(ratiosFmincon), ', '))
disp("BŁĘDNIE ZAKWALIKOWANE DANE UCZĄCE: " + countBadlyClassifiedLearnDataFmincon);
disp("BŁĘDNIE ZAKWALIKOWANE DANE TESTOWE: " + countBadlyClassifiedTestDataFmincon);

disp(newline)

disp("ZADANIE PRYMALNE, WDBC, SOLVE");
disp("CZAS: " + functionDurationSolve);
disp("LICZBA PUNKTÓW UCZĄCYCH: "+ amountOfPointsLearn);
disp("LICZBA PUNKTÓW TESTOWYCH: "+ amountOfPointsTest);
disp("WYZNACZONA PŁASZCZYZNA: "+strjoin(string(ratiosSolve), ', '))
disp("BŁĘDNIE ZAKWALIKOWANE DANE UCZĄCE: " + countBadlyClassifiedLearnDataSolve);
disp("BŁĘDNIE ZAKWALIKOWANE DANE TESTOWE: " + countBadlyClassifiedTestDataSolve);
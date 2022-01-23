clear all;

% DECLARE PLANE
baseRatios=[10,15,20,25,30,50];
planeDimension=length(baseRatios)-1;

amountOfPointsAbove =100;
amountOfPointsBelow =100;
amountOfPoints=amountOfPointsAbove+amountOfPointsBelow;

% GENERATE DATA
[pointsAbove,pointsBelow, pointsLearn,pointsAboveTest,pointsBelowTest,pointsTest,y] = generateData(amountOfPointsAbove,amountOfPointsBelow,baseRatios);

% FIND PLANE FACTORS
[ratiosFmincon,functionDurationFmincon] = primalFmincon(pointsAbove,pointsBelow,planeDimension);
clearAllMemoizedCaches; % CLEARING CACHES, BECAUSE SOLVE USES CACHE FROM FMINCON
[ratiosSolve,functionDurationSolve] = primalSolve(pointsAbove,pointsBelow,planeDimension);


% COUNT WRONGLY CLASSIFIED DATA
[countBadlyClassifiedLearnDataFmincon,countBadlyClassifiedTestDataFmincon] = validateResults(pointsLearn,y,pointsTest,y,ratiosFmincon);
[countBadlyClassifiedLearnDataSolve,countBadlyClassifiedTestDataSolve] = validateResults(pointsLearn,y,pointsTest,y,ratiosSolve);

% DISPLAY RESULTS
disp("ZADANIE PRYMALNE DLA PRZESTRZENI 5 WYMIAROWEJ"+newline)
disp("ZADANA PŁASZCZYZNA: "+strjoin(string(baseRatios), ', '))
disp("LICZBA PUNKTÓW (UCZĄCYCH/TESTOWYCH): "+ amountOfPoints);

disp(newline)

disp("ZADANIE PRYMALNE 5 WYMIARY, FMINCON");
disp("CZAS: " + functionDurationFmincon);
disp("WYZNACZONA PŁASZCZYZNA: "+strjoin(string(ratiosFmincon), ', '))
disp("BŁĘDNIE ZAKWALIKOWANE DANE UCZĄCE: " + countBadlyClassifiedLearnDataFmincon);
disp("BŁĘDNIE ZAKWALIKOWANE DANE TESTOWE: " + countBadlyClassifiedTestDataFmincon);

disp(newline)

disp("ZADANIE PRYMALNE 4 WYMIARY, SOLVE");
disp("CZAS: " + functionDurationSolve);
disp("WYZNACZONA PŁASZCZYZNA: "+strjoin(string(ratiosSolve), ', '))
disp("BŁĘDNIE ZAKWALIKOWANE DANE UCZĄCE: " + countBadlyClassifiedLearnDataSolve);
disp("BŁĘDNIE ZAKWALIKOWANE DANE TESTOWE: " + countBadlyClassifiedTestDataSolve);

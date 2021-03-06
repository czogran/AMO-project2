clear all;

% DECLARE PLANE
baseRatios=[10,15,20,25,30,50];
planeDimension=length(baseRatios)-1;

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



% DISPLAY RESULTS
disp("ZADANIE DUALNE DLA PRZESTRZENI 5 WYMIAROWEJ")
disp("ZADANA PŁASZCZYZNA: "+strjoin(string(baseRatios), ', '))
disp("LICZBA PUNKTÓW (UCZĄCYCH/TESTOWYCH): "+ amountOfPoints);

disp(newline);

disp("ZADANIE DUALNE 5 WYMIARÓW, QUADPROG");
disp("CZAS: " + functionDurationQuadprog);
disp("WYZNACZONA PŁASZCZYZNA: "+strjoin(string(ratiosQuadprog), ', '))
disp("BŁĘDNIE ZAKWALIKOWANE DANE UCZĄCE: " + countBadlyClassifiedLearnDataQuadprog);
disp("BŁĘDNIE ZAKWALIKOWANE DANE TESTOWE: " + countBadlyClassifiedTestDataQuadprog);

disp(newline)

disp("ZADANIE DUALNE 5 WYMIARÓW, SOLVE");
disp("CZAS: " + functionDurationSolve);
disp("WYZNACZONA PŁASZCZYZNA: "+strjoin(string(ratiosSolve), ', '))
disp("BŁĘDNIE ZAKWALIKOWANE DANE UCZĄCE: " + countBadlyClassifiedLearnDataSolve);
disp("BŁĘDNIE ZAKWALIKOWANE DANE TESTOWE: " + countBadlyClassifiedTestDataSolve);
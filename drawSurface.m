function  drawSurface(chartTitle,functionDuration,ratios,baseRatios,pointsAbove,pointsBelow)
    amountOfPointsAbove=length(pointsAbove);
    amountOfPointsBelow=length(pointsBelow);
    amountOfPoints=amountOfPointsAbove+amountOfPointsBelow;

    [X,Y] = meshgrid(-100:5:100,-100:5:100);
    Z = (baseRatios(1)*X+baseRatios(2)*Y+baseRatios(4))/(-baseRatios(3));

    Z1=(ratios(1)*X+ratios(2)*Y+ratios(4))/(-ratios(3));
    figure
    CO(:,:,:) = ones(length(X)); % red
    CO(:,:,2) = ones(length(X)).*linspace(0.5,0.6,length(X)); % green
    CO(:,:,3) = ones(length(X)).*linspace(0,1,length(X)); % blue
    surf(X,Y,Z,CO)
    hold on
    surf(X,Y,Z1)
    hold on
    for k=1:amountOfPointsAbove
        scatter3(pointsAbove(k,1),pointsAbove(k,2),pointsAbove(k,3),'r')
    hold on
    end
    for k=1:amountOfPointsBelow
        scatter3(pointsBelow(k,1),pointsBelow(k,2),pointsBelow(k,3),'b')
    hold on
    end
    title(chartTitle +newline +"LICZBA PUNKTÓW: "+ amountOfPoints+newline+"CZAS[s]: "+functionDuration)
    legend(["PŁASZCZYZNA ZADANA", "PŁASZCZYZNA WYZNACZONA"])
    hold off

end
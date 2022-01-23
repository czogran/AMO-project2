function [countBadlyClassifiedLearnData,countBadlyClassifiedTestData] = validateResults(pointsLearn,yLearn,pointsTest,yTest,ratios)
    countBadlyClassifiedLearnData=0;
    countBadlyClassifiedTestData=0;
    for k=1:length(pointsLearn)
      resultLearn=  [pointsLearn(k, :),1]*ratios';
      if(resultLearn*yLearn(k)<=0)
           countBadlyClassifiedLearnData=countBadlyClassifiedLearnData+1;
      end

    end
    for k=1:length(pointsTest)
      resultTest=  [pointsTest(k, :),1]*ratios';
      if(resultTest*yTest(k) <=0)
        countBadlyClassifiedTestData=countBadlyClassifiedTestData+1;
      end
    end
end


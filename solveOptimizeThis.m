function [result]=solveOptimizeThis(c,points,y)    
    K = points*points';
    H = diag(y)*diag(c)*K*diag(y)*diag(c);
    result =(sum(c)-0.5*sum(sum(H)));
end

% SLOWER VERSION, SOLVER TAKES QUADPROG TO THIS
% function [result]=solveOptimizeThis(c,points,y)
%     sumIJ=0;
%     for i=1: length(points)
%       for j=1: length(points)  
%           sumIJ=sumIJ+y(i)*c(i)*points(i,:)*points(j,:)'*y(j)*c(j);
%       end
%     end
%     result =(sum(c)-0.5*sumIJ);
% end
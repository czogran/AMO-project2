function [ ratios, functionDuration ] = dualQuadprog( points, y )
    C = 1;
    N = length(y);
    K = points*points';
    H = 2*diag(y)*K*diag(y);
    f = -ones(N,1);
    Aeq = y';
    beq = [0];
    LB = zeros(N,1);
    UB = C*ones(N,1);
    
    tic
    ratios = quadprog(H, f, [], [], Aeq, beq, LB, UB, []);
    functionDuration=toc;
end
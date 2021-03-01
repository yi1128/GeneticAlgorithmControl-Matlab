function [index] = roulette(Q)
%ROULETTE Summary of this function goes here
%   Detailed explanation goes here

    sum = 0;
    
    for i = 1:10
    
        % Summe des inversen Fitness-Values da minimierung
        %sum = sum + 1/pop(i,49);
        sum = sum + Q(i,49);
        
    end
    
    % Initialization
    ids = zeros(10,2);
    
    % IDs for the individuals
    ids(:,2) = [1:10]';
    
    for i = 1:10
    
        % Probability for the individual to be taken
        %ids(i,1) = (1/pop(i,49)) / sum;    
        ids(i,1) = Q(i,49) / sum;
        
    end
    
    ids = sortrows(ids,1);

    memberSum = zeros(10,2);
    memberSum(:,2) = ids(:,2);
    
    memberSum(1,1) = ids(1,1);
    
    for a = 2:10
        
        memberSum(a,1) =  memberSum(a-1,1) + ids(a,1);
        
    end
    
    random = rand(1);
    
    for goal = 1:10
    
        if (memberSum(goal,1) > random)
            index = memberSum(goal,2);
            return;
        end
           
    end
    
    index = memberSum(10,2);

end


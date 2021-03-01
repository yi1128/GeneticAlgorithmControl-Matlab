classdef Manipulator < handle
    % The manipulator has the power to alter one generation according to
    % the plan of genetics
    % namely: 
    % - New generation by rouhlette-wheel selection DONE
    % - Crossover
    % - Mutation
    % - Inversion
    % - Elitist Reservation DONE
    
    properties
        crossProb = 0.6  % Crossover Probability
        mutProb = 0.1   % Mutation Probability
        invProb = 0.05   % Inversion Probability
        popSize = 10
        iterationSize = 50
                
    end
    
    methods
        function obj = Manipulator(obj)
            %MANIPULATOR Construct an instance of this class
            %   Detailed explanation goes here
            
        end
        
        function A = createPop(obj)
           
            A = randi([0 1], obj.popSize,48);         
                     
        end
        
        function [Kp, Ki, Kd] = decode(obj, zeile)
           
            pGain = zeile(1:16);
            pGain = num2str(pGain);
            pGain = pGain(~isspace(pGain));

            iGain = zeile(17:32);
            iGain = num2str(iGain);
            iGain = iGain(~isspace(iGain));
            
            dGain = zeile(33:48);
            dGain = num2str(dGain);
            dGain = dGain(~isspace(dGain));
            
            scaleP = mybin2real(pGain);
            scaleI = mybin2real(iGain);
            scaleD = mybin2real(dGain); 
            
            scaleVectorP = [0,scaleP,65535];
            scaleVectorI = [0,scaleI,65535];
            scaleVectorD = [0,scaleD,65535];
            
            % Scale the number into range
            P = rescale(scaleVectorP, 0, 20);
            I = rescale(scaleVectorI, 0, 20);
            D = rescale(scaleVectorD, 0, 20);
            
            Kp = P(1,2);
            Ki = I(1,2);
            Kd = D(1,2);
            
        end
    
        
        function matingPool = selection(obj,Q)
            
            % make mating pool just as big as Q
            matingPool = zeros(size(Q));
                        
            tmp = sortrows(Q,49);
            currentBest = tmp(obj.popSize,:);
            
            % Pick best (lowest) scoring ind from Q into matinPool         
            matingPool(obj.popSize,:) = currentBest;
            
            % Fill the
            for full = 1 : obj.popSize-1
                
                index = roulette(Q);
                matingPool(full,:) = Q(index,:); 
                
            end
        end   
        
        
        function crossedPop = crossover(obj,pop)
            
            crossedPop = zeros(size(pop));
            
            for start = 1: obj.popSize/2
            
                one = pop(start,:);
                two = pop(start+obj.popSize/2,:);
                
                random = rand(1);
                
                % Crossover Probability at 80%
                if (random > 0.2)
                   
                    r2 = myRandom(1,47);

                    tmp = one;
                    one(1,r2:48) = two(1,r2:48);
                    two(1,r2:48) = tmp(1,r2:48);
                    
                    crossedPop(start,:) = one;
                    crossedPop(start+obj.popSize/2,:) = two;
                    
                    continue;
                    
                end
               
                crossedPop(start,:) = pop(start,:);
                crossedPop(start+obj.popSize/2,:) = pop(start+obj.popSize/2,:);
                  
            end       
        end
        
        function mPool = mutation(obj, pop)
            
            mPool = zeros(size(pop));
            
            % Do for every individual in the population
            for ind = 1: obj.popSize
            
                random = rand(1);
                
                % mutation probability at 0.1 for the whole string
                % it could also be checking every digit and try to mutate
                % right now its 5%
                if (random > 0.95)
                
                    % mutation site
                    random2 = myRandom(1,48);
                    
                    % mutate to 0 or 1 accordingly
                    if (pop(ind,random2) == 0)
                    
                        pop(ind,random2) = 1;
                        
                    else 
                        pop(ind,random2) = 0;
                    end
                    
                    
                end  
                
                mPool(ind,:) = pop(ind,:);
                     
            end
   
        end
        
        function poolI = inversion(obj,pop)
        
            poolI = zeros(size(pop));
            for ind = 1: obj.popSize
            
                random = rand(1);
                
                % inversion probability at 0.1 for the whole string
                % it could also be checking every digit and try to mutate
                % right now its 5%
                if (random > 0.95)
                
                    % mutation site
                    random2 = myRandom(1,48);
                    random3 = myRandom(1,48);
                    
                    % swap the entries
                    
                    tmp = pop(ind,random2);
                    pop(ind,random2) = pop(ind, random3);
                    pop(ind,random3) = tmp;
                    
   
                end  
                
                poolI(ind,:) = pop(ind,:);
                  
            end

        end
        
        
        % Maybe change to "just take the better one" which also results in
        % elitist replacement
        function finalPool = preselection(obj,Q,newPop)
            
            
            finalPool = zeros(size(Q));
            
            currentHighest = Q(1,49);
            counter = 1;
            
            % Pick highest scoring ind from oldPOp into newPop
            for ind = 1 : obj.popSize
                
                tmp = Q(ind,49);
                
                % Minimization
                if (tmp > currentHighest)
                    
                    currentHighest = tmp;
                    counter = ind;
           
                end 
            end
            
            
            % Elitist preselection from old Pop
            finalPool(counter,:) = Q(counter,:);
            
            for counter2 = 1 : obj.popSize
            
                % Ignore the entry of the fittest indovidual
                if(counter2 == counter)
                    continue;
                end
                
                % && rand(1) > 0.2 for adding a probability to take the
                % better offspring
                if (Q(counter2,49) > newPop(counter2,49))
                
                    finalPool(counter2,:) = Q(counter2,:);
                    
                else
                    
                    finalPool(counter2,:) = newPop(counter2,:);
                    
                end
  
            end
        end
                
    end
    
end


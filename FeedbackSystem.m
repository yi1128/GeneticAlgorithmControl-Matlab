classdef FeedbackSystem < handle

    
    properties
        sse         % steady-state error for the current iteration
        Mp          % overshoot for the current iteration
        sTime       % settling time for the current iteration
        rise        % rise time for the current iteration
        
        kPID   (1,3) = [0,0,0]; 
    
        
    end
    
    methods
        function obj = FeedbackSystem(par)
            
            obj.sse = 0;
            obj.Mp = 0;
            obj.sTime = 0;
            obj.rise = 0;
            obj.kPID(1) = 1;
            obj.kPID(2) = 0;
            obj.kPID(2) = 0;
        end
        
        function [fitness] = calculateFitness(obj, Kp, Ki, Kd)
            
            %TF Example 1, 
            num = 1;
            den = [1/216 19/216 7/12 3/2 1];
            G = tf(num,den);
            % s = tf('s');
            
            %Speicherplatz
            y = zeros(200);
            t = zeros(200);
            
            %TODO: 
            %Ab hier überprüfen
            H = 1;
            C = pid(Kp,Ki,Kd);
            
            T = feedback(C*G,H);
            opt = stepDataOptions('InputOffset',0,'StepAmplitude',1);
            [y,t] = step(T, opt);
            
            %1-y: 1 hier dasselbe wie StepAmplitude
            

            %SettlingTime = tspan(find(y>sserror,1,'last'))
            %S = stepinfo(y,t,'SettlingTimeThreshold',0.001);
            S = stepinfo(y,t);

            %Already in percentages to the y-final
            Mp = S.(subsref(fieldnames(S),substruct('{}',{5})));
            sse = abs(1-y(end));
            sTime = S.(subsref(fieldnames(S), substruct('{}',{2})));
            rise = S.(subsref(fieldnames(S), substruct('{}',{1})));
            
            
            % Überprüfung wie was einfließt
            compound = (1+Mp)*(rise+sTime); % (4) im Paper Seite 3
            fitness = 1/(compound^10);
            
                   
        end

     function [response, info] = calcResponse(obj, Kp, Ki, Kd)
            
            response = zeros(200,200);
         
            %TF Example 1
            num = [1];
            den = [1/216 19/216 7/12 3/2 1];
            G = tf(num,den);
            
            
            %Speicherplatz
            y = zeros(200);
            t = zeros(200);
            
            %TODO: 
            %Ab hier überprüfen
            
            H = 1;
            C = pid(Kp,Ki,Kd);
            
            T = feedback(C*G,H);
            opt = stepDataOptions('InputOffset',0,'StepAmplitude',1);
            t = [200];
            [y,t] = step(T, opt);
            
            response = [y,t];
            
            %1-y: 1 hier dasselbe wie StepAmplitude
            

            %SettlingTime = tspan(find(y>sserror,1,'last'))
            %S = stepinfo(y,t,'SettlingTimeThreshold',0.001);
            info = stepinfo(y,t);

            %Already in percentages to the y-final
            
            
                   
     end
        
    end
    
        %function obj = set.kPID(obj, kPID)
        %   obj.kPID(1) = kPID(1);
        %   obj.kPID(2) = kPID(2);
        %   obj.kPID(3) = kPID(3);
        % end    
        
            
end





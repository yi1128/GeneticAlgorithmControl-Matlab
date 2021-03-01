
clc;

warning('off','all')
%addpath(genpath(pwd));

% INITIALIZATION

fs = FeedbackSystem();
man = Manipulator();
P = man.createPop();

for iteration = 1 : 10
    
    % Abbruchskriterium einfügen: Falls Fitness > 10000
    % e.g. bigdeal auf 1 setzen sobald fitness über einen bestimmten wert
    % geht
    
for zeile = 1 : 10
    
[Kp,Ki,Kd] = man.decode(P(zeile,:));
P(zeile,49) = fs.calculateFitness(Kp,Ki,Kd);
    
end

% Generate a new population by selection
pool = man.selection(P);
%CHECKED

% Crossover every two individuals with probability p
poolC = man.crossover(pool);
%CHECKED

% Mutation for every Individual
poolM = man.mutation(poolC);

% Inversion
poolI = man.inversion(poolM);

% Preselection now compares the mating pool and the final population
% and puts together the final new population

% Überprüfung der Fitness!!!
for zeile2 = 1 : 10
    
[Kp2,Ki2,Kd2] = man.decode(poolI(zeile2,:));
poolI(zeile2,49) = fs.calculateFitness(Kp2,Ki2,Kd2);
    
end

P = man.preselection(pool, poolI);
%CHECKED

    
end

values = P(:,49);

highest = sortrows(P,49);
reallyBest = highest(10,49);

chromo = highest(10,:);

[finalKp,finalKi,finalKd] = man.decode(chromo);
%figure(2);
%[result, info] = fs.calcResponse(finalKp, finalKi, finalKd);
%plot(result(:,:))

[my, info] = fs.calcResponse(finalKp, finalKi, finalKd);
[perfect, info2] = fs.calcResponse(3.356, 2.907, 1.216);

%figure(2);
%plot(perfect);

figure(3);
plot(my);




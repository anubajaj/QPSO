clear all
clc
% Start Timer
tic
load 'TestStatementMatrix.mat' tsm;    % Load the Test Fault Matrix
Test_Statement_Matrix=tsm;
[Particles_Size,~]=size(Test_Statement_Matrix); % Number of Test cases
Max_Iterations=100;
Pop_Size=100;
thetaMax=1.7;
thetaMin=0.5;
c1=1.5;
c2=2;
Vmax=10;
G=5;

disp('The Quantum behaved PSO is optimizing the problem...')
Particles_Pop=zeros(Pop_Size,Particles_Size);
for i=1:Pop_Size
    Particles_Pop(i,:)=randperm(Particles_Size);
end
Velocity_Pop=zeros(Pop_Size,Particles_Size);%Velocity vector

% Save the Best Fitness and Best Particles

gBest_Fitness_EachItr=zeros(1,Max_Iterations);
gBest_Particles=zeros(1,Particles_Size);
%///////////////////////////////////

%Start iterations

for iterations=1:Max_Iterations
    %% Evaluation of Particles.
    for i=1:Pop_Size
            Fitness_Pop(i)=APSC(Particles_Pop(i,:),Test_Statement_Matrix);
    end
   
    %% keep better results
    if iterations==1
        pBest_Fitness_Pop=Fitness_Pop;
        pBest_Particles_Pop=Particles_Pop;
        [Best_Fitness,Best_Index]=max(pBest_Fitness_Pop);
        gBest_Fitness=Best_Fitness;
        gBest_Fitness_EachItr(iterations)=gBest_Fitness;
        gBest_Particles=Particles_Pop(Best_Index,:);
    else
        New_Fittest_Indices=find(pBest_Fitness_Pop<Fitness_Pop);
        pBest_Particles_Pop(New_Fittest_Indices,:)=Particles_Pop(New_Fittest_Indices,:);
        pBest_Fitness_Pop(New_Fittest_Indices)=Fitness_Pop(New_Fittest_Indices);
        for i=1:Pop_Size
            if  pBest_Fitness_Pop(i)>gBest_Fitness
                gBest_Fitness= pBest_Fitness_Pop(i);
                gBest_Fitness_EachItr(iterations)=gBest_Fitness;
                gBest_Particles=pBest_Particles_Pop(i,:);
            end
        end
    %% mutation
    if(iterations>G)
        if(gBest_Fitness_EachItr(iterations)-gBest_Fitness_EachItr(iterations-G)<0.25)
            for j=1:Pop_Size
                Updated_Particles_Pop(j,:)=Mutate(Particles_Pop(j,:),Particles_Size);
                Updated_Fitness_Pop(j)=APSC(Updated_Particles_Pop(j,:),Test_Statement_Matrix);
                if Updated_Fitness_Pop(j)>Fitness_Pop(j)
                Particles_Pop(j,:)=Updated_Particles_Pop(j,:);
                end
            end
        end
    end   
    %% Update the population
    alpha(iterations)=gBest_Fitness_EachItr(iterations-1)/gBest_Fitness_EachItr(iterations);
    theta=thetaMax-alpha(iterations)*thetaMin;
    Gus(iterations)=2/(3.141*1.414)*exp((iterations)^2/2);
    meanUpdated_Particles_Pop = mean(pBest_Particles_Pop)/Pop_Size;
    %Update the Position of particles
    for i=1:Pop_Size
        fi = rand(1,Particles_Size);
        a = (c1*fi*rand.*pBest_Particles_Pop(i,:) + c2*(1-fi)*rand.*gBest_Particles)/(c1+c2);
        if(iterations>G+1)
        if(alpha(iterations)-alpha(iterations-G)==0)
            Random=randperm(Pop_Size,2);
            if rand < 0.5
                Updated_Pop(i,:) = (c1*fi*rand.*(Particles_Pop(Random(1),:)-Particles_Pop(Random(2),:)) + c2*(1-fi)*rand.*gBest_Particles)+theta*abs(meanUpdated_Particles_Pop-Particles_Pop(i,:))*log(1.0/Gus(iterations));
            else
                Updated_Pop(i,:) = (c1*fi*rand.*(Particles_Pop(Random(1),:)-Particles_Pop(Random(2),:)) + c2*(1-fi)*rand.*gBest_Particles)-theta*abs(meanUpdated_Particles_Pop-Particles_Pop(i,:))*log(1.0/Gus(iterations));
            end
        end
        end 
            if rand < 0.5
                Updated_Pop(i,:) = a+theta*abs(meanUpdated_Particles_Pop-Particles_Pop(i,:))*log(1.0/Gus(iterations));
            else
                Updated_Pop(i,:) = a-theta*abs(meanUpdated_Particles_Pop-Particles_Pop(i,:))*log(1.0/Gus(iterations));
            end
    end
    %% Update the population
        Updated_Pop=Particles_Pop+Velocity_Pop;
        Updated_Pop=abs(round(Updated_Pop));
        Particles_Pop=Fix_Up(Particles_Pop,Updated_Pop);
        
    Best_Fitness(iterations) = gBest_Fitness; 
    end
end
% -----------------display the global fitnesses-------------%%
fprintf('Global Best Fitness = %f\t',gBest_Fitness);
fprintf('\n');

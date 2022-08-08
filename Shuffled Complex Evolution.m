%% Shuffled Complex Evolution Parallel Machine Scheduling (SCE-PMS)

clc;
clear;
close all;
global NFE;
NFE=0;

%% Problem Definition
model=CreateModel();        % Create Model of the Problem
CostFunction=@(x) MyCost(x,model);       % Cost Function
nVar=model.nVar;        % Number of Decision Variables
VarSize=[1 nVar];       % Size of Decision Variables Matrix
VarMin = 0;          % Lower Bound of Decision Variables
VarMax = 1;          % Upper Bound of Decision Variables

%% SCE-UA Parameters
MaxIt = 100;        % Maximum Number of Iterations
nPopComplex = 20;                       % Complex Size

nPopComplex = max(nPopComplex, nVar+1); % Nelder-Mead Standard
nComplex = 5;                   % Number of Complexes
nPop = nComplex*nPopComplex;    % Population Size
I = reshape(1:nPop, nComplex, []);
% CCE Parameters
cce_params.q = max(round(0.5*nPopComplex), 2);   % Number of Parents
cce_params.alpha = 3;   % Number of Offsprings
cce_params.beta = 5;    % Maximum Number of Iterations
cce_params.CostFunction = CostFunction;
cce_params.VarMin = VarMin;
cce_params.VarMax = VarMax;

%% Start
% Empty Individual Template
empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Sol = [];

% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);
% Initialize Population Members
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
[pop(i).Cost pop(i).Sol] = CostFunction(pop(i).Position);
end
% Sort Population
pop = SortPopulation(pop);
% Update Best Solution Ever Found
BestSol = pop(1);
% Initialize Best Costs Record Array
BestCosts = nan(MaxIt, 1);

%% SCE-UA Main Loop
for it = 1:MaxIt
% Initialize Complexes Array
Complex = cell(nComplex, 1);
% Form Complexes and Run CCE
for j = 1:nComplex
% Complex Formation
Complex{j} = pop(I(j, :));
% Run CCE
Complex{j} = RunCCE(Complex{j}, cce_params);
% Insert Updated Complex into Population
pop(I(j, :)) = Complex{j};
end
% Sort Population
pop = SortPopulation(pop);
% Update Best Solution Ever Found
BestSol = pop(1);
% Store Best Cost Ever Found
BestCost(it) = BestSol.Cost;
% Store NFE
nfe(it)=NFE;
% Iteration 
disp(['In Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Cost is = ' num2str(BestCost(it))]);
% Plot Res
figure(1);
PlotSolution(BestSol.Sol,model);
end
%% Show Results
figure;
plot(nfe,BestCost,'-og','linewidth',1,'MarkerSize',7,'MarkerFaceColor',[0.9,0.1,0.1]);
title('Shuffled Complex Evolution','FontSize', 15,'FontWeight','bold');
xlabel(' NFE','FontSize', 15,'FontWeight','bold');
ylabel(' Cost Value','FontSize', 15,'FontWeight','bold');
xlim([0 inf])
xlim([0 inf])
ax = gca; 
ax.FontSize = 15; 
set(gca,'Color','b')
legend({'SCE PMS'},'FontSize',12,'FontWeight','bold','TextColor','g');


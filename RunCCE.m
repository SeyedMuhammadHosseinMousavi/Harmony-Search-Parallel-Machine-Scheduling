function pop = RunCCE(pop, params)
%% CCE Parameters
q = params.q;           % Number of Parents
alpha = params.alpha;   % Number of Offsprings
beta = params.beta;     % Maximum Number of Iterations
CostFunction = params.CostFunction;
VarMin = params.VarMin;
VarMax = params.VarMax;
nPop = numel(pop);      % Population Size
P = 2*(nPop+1-(1:nPop))/(nPop*(nPop+1));    % Selection Probabilities
% Calculate Population Range (Smallest Hypercube)
LowerBound = pop(1).Position;
UpperBound = pop(1).Position;
for i = 2:nPop
LowerBound = min(LowerBound, pop(i).Position);
UpperBound = max(UpperBound, pop(i).Position);
end

%% CCE Main Loop
for it = 1:beta
% Select Parents
L = RandSample(P, q);
B = pop(L);
% Generate Offsprings
for k = 1:alpha
% Sort Population
[B, SortOrder] = SortPopulation(B);
L = L(SortOrder);
% Calculate the Centroid
g = 0;
for i = 1:q-1
g = g + B(i).Position;
end
g = g/(q-1);
% Reflection
ReflectionSol = B(end);
ReflectionSol.Position = 2*g - B(end).Position;
if ~IsInRange(ReflectionSol.Position, VarMin, VarMax)
ReflectionSol.Position = unifrnd(LowerBound, UpperBound);
end
[ReflectionSol.Cost ReflectionSol.Sol] = CostFunction(ReflectionSol.Position);
if ReflectionSol.Cost<B(end).Cost
B(end) = ReflectionSol;
else
% Contraction
ContractionSol = B(end);
ContractionSol.Position = (g+B(end).Position)/2;
[ContractionSol.Cost ContractionSol.Sol] = CostFunction(ContractionSol.Position);
if ContractionSol.Cost<B(end).Cost
B(end) = ContractionSol;
else
B(end).Position = unifrnd(LowerBound, UpperBound);
[B(end).Cost B(end).Sol] = CostFunction(B(end).Position);
end
end
end
% Return Back Subcomplex to Main Complex
pop(L) = B;
end
end
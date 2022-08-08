function [pop, SortOrder] = SortPopulation(pop)
% Get Costs
Costs = [pop.Cost];
% Sort the Costs Vector
[~, SortOrder] = sort(Costs);
% Apply the Sort Order to Population
pop = pop(SortOrder);
end
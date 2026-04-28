%% clearning
clc;
clear all;

%% The ques 
% +--------------+-----+-----+-----+-----+------------+
% |              | D1  | D2  | D3  | D4  | Supply ( ) |
% +--------------+-----+-----+-----+-----+------------+
% | S1           | 11  | 13  | 17  | 14  | 10         |
% | S2           | 16  | 18  | 14  | 10  | 5          |
% | S3           | 21  | 24  | 13  | 10  | 9          |
% | S4 (Dummy)   | 0   | 0   | 0   | 0   | 10         |  <-  added to
% +--------------+-----+-----+-----+-----+------------+     balance out
% | Demand ->    | 8   | 7   | 15  | 4   | 34 | 34    | <- Balanced after
% +--------------+-----+-----+-----+-----+------------+     adding dummy

%% Phase 1 

cost = [11 13 17 14;
     16 18 14 10;
     21 24 13 10];

demand = [8 7 15 4];
supply = [10 5 9];
% supply = [10; 5; 9; 10];

m = size(cost, 1); % number of sources
n = size(cost, 2); % number of destinations

%% Phase 2
% Checking balance of the transportation problem

S = sum(supply);
D = sum(demand); 
if (S == D)
    disp("Balanced Transportation Problem")
elseif S < D
    disp('Supply is less than demand. Adjustisting....');
    cost(end + 1, :) = zeros(1, n);
    supply(end + 1) = D - S;
else % S > D
    cost(:, end + 1) = zeros(m, 1);
    demand(end + 1) = S - D;
end
disp('Demand is less than supply. Adjustisting....');
disp("Balanced TP Table: ")
disp([cost supply'; demand sum(supply)])

% Updating number of sources and destinations
[m, n] = size(cost);

%% Phase 3
% Initializing solution set

X = zeros(m , n);  % Number of allocation variables = m * n
Icost = cost;

% stopping condition, till all the supplies and demands are 0
while(any(supply ~= 0) || any(demand ~= 0))
    min_cost = min(cost(:));
    [row, col] = find(cost == min_cost); % i,j for cells with min cost
    y = min(supply(row), demand(col)); % value of the allocation
    [aloc, index] = max(y);
    rr = row(index);
    cc = col(index);
    X(rr, cc) = aloc; % assiging the value to the allocation

    supply(rr) = supply(rr) - aloc;
    demand(cc) = demand(cc) - aloc;

    cost(rr, cc) = inf;
end

cost_eachcell = X.*Icost;
total_cost = sum(cost_eachcell(:))
disp(X)
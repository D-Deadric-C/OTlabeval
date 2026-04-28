%% Max Z = x1 + 2x2 + 3x3 + 0 x4 + 0 x5
% st -> x1 + 2x2 + x4 = 20
% -> 3x1 + 4x3 + x5 = 30 
% all vars > 0

%% Phase 1 
clc;
clear all;

C = [1 2 3 0 0];                % Objective func coeffs
A = [1 2 0 1 0  ; 3 0 4 0 1];   % constraint matrix
b = [20 ; 30];                  % RHS values

m = size(A, 1);                 % rows  i.e. number of constraints
n = size(A, 2);                 % columns i.e. number of variables

%% Phase 2

bv_index = n - m + 1 : n ;      % indexes of basic variables
                                % Slack varibale always start as basis
Y = [A b];
for s = 1:50
    CB = C(bv_index);               % cost coefficients of the current basic variables
    Xb = Y(:, end);                 % inv(B) * b / current values of basic variables = the RHS column
    Z = CB * Xb;                    % Current objective value
    ZjCj = CB * Y(:, 1:n) - C;      % transpose(Cb) * Alpha^j - Cj 

    Table = [ZjCj Z; Y]             % Table print after each

    %% Phase 3 - Checking for optimality
    if all(ZjCj >= 0)
        disp('Optimal solution found.');
        disp('Basic Variables (Xb):');
        disp(Xb);
        disp('Optimal Value (Z):');
        disp(Z);
        break;
    
    else
        % 1) Identify Entering Variable (EV)
        [min_val, EV] = min(ZjCj);   % most negative value enters becuase problem is maximize
    
        % 2) Check for Unboundedness
        if all(Y(:, EV) <= 0)
            disp('Unbounded Solution');
            break;
        end
    
        % 3) Ratio Test -> to find Leaving Variable
        disp('Calculating Ratios...');
        ratio = inf(m,1);   % initialize with infinity
    
        for j = 1:m
            if Y(j, EV) > 0
                ratio(j) = Xb(j) / Y(j, EV);
            end
        end
    
        [min_ratio, Lv] = min(ratio);   
    
        % 4) Pivot Operation
        pivot = Y(Lv, EV);
    
        % Normalize pivot row
        Y(Lv, :) = Y(Lv, :) / pivot;
    
        % Make other entries in pivot column zero
        for i = 1:m
            if i ~= Lv
                Y(i, :) = Y(i, :) - Y(i, EV) * Y(Lv, :);
            end
        end
    
        % 5) Update Basis
        bv_index(Lv) = EV;
    end
end
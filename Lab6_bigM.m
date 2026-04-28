%% Linear Programming – Big M Method
% Max z = -2x1 - x2
% subject to
% 3x1 + x2 = 3
% 4x1 + 3x2 >= 6
% x1 + 2x2 <= 4
% x1, x2 >= 0

%% Phase 1 
clc;
clear all;

M = 1000;   % Big M value

C = [-2 -1 0 -M -M 0];                             % Objective func coeffs
A = [3 1 0 1 0 0  ; 4 3 -1 0 1 0 ; 1 2 0 0 0 1];   % constraint matrix
b = [3 ; 6 ; 4];                                   % RHS values

m = size(A, 1);                 % rows  i.e. number of constraints
n = size(A, 2);                 % columns i.e. number of variables

%% Phase 2

bv_index = n - m + 1 : n ;      % indexes of basic variables
                                % Artificial / slack variables start as basis
Y = [A b];
for s = 1:50
    CB = C(bv_index);               % cost coefficients of the current basic variables
    Xb = Y(:, end);                 % inv(B) * b / current values of basic variables = the RHS column
    Z = CB * Xb;                    % Current objective value
    ZjCj = CB * Y(:, 1:n) - C;      % transpose(Cb) * Alpha^j - Cj 

    Table = [ZjCj Z; Y]             % Table after 1st iteration

    %% Phase 3 - Checking for optimality
    if all(ZjCj >= 0)
        disp('Optimal solution found.');
        disp('Basic Variables (Xb):');
        disp(Xb);
        disp('Basis Indexes:');
        disp(bv_index);
        disp('Optimal Value (Z):');
        disp(Z);
        break;
    
    else
        % 1) Identify Entering Variable (EV)
        [min_val, EV] = min(ZjCj);   % most negative value enters
    
        % 2) Check for Unboundedness
        if all(Y(:, EV) <= 0)
            disp('Unbounded Solution');
            break;
        end
    
        % 3) Ratio Test (to find Leaving Variable)
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
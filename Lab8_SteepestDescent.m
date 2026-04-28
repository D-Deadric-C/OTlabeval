clc
clear
format short

%% Define objective function
syms x1 x2
f = x1 - x2 + 2*x1^2 + 2*x1*x2 + x2^2;

fx = inline(f);
fobj = @(x) fx(x(1), x(2));

%% Gradient
grad = gradient(f);
G = inline(grad);
gradx = @(x) G(x(1), x(2));

%% Hessian
H1 = hessian(f);
Hx = inline(H1);

%% Iterations
x0 = [1; 1];        % FIXED (column vector)
maxiter = 4;
tol = 1e-3;
iter = 0;

while norm(gradx(x0)) > tol && iter < maxiter
    
    S = -gradx(x0);
    H = Hx(x0);
    
    lambda = (S' * S) / (S' * H * S);
    
    x0 = x0 + lambda * S;   % FIXED
    iter = iter + 1;
end

fprintf('Optimal Solution X = [%f, %f]\n', x0(1), x0(2))
fprintf('Optimal Value f(x) = %f\n', fobj(x0))

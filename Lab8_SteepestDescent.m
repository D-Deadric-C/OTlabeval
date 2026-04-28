% CODE FOR STEEPEST DESCENT METHOD
% QUESTION IS - PERFORM 4 ITERATIONS OF STEEPEST DESCENT ALGORITHM TO MINIMIZE
% f(x1,x2) = x1 - x2 + 2*x1^2 + 2*x1*x2 + x2^2

% Starting from the point X1 = [1,1]

format short          % Display output upto 4 digits
clear all             % clear all the stored values
clc                   % Clear the screen

%% Phase 1- Define objective function
syms x1 x2

f1 = x1 - x2 + 2*x1^2 + 2*x1*x2 + x2^2;

fx = inline(f1);   % convert f1 into a function of x1 and x2
fobj = @(x) fx(x(:,1), x(:,2));   % convert function into one variable

%% Phase 2- Compute gradient of f
grad = gradient(f1);
G = inline(grad);  
gradx = @(x) G(x(:,1), x(:,2));

%% Phase 3- Compute Hessian Matrix
H1 = hessian(f1);
Hx = inline(H1);

%% Phase 4- Iterations
x0 = [1 1];         % initial value
maxiter = 4;        % max iterations
tol = 10^(-3);      % tolerance

iter = 0;           
X = [];             % store all iterations

while norm(gradx(x0)) > tol && iter < maxiter
    X = [X; x0];            % store current point

    S = -gradx(x0);         % descent direction
    H = Hx(x0);             % Hessian at x

    lambda = (S'*S) / (S'*H*S);   % step size

    Xnew = x0 + lambda.*S'; 
    x0 = Xnew;              % update

    iter = iter + 1;
end

%% Phase 5- Print the solution
fprintf('Optimal Solution x=[%f, %f]\n', x0(1), x0(2))
fprintf('Optimal Value f(x) = %f\n', fobj(x0))
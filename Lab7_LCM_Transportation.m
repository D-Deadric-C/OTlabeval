clc ;
clear all;
Cost=[11 13 17 14; 16 18 14 10;21 24 13 10];
supply=[10 5 9 ];
demand=[8 7 15 4];
m=size(Cost,1);
n=size(Cost,2);
S=sum(supply);
D=sum(demand);
if(S==D)
    disp('BalancedTP')
elseif(D>S)
    Cost(end+1,:)=zeros(1,n); % Cost(m+1,:)
    supply(end+1)=D-S;
else
    Cost(:,end+1)=zeros(m,1);
    demand(end+1)=S-D
end
disp("Balanced TP Table ")
[Cost supply'; demand sum(supply)]
[m,n]=size(Cost);
X=zeros(m,n);
ICost=Cost;
while(any(supply~=0) || any(demand~=0))
    min_cost=min(Cost(:))
    [r c]=find(Cost==min_cost)
    y=min(supply(r),demand(c))
    [aloc,index]=max(y)
    rr=r(index)
    cc=c(index)
    X(rr, cc)=aloc;
    supply(rr) = supply(rr) - aloc;
    demand(cc) = demand(cc) - aloc;
    Cost(rr, cc) = inf; 
end
% Calculate total cost of the transportation plan
Cost_eachcell= X .* ICost;
Total_Cost=sum(Cost_eachcell(:))
disp(X)






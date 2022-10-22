clc
clear all
close all
lb=2*ones(1,4);
ub=24*ones(1,4);
intcon=[1,2,3,4];
num=7;
options = optimoptions('surrogateopt','MaxFunctionEvaluations',500,'PlotFcn',{'surrogateoptplot',...
    'optimplotfvalconstr','optimplotfval'});
% Solve
[solution,objectiveValue] = surrogateopt(@objconstr_rusboost,lb,ub,intcon,[],[],[],[],...
    options);

% Clear variables
clearvars options
save solution
save objectiveValue

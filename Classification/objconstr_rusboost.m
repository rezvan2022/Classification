function f = objconstr_rusboost(R_Var)
data=readtable('MasterData.xlsx');
save data.mat
load data.mat
disp(head(data));
% rng('default'); % for reproducibility
numObservations = size(data,1);
numObservationsTrain = floor(0.80*numObservations);
numObservationsTest = numObservations - numObservationsTrain;
idx = randperm(numObservations);
idxTrain = idx(1:numObservationsTrain);
idxTest = idx(numObservationsTrain+1:end);
idx = randperm(numObservations);
idxTrain = idx(1:numObservationsTrain);
idxTest = idx(numObservationsTrain+1:end);
X = data(idxTrain,[R_Var(1,1),R_Var(1,2),R_Var(1,3),R_Var(1,4)]);
Y = data(idxTrain,end);
N = sum(idxTrain);         % Number of observations in the training sample
t = templateTree('MaxNumSplits',N);
tic
rusTree = fitcensemble(X,Y,'Method','RUSBoost', ...
    'NumLearningCycles',1000,'Learners',t,'LearnRate',.01,'nprint',100);
figure(1);
tic
plot(loss(rusTree,X,Y,'mode','cumulative'));
toc
X_Hat = data(idxTest,[R_Var(1,1),R_Var(1,2),R_Var(1,3),R_Var(1,4)]);
Y_Hat = table2array(data(idxTest,end));
figure(2);
tic
Yfit = predict(rusTree,X_Hat);
toc
cm=confusionchart(Y_Hat,Yfit,'Normalization','row-normalized','RowSummary','row-normalized')
f.Fval =1-(cm.NormalizedValues(2,2))/(cm.NormalizedValues(2,2)+cm.NormalizedValues(2,1));
f.Ineq=length((R_Var))-length(unique(R_Var))
end
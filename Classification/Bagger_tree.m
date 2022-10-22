clc
clear all
close all
data=readtable('MasterData.xlsx');
save data.mat
load data.mat
disp(head(data));
rng(1); % For reproducibility
nIDs = max(data.ID);
uniqueIDs = unique(data.ID);
rng('default'); % for reproducibility
c = cvpartition(nIDs,'Holdout',0.25);
TrainIDInd = training(c);
TestIDInd = test(c);
TrainDataInd = ismember(data.ID,uniqueIDs(TrainIDInd));
TestDataInd = ismember(data.ID,uniqueIDs(TestIDInd));
X = data(TrainDataInd,2:end-1);
Y = data(TrainDataInd,:).DDD;
rng(1945,'twister')
b = TreeBagger(50,X,Y,'OOBPredictorImportance','On');
figure
plot(oobError(b))
xlabel('Number of Grown Trees')
ylabel('Out-of-Bag Classification Error')
b.DefaultYfit = '';
figure
plot(oobError(b))
xlabel('Number of Grown Trees')
ylabel('Out-of-Bag Error Excluding In-Bag Observations')
X_Hat = data(TestDataInd,2:end-1);
Y_Hat = data(TestDataInd,:).DDD;
Yfit = predict(TreeBagger,X_Hat);
figure(2)
confusionchart(Y_Hat,Yfit,'Normalization','row-normalized','RowSummary','row-normalized')
figure(3)
cm=confusionchart(Y_Hat,Yfit)
cm.NormalizedValues
cm.NormalizedValues(2,2)/(cm.NormalizedValues(2,2)+cm.NormalizedValues(2,1))


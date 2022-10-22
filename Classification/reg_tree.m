clc
clear all
close all
data=readtable('MasterData.xlsx');
save data.mat
load data.mat
disp(head(data));
numObservations = size(data,1);
for i=1:20
numObservationsTrain = floor(0.80*numObservations);
numObservationsTest = numObservations - numObservationsTrain;
idx = randperm(numObservations);
idxTrain = idx(1:numObservationsTrain);
idxTest = idx(numObservationsTrain+1:end);
X = data(idxTrain,2:end-1);
Y = data(idxTrain,:).DDD;     
rusTree=fitctree(X,Y)
% view(rusTree.Trained{1},'Mode','graph')
X_Hat = data(idxTest,2:end-1);
Y_Hat = (data(idxTest,:).DDD);
figure(2);
tic
Yfit = predict(rusTree,X_Hat);
[~,scores] = predict(rusTree,X_Hat)
figure(2)
confusionchart(Y_Hat,Yfit,'Normalization','row-normalized','RowSummary','row-normalized')
figure(3)
cm=confusionchart(Y_Hat,Yfit)
cm.NormalizedValues
cm.NormalizedValues(2,2)/(cm.NormalizedValues(2,2)+cm.NormalizedValues(2,1))
total_cm(i,1)=(cm.NormalizedValues(2,2)+cm.NormalizedValues(1,1))/(cm.NormalizedValues(2,2)+cm.NormalizedValues(1,2)+cm.NormalizedValues(2,1)+cm.NormalizedValues(1,1))
d_cm(i,1)=(cm.NormalizedValues(2,2))/(cm.NormalizedValues(2,2)+cm.NormalizedValues(2,1))
nd_cm(i,1)=(cm.NormalizedValues(1,1))/(cm.NormalizedValues(1,2)+cm.NormalizedValues(1,1))

end



function net = train_cnn();
opts = trainingOptions('rmsprop', ...
    'InitialLearnRate',1e-5, ...
    'MaxEpochs',20, ...
    'Shuffle','every-epoch', ...
    'Verbose',true, ...
    'MiniBatchSize', 100, ...
    'ExecutionEnvironment','auto',...
    'L2Regularization', .01, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 1, ...
    'LearnRateDropPeriod', 20, ...
    'Plots','training-progress');
%     'Plots','none');

load tcr1network_untrained
lgraph_1=layers;
h=fspecial('gaussian',[17,37],2);
h=h/max(h(:));

load tcr1_training_targets
Ntgt=size(all_targets,3);

load tcr1_training_clutter
size(all_clutter)


% xtrain=cat(3,all_targets,3*all_clutter);
xtrain=cat(3,all_targets,all_clutter);

clear all_targets all_clutter
nfiles=size(xtrain,3);
d1=size(xtrain,1); d2=size(xtrain,2);

y1=17; y2=37;
Ytrain=zeros(y1,y2,nfiles);
for i=1:Ntgt
    %Ytrain(21,41,1,i)=1;
    Ytrain(:,:,i)=h;
end

xtrain=reshape(xtrain,[d1 d2 1 nfiles]);
Ytrain=reshape(Ytrain, [y1 y2 1 nfiles]);
net = trainNetwork(xtrain,Ytrain,lgraph_1,opts);
result = predict(net,xtrain);

end
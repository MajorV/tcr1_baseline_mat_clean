layers = [
    imageInputLayer([40 80 1],'DataAugmentation','none','Normalization','none')
    convolution2dLayer([20 40],70,'Padding',[0  0  0  0],'WeightLearnRateFactor',0,'biasLearnRateFactor',0)
    batchNormalizationLayer
    leakyReluLayer(0.1)
    convolution2dLayer([3 3],50,'Padding',[0  0  0  0])
    batchNormalizationLayer
    leakyReluLayer(0.1)
    
    convolution2dLayer([3 3],30,'Padding',[0  0  0  0])
    batchNormalizationLayer
    leakyReluLayer(0.1)
    
    
    convolution2dLayer(1,1,'Padding',[0  0  0  0])
    
maeRegressionLayer('MAE')];

load basis_set
S=[S(:,1:20) S(:,end-49:end)];
S=reshape(S,20,40,1,70);
for i=1:70
    tmp=S(:,:,1,i);
    tmp=tmp-mean2(tmp);
    S(:,:,1,i)=tmp;
end
layers(2).Weights=S;
disp('ok')
save tcr1network_untrained layers
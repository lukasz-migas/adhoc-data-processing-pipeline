function [ rgbData, IDX, cmap, outputSpectralContriubtion  ] = nnTsneFull( data, clusters_num )

subsetSize = ceil(size(data,1) ./ 2500);

subset = data(1:subsetSize:size(data,1),:);
[Coeffs, Scores] = pca(subset);
top50Scores = Scores(:,1:50);
[~, mu, ~] = zscore(subset);
top50Coeffs = Coeffs(:,1:50);
tsneReduced = tsne(subset, 'distance', 'correlation', 'NumDimensions',3);
pcaReduced50Full = (data - repmat(mu,size(data,1),1)) * top50Coeffs;
autoencoder{1} = trainAutoencoder(top50Scores',25, ...
'MaxEpochs',1000, ...
'EncoderTransferFunction', 'logsig',...
'DecoderTransferFunction','logsig', ...
'L2WeightRegularization', 0.0001, ...
'SparsityRegularization', 8, ...
'UseGPU',true, ...
'SparsityProportion',0.1);
featureSpaceSubset{1} = encode(autoencoder{1},top50Scores');
featureSpaceFull{1} = encode(autoencoder{1}, pcaReduced50Full');
autoencoder{2} = trainAutoencoder(featureSpaceSubset{1},10, ...
'MaxEpochs',1000, ...
'EncoderTransferFunction', 'logsig',...
'DecoderTransferFunction','logsig', ...
'L2WeightRegularization', 0.01, ...
'SparsityRegularization', 4, ...
'UseGPU',true, ...
'SparsityProportion',0.1);
featureSpaceSubset{2} = encode(autoencoder{2},featureSpaceSubset{1});
featureSpaceFull{2} = encode(autoencoder{2},featureSpaceFull{1});
trainingMethod = 'trainbr';
neuralNetwork = fitnet(25, trainingMethod);
neuralNetwork.divideParam.trainRatio = 70/100;
neuralNetwork.divideParam.valRatio = 15/100;
neuralNetwork.divideParam.testRatio = 15/100;
[net, performaces] = train(neuralNetwork,featureSpaceSubset{2},tsneReduced');
subsetNeural = sim(net,featureSpaceSubset{2});
reducedNeuralFull = sim(net,featureSpaceFull{2});
for k = 1:3
temp = tsneReduced(:,k);
a = min(temp);
b = max(temp - min(temp));
temp = reducedNeuralFull(k,:);
temp2 = (temp - a) ./ b;
rgbData(:,k) = temp2;
end

if isnan(clusters_num)

    [ IDX, C, ~, ~ ] = kmeans_elbow(rgbData,30);

else
    
    [ IDX, C ] = kmeans(rgbData,clusters_num,'Distance','cosine');
    
end

for i = 1:max(IDX)
inputRGBpoints{i} = C(i,:);
end
C(C<0) = 0;
C(C>1) = 1;
cmap(1,1:3) = 0;
cmap(2:max(IDX)+1,:) = C;
[ reverseNet, outputSpectralContriubtion ] = reverseTsneNeuralNetwork( tsneReduced, top50Scores, top50Coeffs, inputRGBpoints, mu);

end


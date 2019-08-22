function [ reverseNet, outputSpectralContriubtion ] = reverseTsneNeuralNetwork( tsneReducedData, top50Scores, top50Coeffs, inputRGBpoints, mu)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

trainingMethod = 'trainbr';
revereseNeuralNetwork = fitnet(25, trainingMethod);
revereseNeuralNetwork.divideParam.trainRatio = 70/100;
revereseNeuralNetwork.divideParam.valRatio = 15/100;
revereseNeuralNetwork.divideParam.testRatio = 15/100;
[reverseNet, performaces] = train(revereseNeuralNetwork, tsneReducedData', top50Scores');

for k = 1:3
    temp = tsneReducedData(:,k);
    a = min(temp);
    b = max(temp - min(temp));
    for i = 1:length(inputRGBpoints)
        tsnePointsFromRGB{i}(k) = (inputRGBpoints{i}(k) .* b) + a;
    end
end

for i = 1:length(inputRGBpoints)
pca50ScoresFromTSNE{i} = sim(reverseNet, tsnePointsFromRGB{i}');
outputSpectralContriubtion{i} = pca50ScoresFromTSNE{i}'*top50Coeffs' + mu;
end

end


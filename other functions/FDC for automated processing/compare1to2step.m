isManualSelect = 1;
distance = 'cosine';
load('full_colourscheme.mat')
load('F:\Sample number data\PDAC\MALDI pos\nonTilesProcessing2000peaksTumourOnly.mat')
i = 5;
data = processedDataSep{i};
mask = maskSep{i};
perct = 0.1;
cut_off = 500;

%% 1 step FDC
[cl, centroidIdx] = LC_FDC( data,distance,perct,cut_off,isManualSelect);

%% 2 step FDC
%do first half
[ Density, MinDist, NumIns, SortDensity, nneigh, DisMatrix, dc  ] = FDC_toDecisionGraph( data,distance,perct,cut_off);
% do second half
[ cl2step, centroidIdx2step ] = FDC_fromDecisionGraph( Density, MinDist, NumIns, SortDensity, nneigh, DisMatrix, isManualSelect, dc );

%% compare result

h = figure;
subplot(2,1,1)
image = double(mask);
image(image==1) = cl;
imagesc(image)
axis image
colorbar
subplot(2,1,2)
image = double(mask);
image(image==1) = cl2step;
imagesc(image)
axis image
colorbar
colormap(clustmap{max(cl2step)}./255)
%% plot decision graph and add cluster information

h = figure;
hold all
%plot decision graph
plot(Density', MinDist', 's', 'MarkerSize', 7, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'b');
%plot individual centroids (change MarkerFaceColor to match colourscheme of
%clustering
for ss = 1:length(centroidIdx2step)
    plot(Density(centroidIdx2step(ss)), MinDist(centroidIdx2step(ss)),  's', 'MarkerSize', 12,'MarkerFaceColor', clustmap{max(cl2step)}(ss+1,:)./255, 'MarkerEdgeColor', 'r');
end
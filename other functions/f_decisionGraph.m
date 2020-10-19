function [ numClust, centInd ] = f_decisionGraph( rho, delta, isManualSelect, isAutoSelect, topK, path )

% Function using the decision graph to either manually select the k
% clusters centres to keep, or to run a short and simple heuristic aproach
% to selected the top k clusters without manual intervention.
%
% INPUT:
%       rho: local density [row vector]
%       delta: minimum distance between each point and any other point with higher density [row vector]
%       isManualSelect: 1 denote that all the cluster centroids are selected manually, otherwise 0
% OUTPUT:
%       numClust: number of clusters
%       centInd:  centroid index vector

NE = length(rho);
numClust = 0;
centInd = zeros(NE,1);

% Sort clusters based on their distance to rho=1 and delta=1

[ radious_sort, radious_i ] = sort((1-rho).^2+(1-delta).^2); % distance to 1,1

if isManualSelect == 1
    
    fig = figure;
    fprintf('Please manually select a rectangle that includes all cluster centres you would like to keep.\n');
    fprintf('Please note that points of high *rho* and *delta* should be selected as cluster centers.\n');
    plot(rho, delta, 'o', 'MarkerSize', 7, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'w'); axis square; grid on;
    title('Decision Graph', 'FontSize', 12);
    xlabel('\rho');
    ylabel('\delta');
    
    rectangle = getrect;
    minRho = rectangle(1);
    minDelta = rectangle(2);
    
    for i = radious_i'
        if (rho(i) > minRho) && (delta(i) > minDelta)
            numClust = numClust + 1;
            centInd(i) = numClust;
        end
    end
    
    hold on;
    plot(rho(centInd>0), delta(centInd>0), 'o', 'MarkerSize', 14, 'MarkerEdgeColor', 'k'); axis square; grid on;
    title('Decision Graph (o: manually selected clusters)', 'FontSize', 11);
    
elseif isAutoSelect == 1
    
    % Select the top k clusters from the decision graph
    
    % [~, numClust] = max(diff(radious_sort))-1; % Teresa's first idea
    
    Y = prctile(radious_sort,0.05); % Percentile idea
    numClust = sum(radious_sort<=Y);
    
    centInd = zeros(NE,1);
    centInd(radious_i(1:numClust)) = (1:numClust)';
    
    fig = figure;
    plot(rho, delta, 'o', 'MarkerSize', 7, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'w'); axis square; grid on;
    title('Decision Graph', 'FontSize', 12);
    xlabel('\rho');
    ylabel('\delta');
    hold on;
    plot(rho(centInd>0), delta(centInd>0), 'o', 'MarkerSize', 14, 'MarkerEdgeColor', 'k'); axis square; grid on;
    title('Decision Graph (o: auto selected clusters)', 'FontSize', 11);
    
elseif topK>0
        
    numClust = topK;
    
    centInd(radious_i(1:numClust)) = (1:numClust)';
    
    fig = figure;
    plot(rho, delta, 'o', 'MarkerSize', 7, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'w'); axis square; grid on;
    title('Decision Graph', 'FontSize', 12);
    xlabel('\rho');
    ylabel('\delta');
    hold on;
    plot(rho(centInd>0), delta(centInd>0), 'o', 'MarkerSize', 14, 'MarkerEdgeColor', 'k'); axis square; grid on;
    title(['Decision Graph (o: top ' num2str(numClust) ' clusters)'], 'FontSize', 11);    
    
end

cd(path)
savefig(fig,'decision_graph.fig')
saveas(fig,'decision_graph.png','png')
close(fig)
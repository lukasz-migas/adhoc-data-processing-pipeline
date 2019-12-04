function [ idx, C, optimal_numComponents ] = f_kmeans( data, numComponents, distance_metric )

if ~isnan(numComponents)
    
    [ idx, C ] = kmeans( data, numComponents, 'distance', distance_metric );
    
else
    
    [ idx, C , ~, optimal_numComponents ] = kmeans_elbow( data, 30 );
    
end
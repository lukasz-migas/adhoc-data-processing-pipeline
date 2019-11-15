function [ reduced_x,  ]


function [ y, loss, tsne_parameters ] = f_tsne_with_diff_parameters( x )

step = round(size(x,1)/1000);

small_x = x(step:step:(end-step),:);

loss0 = Inf;

for Perplexity = [ 30, 50 ]
    for Distance = [ "cosine" , "correlation" ]
        for Exaggeration = [ 4, 8, 16 ] % size of natural clusters in data
            for NumDimensions = 3
                for NumPCAComponents = [ 3, 10, 50, 0 ]
                    
                    if NumPCAComponents > size(x,2)
                        NumPCAComponents = size(x,2);
                    end
                    
                    for Standardize = 0 % logical([ 0, 1 ])
                        
                        % description = join([ '!!! Distance ' , Distance, ' - Exaggeration ', num2str(Exaggeration), ' - NumDimensions ' , num2str(NumDimensions), ' - NumPCAComponents ', num2str(NumPCAComponents), ' - Perplexity ', num2str(Perplexity), ' - Standardize ', num2str(Standardize) ]);
                        
                        % disp(description)
                        
                        [ ~, loss1 ] = tsne( small_x, 'Distance' , char(Distance), 'Exaggeration', Exaggeration, 'NumDimensions' , NumDimensions, 'NumPCAComponents', NumPCAComponents, 'Perplexity', Perplexity, 'Standardize', Standardize );
                        
                        % figure(); scatter3(y1(:,1),y1(:,2),y1(:,3),'.k'); title({description})
                        
                        if loss1<loss0
                            
                            % y = y1;
                            % loss = loss1;
                            
                            tsne_parameters.distance = Distance;
                            tsne_parameters.exaggeration = Exaggeration;
                            tsne_parameters.numdimensions = NumDimensions;
                            tsne_parameters.numPCAcomponents = NumPCAComponents;
                            tsne_parameters.perplexity = Perplexity;
                            tsne_parameters.standardize = Standardize;
                            
                        end
                        
                        % disp(num2str(loss1))
                        
                    end
                end
            end
        end
    end
end

Distance = tsne_parameters.distance;
Exaggeration = tsne_parameters.exaggeration;
NumDimensions = tsne_parameters.numdimensions;
NumPCAComponents = tsne_parameters.numPCAcomponents;
Perplexity = tsne_parameters.perplexity;
Standardize = tsne_parameters.standardize;

disp(join([ '!!! tsne parameters - Distance ' , Distance, ' - Exaggeration ', num2str(Exaggeration), ' - NumDimensions ' , num2str(NumDimensions), ' - NumPCAComponents ', num2str(NumPCAComponents), ' - Perplexity ', num2str(Perplexity), ' - Standardize ', num2str(Standardize) ]))

[ y, loss ] = tsne( x, 'Distance' , char(Distance), 'Exaggeration', Exaggeration, 'NumDimensions' , NumDimensions, 'NumPCAComponents', NumPCAComponents, 'Perplexity', Perplexity, 'Standardize', Standardize );


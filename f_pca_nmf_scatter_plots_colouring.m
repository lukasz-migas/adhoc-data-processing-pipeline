function matrix2plot = f_pca_nmf_scatter_plots_colouring( mva_output, datacube_cell )

% Assembling datasets

min_rn = 0;
starti = 1;
for file_index = 1:length(datacube_cell)
        
    endi = starti+datacube_cell{file_index}.width*datacube_cell{file_index}.height-1;
            
    mva_output0 = mva_output(starti:endi,:);
    
    starti = endi+1;
    
    vector2plot = mva_output0;
    vector2plot(isnan(vector2plot)) = [];
    
    vector_cell2plot{file_index} = vector2plot;
        
    min_rn = max(min_rn,size(vector2plot,1));
    
end

matrix2plot = NaN*ones(min_rn,length(datacube_cell));
for file_index = 1:size(vector_cell2plot,2)
    matrix2plot(1:size(vector_cell2plot{file_index},1),file_index) = vector_cell2plot{file_index};
end

% matrix2plot col represent each ROI
% matrix2plot row represent the mva_output values
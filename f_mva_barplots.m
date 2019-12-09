function [ mean_perc2plot, mean_intensity2plot ] = f_mva_barplots( mva_output, datacube_cell, smaller_masks_cell, outputs_xy_pairs )

% Image collage

perc2plot = NaN*ones(max(outputs_xy_pairs(:,1)),max(outputs_xy_pairs(:,2)));
intensity2plot = NaN*ones(max(outputs_xy_pairs(:,1)),max(outputs_xy_pairs(:,2)));

starti = 1;

for file_index = 1:length(datacube_cell)
    
    endi = starti+datacube_cell{file_index}.width*datacube_cell{file_index}.height-1;
    
    mva_output0 = mva_output(starti:endi,:);
           
    if sum(mva_output0,1)~=0
        
        starti = endi+1;
        
        % Segmentation
        
        perc2plot(outputs_xy_pairs(file_index,1),outputs_xy_pairs(file_index,2)) = sum(logical(mva_output0))./sum(smaller_masks_cell{file_index});
        
        % PCA and NMF
        
        intensity2plot(outputs_xy_pairs(file_index,1),outputs_xy_pairs(file_index,2)) = nanmedian(mva_output0(logical(mva_output0~=0)));
        
    else
        
        starti = endi+1;
                
        perc2plot(outputs_xy_pairs(file_index,1),outputs_xy_pairs(file_index,2)) = 0;
        intensity2plot(outputs_xy_pairs(file_index,1),outputs_xy_pairs(file_index,2)) = 0;
        
    end
    
end

mean_perc2plot = nanmean(perc2plot,2);
mean_intensity2plot = nanmean(intensity2plot,2);
    
end

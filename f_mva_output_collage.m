function image2plot = f_mva_output_collage( mva_output, datacube_cell, outputs_xy_pairs )

% Image collage

min_cn = 0;
min_rn = 0;
image_cell2plot = {};
starti = 1;
for file_index = 1:length(datacube_cell)
        
    endi = starti+datacube_cell{file_index}.width*datacube_cell{file_index}.height-1;
            
    mva_output0 = mva_output(starti:endi,:);
    
    starti = endi+1;
    
    image2plot = reshape(mva_output0,datacube_cell{file_index}.width,datacube_cell{file_index}.height)';
    image2plot(isnan(image2plot)) = 0;
    
    rows = (sum(image2plot,2)==0); image2plot(rows,:) = [];
    cols = (sum(image2plot,1)==0); image2plot(:,cols) = [];
    
    image_cell2plot{outputs_xy_pairs(file_index,1),outputs_xy_pairs(file_index,2)} = image2plot;
    
    min_cn = max(min_cn,size(image2plot,2));
    min_rn = max(min_rn,size(image2plot,1));
    
end

image2plot = [];
for ri = 1:size(image_cell2plot,1)
    
    image2plot3 = [];
    for ci = 1:size(image_cell2plot,2)
        
        image2plot0 = image_cell2plot{ri,ci};
        image2plot1 = [ zeros(size(image2plot0,1), floor(max(0,(min_cn-size(image2plot0,2))/2))), image2plot0, zeros(size(image2plot0,1), ceil(max(0,(min_cn-size(image2plot0,2))/2))) ];
        image2plot2 = [ zeros(floor(max(0,(min_rn-size(image2plot1,1))/2)),size(image2plot1,2)); image2plot1; zeros(ceil(max(0,(min_rn-size(image2plot1,1))/2)),size(image2plot1,2)) ];
        image2plot3 = [ image2plot3 image2plot2 ];
        
    end
    
    image2plot = [ image2plot; image2plot3 ];
    
end

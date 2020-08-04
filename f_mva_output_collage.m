function image2plot = f_mva_output_collage( mva_output, data_cell, outputs_xy_pairs )

% Image collage

min_cn = 0;
min_rn = 0;
image_cell2plot = {};
endi = 0;
for file_index = 1:length(data_cell)
                   
    starti = endi + 1;
    endi = starti+data_cell{file_index}.width*data_cell{file_index}.height-1;
    
    mva_output0 = mva_output(starti:endi,:); % MVAs results corresponde to all pixels in the imzml file.
    mva_output0(mva_output0==0) = []; % Removing all pixels with value equal to 0 (irrelavant for plotting MVAs results).
    
    x_coord = data_cell{file_index}.pixels_coord(:,1);
    y_coord = data_cell{file_index}.pixels_coord(:,2);
    
    x_coord = x_coord-min(x_coord)+1; % Reducing the image to the minimum possible rectangle.
    y_coord = y_coord-min(y_coord)+1;
    
    image2plot = zeros(max(x_coord), max(y_coord));
        
    for i = 1:size(x_coord,1); image2plot(x_coord(i),y_coord(i)) = mva_output0(i); end % Bulding the image of each individual small mask.
       
    image_cell2plot{outputs_xy_pairs(file_index,1),outputs_xy_pairs(file_index,2)} = image2plot; % Collecting all the images of the small masks.
    
    min_cn = max(min_cn,size(image2plot,2));
    min_rn = max(min_rn,size(image2plot,1));
    
end

% Building the image of the large grid (which contains all small masks).

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

function f_data_4_cnn_ca( filesToProcess, main_mask_list, smaller_masks_list, dataset_name, txt_or_mat )

for main_mask = main_mask_list
    
    % Main mask - Mask used at the preprocessing step (usually tissue only).
    % Small mask - Mask used to plot the results in the shape of a grid
    % defined by the user (it can be a reference to a particular piece of
    % tissue or a set of tissues).
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        % Defining all the paths needed.
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        rois_path               = [ char(outputs_path) '\rois\' ];
        data4sup_class_path     = [ char(outputs_path) '\data 4 cnn\' ];
        
        % Loading datacubes, peak details, and database matching information
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'datacube' ])
        
        % Loading large mask (usually tissue)
        
        clear roi
        load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'roi'])
        large_masks_logical = logical(reshape(roi.pixelSelection',[],1));
        large_masks = repmat("background",size(large_masks_logical,1),1);
        large_masks(large_masks_logical,:) = main_mask;
        
        % Loading small masks (usually labels)
        
        small_masks_logical = logical(zeros(size(large_masks_logical,1),size(smaller_masks_list,1)));
        small_masks = repmat("background",size(large_masks_logical,1),1);
        for i = 1:size(smaller_masks_list,1)
            clear roi
            roi_file = [ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(smaller_masks_list(i)) filesep 'roi.mat'];
            if exist(roi_file,'file')==2
                load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(smaller_masks_list(i)) filesep 'roi'])
                small_masks_logical(:,i) = logical(reshape(roi.pixelSelection',[],1));
                small_masks(small_masks_logical(:,i),:) = smaller_masks_list(i);
            end
        end
               
        % Initialising the data table
        
        if file_index==1
            data_table = [ string(datacube.spectralChannels') "dataset" "large mask" "small mask" "x_coordinates" "y_coordinates" ];
        end
        
        % Remove rows and columns that are only "background" (using the smaller masks to reduce the big mask)
        
        pixels_image = reshape(datacube.pixelIndicies,datacube.width,datacube.height);
        mask_image = reshape(sum(large_masks_logical.*small_masks_logical,2),datacube.width,datacube.height);
        
        x2keep = repmat(sum(mask_image,2)>0,1,size(mask_image,2));
        y2keep = repmat(sum(mask_image,1)>0,size(mask_image,1),1);
        pixels2keep = reshape(pixels_image(logical(x2keep.*y2keep)),[],1);
        
        % Data
        
        data_col = datacube.data(pixels2keep,:);
        
        % Dataset, large and small masks
        
        dataset_col = repmat(filesToProcess(file_index).name(1,1:end-6),sum(pixels2keep(:)>0),1);
        large_masks_col = large_masks(pixels2keep,1);
        small_masks_col = small_masks(pixels2keep,1);
        
        % Coordinates
        
        x_coord_col = datacube.pixels(pixels2keep,1);
        y_coord_col = datacube.pixels(pixels2keep,2);
        
        % Updating the data table
        
        data_table(size(data_table,1)+(1:sum(pixels2keep(:)>0)),:) = [ data_col dataset_col large_masks_col small_masks_col x_coord_col y_coord_col ];
        
    end
    
    % Results
    
    mkdir([ data4sup_class_path filesep char(dataset_name) filesep ])
    cd([ data4sup_class_path filesep char(dataset_name) filesep ])
    
    disp('. Writting data file...')
    
    if strcmpi(txt_or_mat,"txt")
        
        txt_row = strcat(repmat('%s\t',1,size(data_table,2)-1),'%s\n');
        
        fileID = fopen('data4cnn.txt','w');
        fprintf(fileID,txt_row, data_table');
        fclose(fileID);
        
    elseif strcmpi(txt_or_mat,"mat")
        
        save('data_table.mat','data_table','-v7.3')
        
    end
    
    disp('. Data file saved!')
    
end
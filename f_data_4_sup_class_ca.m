function f_data_4_sup_class_ca( filesToProcess, main_mask_list, smaller_masks_list, dataset_name )

classes = f_classes_4_sup_class(dataset_name);

for main_mask = main_mask_list
    
    % Main mask - Mask used at the preprocessing step (usually tissue only).
    % Small mask - Mask used to plot the results in the shape of a grid
    % defined by the user (it can be a reference to a particular piece of
    % tissue or a set of tissues).
    
    for file_index = [13 16 34] % 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        % Defining all the paths needed.
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        rois_path               = [ char(outputs_path) '\rois\' ];
        
        data4sup_class_path     = [ char(outputs_path) '\data 4 sup class\' ];
        
        % Loading datacubes, peak details, and database matching information
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacube' ])
        
        % Loading smaller masks information
        
        load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(smaller_masks_list(file_index)) filesep 'roi'])
        
        mask = logical((sum(datacube.data,2)>0).*reshape(roi.pixelSelection',[],1));
        
        % Data
        
        data = datacube.data(mask,:);
        pixelsi = datacube.pixelIndicies(mask,:);
        
        % small coordinates
        
        image0 = reshape(mask,datacube.width,datacube.height)'; % figure; imagesc(image0)
        image1 = image0(sum(image0,2)>0,sum(image0,1)>0); % figure; imagesc(image1)
        
        clear row_num col_num
        i = 0;
        for rowi = 1:size(image1,1)
            for coli = 1:size(image1,2)
                if image1(rowi,coli)>0
                    i = i+1;
                    row_num(i,1) = rowi;
                    col_num(i,1) = coli;
                end
            end
        end
                
        % Labels
        
        big_label = repmat(string(filesToProcess(file_index).name(1,1:end-6)),size(data,1),1);
        small_label = repmat(classes(file_index,1),size(data,1),1);
        small_mask_name = repmat(smaller_masks_list(file_index),size(data,1),1);
        sample_num = repmat(file_index,size(data,1),1);
        
        if file_index==1
            data_table = [ string(datacube.spectralChannels') "dataset" "roi" "label" "roi_id" "x_coord" "y_coord"];
        end
        
        data_table = [ data_table; [ data big_label small_mask_name small_label sample_num row_num col_num ] ];
        
    end
    
    % Results
    
    mkdir([ data4sup_class_path filesep char(dataset_name) filesep ])
    cd([ data4sup_class_path filesep char(dataset_name) filesep ])
    
    txt_row = strcat(repmat('%s\t',1,size(data_table,2)-1),'%s\n');
    
    fileID = fopen('data_table_image_info.txt','w');
    fprintf(fileID,txt_row, data_table');
    fclose(fileID);
    
end
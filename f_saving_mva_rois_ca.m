function f_saving_mva_rois_ca( filesToProcess, main_mask_list, dataset_name, mva_list, numComponents_list, norm_list, mva_specifics )

csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
mva_path                = [ char(outputs_path) '\mva ' char(mva_specifics) '\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
rois_path               = [ char(outputs_path) '\rois\' ];

for main_mask = main_mask_list
    
    mvai = 0;
    for mva_type = mva_list
        mvai = mvai+1;
        numComponents = numComponents_list(mvai);
        
        for norm_type = norm_list
            
            idx_indexes_information = string([]);
            
            starti = 1;
            for file_index = 1:length(filesToProcess)
                
                load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\width' ]); % Loading original images width and height
                load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\height' ]); % Loading original images width and height
                
                endi = starti+width*height-1;
                
                idx_indexes_information(file_index,1) = filesToProcess(file_index).name(1,1:end-6);
                idx_indexes_information(file_index,2) = starti;
                idx_indexes_information(file_index,3) = endi;
                
                starti = endi+1;
            
            end
            
            if isnan(numComponents)
                
                load([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\idx' ]);
                idx0 = idx; clear idx
                
            else
                
                load([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\idx' ]);
                idx0 = idx; clear idx
                
            end
            
            for file_name = unique(idx_indexes_information(:,1))'
                
                which_files = strcmpi(file_name,idx_indexes_information(:,1))';
                
                idx = 0;
                
                for ii = find(which_files)
                    
                    idx = idx + idx0(double(idx_indexes_information(ii,2)):double(idx_indexes_information(ii,3)),:);
                    
                end
                
                if isnan(numComponents)
                    
                    mkdir([ rois_path char(file_name) '\mva based rois\' char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\mva ' char(mva_specifics) '\' ])
                    cd([ rois_path char(file_name) '\mva based rois\' char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\mva ' char(mva_specifics) '\' ])
                    
                else
                    
                    mkdir([ rois_path char(file_name) '\mva based rois\' char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\mva ' char(mva_specifics) '\' ])
                    cd([ rois_path char(file_name) '\mva based rois\' char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\mva ' char(mva_specifics) '\' ])
                    
                end
                
                save('idx','idx')
                
                load([ spectra_details_path char(file_name) '\' char(main_mask) '\width' ]); % Loading original images width and height
                load([ spectra_details_path char(file_name) '\' char(main_mask) '\height' ]); % Loading original images width and height
                
                for idx_i = unique(idx)'
                    
                    roi_mask = logical(reshape(logical(idx==idx_i),width,height)');
                    
                    roi = RegionOfInterest(width,height);
                    roi.addPixels(roi_mask)
                    
                    figure();
                    
                    imagesc(roi.pixelSelection); axis image
                    colormap gray;
                    title({['component ' num2str(idx_i)]})
                    
                    mkdir(['component ' num2str(idx_i)])
                    cd(['component ' num2str(idx_i)])
                    
                    save('roi','roi')
                    
                    cd('..')
                    
                end
                
                clear idx
                
            end
        end
    end
end

function f_saving_ion_intensities_table( filesToProcess, main_mask_list, smaller_masks_list, norm_list )

disp(' ')
disp('! Please make sure that every small mask has a unique name.')
disp('This script works by searching for each individual small mask within the rois folder of each individual imzml. Masks with same name (even if for different imzmls) will be combined.')
disp(' ')

filesToProcess = f_unique_extensive_filesToProcess(filesToProcess); % Reducing the list of files that needs to be read.
smaller_masks_list = reshape(unique(smaller_masks_list),[],1);

csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
rois_path               = [ char(outputs_path) '\rois\' ];
table_path              = [ char(outputs_path) '\ion intensities table\' ]; if ~exist(table_path, 'dir'); mkdir(table_path); end

for main_mask = main_mask_list
    
    for norm_type = norm_list
        
        data4roc = [];
        pixels_per_model = [];
        small_mask_1 = 0;
        
        roi_mean_col_names_1 = string([]);
        roi_median_col_names_1 = string([]);
        
        for file_index = 1:length(filesToProcess)
            
            disp(['! Loading ' filesToProcess(file_index).name(1,1:end-6) ' data...'])
                
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\' char(norm_type) '\data.mat' ])
            
            % Data compilation
            
            data4roc = [ data4roc; data ];
            
            % Masks compilation
            
            pixels_per_model0 = zeros(size(data,1),1);
            
            %
            
            all_folders = dir([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep '*']);
            all_folders_names = string([]); for fi = 3:size(all_folders,1); all_folders_names(fi-2) = all_folders(fi).name; end
            
            [ common1, all_folders_names_i1, ~ ] = intersect(all_folders_names, smaller_masks_list);
            
            if ~isempty(common1)
                
                disp(filesToProcess(file_index).name(1,1:end-6))
                
                for aux_i = all_folders_names_i1'
                    small_mask_1 = small_mask_1 + 1;
                    
                    disp(all_folders_names(aux_i))
                    
                    roi_mean_col_names_1 = [ roi_mean_col_names_1, join([all_folders_names(aux_i), " mean" ]) ];
                    roi_median_col_names_1 = [ roi_median_col_names_1, join([all_folders_names(aux_i), " median" ]) ];
                    
                    load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(all_folders_names(aux_i)) filesep 'roi' ])
                    
                    model_mask = reshape(roi.pixelSelection',[],1);
                    pixels_per_model0(:,1) = pixels_per_model0(:,1) + small_mask_1*model_mask.*~pixels_per_model0(:,1);
                    
                end
                
            end
            
            pixels_per_model = [ pixels_per_model; pixels_per_model0 ];
            
            disp(join(['# pixels: ' num2str(sum(pixels_per_model0,1))]))
            
        end
        
        disp('! Loading peak assigments information.')
                
        load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\hmdb_sample_info' ])
        load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
        
        extended_hmdb_sample_info = [
            hmdb_sample_info
            [ relevant_lists_sample_info, repmat("",size( relevant_lists_sample_info,1),size(hmdb_sample_info,2)-size(relevant_lists_sample_info,2))]
            ];
        
        new_hmdb_sample_info = f_saving_curated_hmdb_info( extended_hmdb_sample_info, relevant_lists_sample_info );
        
        table = [ "meas mz", "molecule", "mono mz", "adduct", "ppm", "database (by mono mz)", roi_mean_col_names_1, roi_mean_col_names_2, roi_median_col_names_1, roi_median_col_names_2 ];
        
        for mzi = 1:size(datacube.spectralChannels,1)
                        
            d1 = NaN*ones(size(data4roc,1),size(unique(pixels_per_model(:,1)),1));
            i = 0;
            for maski = unique(pixels_per_model(:,1))'
                i = i+1;
                d1(logical(pixels_per_model(:,1) == maski),i) = data4roc(logical(pixels_per_model(:,1) == maski),mzi);
            end
            d1 = d1(:,2:end);
            d1(d1==0)=NaN;
            
            mean_d1     = mean(d1,1,'omitnan');
            median_d1   = median(d1,1,'omitnan');
                        
            if sum(~isnan(mean_d1))>0 && sum(~isnan(mean_d2))>0
                                
                indexes2add = (abs(datacube.spectralChannels(mzi)-double(new_hmdb_sample_info(:,3))) < 1e-10);
                
                if sum(indexes2add) >= 1
                    
                    aux_row = string(repmat([ mean_d1, mean_d2, median_d1, median_d2 ], sum(indexes2add), 1));
                    aux_row(ismissing(aux_row)) = "NaN";
                    
                    table = [
                        table
                        [ new_hmdb_sample_info(indexes2add,[3 1:2 4:end]), aux_row ]
                        ];
                    
                else
                    
                    aux_row = string(repmat([ p_ttest2_mean, p_ranksum_mean, mean_d1, mean_d2, p_ttest2_median, p_ranksum_median, median_d1, median_d2, datacube.spectralChannels(mzi)], 1, 1));
                    aux_row(ismissing(aux_row)) = "NaN";
                    
                    table = [
                        table
                        [ aux_row, repmat("not assigned", 1, size(new_hmdb_sample_info(indexes2add,[1:2 4:end]),2)) ]
                        ];
                    
                end
                
            end
            
        end
        
        mkdir([ table_path char(main_mask) '\' char(norm_type) ])
        cd([ table_path char(main_mask) '\' char(norm_type) ])
        
        save('ion_intensities_table.mat','table')
        
        txt_row = strcat(repmat('%s\t',1,size(table,2)-1),'%s\n');
        
        fileID = fopen('ion_intensities_table.txt','w');
        fprintf(fileID,txt_row, table');
        fclose(fileID);
        
    end
    
end

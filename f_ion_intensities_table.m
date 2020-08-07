function f_ion_intensities_table( filesToProcess, main_mask_list, smaller_masks_list, norm_list )

disp(' ')
disp('! Please make sure that every small mask has a unique name.')
disp(' ')
disp('This script works by searching for each individual small mask, within the rois folder of each individual imzml.')
disp('Masks with the same name (even if for different imzmls) will be combined.')
disp(' ')

smaller_masks_list = reshape(unique(smaller_masks_list),[],1); % Reducing the list of small masks that need to be considered.

csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
rois_path               = [ char(outputs_path) '\rois\' ];
table_path              = [ char(outputs_path) '\ion intensities table\' ]; if ~exist(table_path, 'dir'); mkdir(table_path); end

for main_mask = main_mask_list
    
    for norm_type = norm_list
        
        col_mean = string([]);
        col_median = string([]);
        small_mask_1 = 0;
        data4stats = [];
        pixels_per_model = [];
        
        for file_index = 1:length(filesToProcess)
            
            % Loading data
            
            disp(['! Loading ' filesToProcess(file_index).name(1,1:end-6) ' data...'])
                
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\' char(norm_type) '\data.mat' ])
            if file_index == 1; load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacubeonly_peakDetails.mat' ]); end
            
            % Masks compilation

            all_folders = dir([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep '*']);
            all_folders_names = string([]); for fi = 3:size(all_folders,1); all_folders_names(fi-2) = all_folders(fi).name; end
            
            [ common1, all_folders_names_i1, ~ ] = intersect(all_folders_names, smaller_masks_list);
            
            pixels_per_model0 = zeros(size(data,1),1); 
            if ~isempty(common1)
                
                for aux_i = all_folders_names_i1'
                    small_mask_1 = small_mask_1 + 1;
                    disp([' . ' char(all_folders_names(aux_i)) ])
                    
                    col_mean(1,small_mask_1) = string([ char(all_folders_names(aux_i)), ' mean']);
                    col_median(1,small_mask_1) = string([ char(all_folders_names(aux_i)), ' median']);
                    
                    load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(all_folders_names(aux_i)) filesep 'roi' ])
                    
                    model_mask = reshape(roi.pixelSelection',[],1);
                    pixels_per_model0 = pixels_per_model0 + small_mask_1*model_mask.*~pixels_per_model0;
                end
                
                % Data compilation
            
                data4stats = [ data4stats; data(pixels_per_model0>0,:) ];
                pixels_per_model = [ pixels_per_model; pixels_per_model0(pixels_per_model0>0,:) ];

            end
            
            disp(join(['# pixels (per group): ' num2str(sum(pixels_per_model0>0))]))
            
        end
        
        disp(join(['! total # pixels (per group): ' num2str(sum(pixels_per_model>0))]))
                        
        load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\hmdb_sample_info' ])
        load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
        
        extended_hmdb_sample_info = [
            hmdb_sample_info
            [ relevant_lists_sample_info, repmat("",size( relevant_lists_sample_info,1),size(hmdb_sample_info,2)-size(relevant_lists_sample_info,2))]
            ];
        
        new_hmdb_sample_info = f_saving_curated_hmdb_info( extended_hmdb_sample_info, relevant_lists_sample_info );
        
        disp('! Computing mean and median intensities for each small mask...')
        
        table = [ "meas mz", "molecule", "mono mz", "adduct", "ppm", "database (by mono mz)", col_mean, col_median ];
        
        for mzi = 1:size(datacubeonly_peakDetails(:,2),1)
            
            switch mzi/size(datacubeonly_peakDetails(:,2),1)
                case 1/4; disp('! 1/4')
                case 2/4; disp('! 2/4')
                case 3/4; disp('! 3/4')
                case 4/4; disp('! 4/4')
            end
                        
            d1 = NaN*ones(size(data4stats,1),size(unique(pixels_per_model),1));
            i = 0;
            for maski = unique(pixels_per_model)'
                i = i+1;
                d1(pixels_per_model == maski,i) = data4stats(pixels_per_model == maski,mzi);
            end
            d1(d1==0)=NaN;
            
            mean_d1     = mean(d1,1,'omitnan');
            median_d1   = median(d1,1,'omitnan');
                        
            if sum(~isnan(mean_d1))>0
                                
                indexes2add = (abs(datacubeonly_peakDetails(mzi,2)-double(new_hmdb_sample_info(:,3))) < 1e-10);
                
                if sum(indexes2add) >= 1
                    
                    aux_row = string(repmat([ mean_d1, median_d1 ], sum(indexes2add), 1));
                    aux_row(ismissing(aux_row)) = "NaN";
                    
                    table = [
                        table
                        [ new_hmdb_sample_info(indexes2add,[3 1:2 4:end]), aux_row ]
                        ];
                    
                else
                    
                    aux_row = string(repmat([ mean_d1, median_d1 ], 1, 1));
                    aux_row(ismissing(aux_row)) = "NaN";
                    
                    table = [
                        table
                        [ num2str(datacubeonly_peakDetails(mzi,2)), repmat("not assigned", 1, size(new_hmdb_sample_info(indexes2add,[1:2 4:end]),2)), aux_row ]
                        ];
                    
                end
                
            end
            
        end
        
        disp('! Saving table...')
        
        mkdir([ table_path char(main_mask) '\' char(norm_type) ])
        cd([ table_path char(main_mask) '\' char(norm_type) ])
        
        save('ion intensities table.mat','table')
        
        txt_row = strcat(repmat('%s\t',1,size(table,2)-1),'%s\n');
        
        fileID = fopen('ion_intensities_table.txt','w');
        fprintf(fileID,txt_row, table');
        fclose(fileID);
        
        disp('! Complete.')
        
    end
    
end

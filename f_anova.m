function f_anova( filesToProcess, main_mask_list, norm_list, anova )

disp(' ')
disp('! Please make sure that every small mask has a unique name.')
disp(' ')
disp('This script works by searching for each individual small mask, within the rois folder of each individual imzml.')
disp('Masks with the same name (even if for different imzmls) will be combined.')
disp(' ')

filesToProcess = f_unique_extensive_filesToProcess(filesToProcess); % This function collects all files that need to have a common axis.

csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
anova_path              = [ char(outputs_path) '\anova\' ]; if ~exist(anova_path, 'dir'); mkdir(anova_path); end
rois_path               = [ char(outputs_path) '\rois\' ];

for main_mask = main_mask_list
    
    for norm_type = norm_list
        
        col_mean = string([]);
        col_median = string([]);
        
        data4anova = [];
        pixels_per_model = [];
        
        for file_index = 1:length(filesToProcess)
            
            % Loading data
            
            disp(['! Loading ' filesToProcess(file_index).name(1,1:end-6) ' data...'])
            
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\' char(norm_type) '\data.mat' ])
            
            if file_index == 1
                load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacubeonly_peakDetails.mat' ])
            end
            
            % Masks compilation
            
            all_folders = dir([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep '*']);
            all_folders_names = string([]); for fi = 3:size(all_folders,1); all_folders_names(fi-2) = all_folders(fi).name; end
            
            pixels_per_model0 = zeros(size(data,1),1);
            
            for anovamaski = 1:length(anova.masks)
                
                [ common, all_folders_names_i, ~ ] = intersect( all_folders_names, anova.masks(anovamaski) );
                
                if ~isempty(common)
                    
                    for aux_i = all_folders_names_i'
                        disp([' . ' char(all_folders_names(aux_i)) ])
                        
                        col_mean(1,anovamaski) = string([ char(all_folders_names(aux_i)), ' mean']);
                        col_median(1,anovamaski) = string([ char(all_folders_names(aux_i)), ' median']);
                        
                        load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(all_folders_names(aux_i)) filesep 'roi' ])
                        
                        model_mask = reshape(roi.pixelSelection',[],1);
                        pixels_per_model0(:,1) = pixels_per_model0(:,1) + model_mask.*anovamaski.*~pixels_per_model0(:,1);
                        disp(join(['# pixels (per mask): ' num2str(sum(pixels_per_model0(:,1)==anovamaski,1))]))
                    end
                    
                end
                
            end
            
            % Data compilation
            
            rows = logical(sum(pixels_per_model0,2)>0);
            data4anova = [ data4anova; data(rows,:) ];
            pixels_per_model = [ pixels_per_model; pixels_per_model0(rows,:) ];
            
        end
        
        load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\hmdb_sample_info' ])
        load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
        
        extended_hmdb_sample_info = [
            hmdb_sample_info
            [ relevant_lists_sample_info, repmat("",size( relevant_lists_sample_info,1),size(hmdb_sample_info,2)-size(relevant_lists_sample_info,2))]
            ];
        
        new_hmdb_sample_info = f_saving_curated_hmdb_info( extended_hmdb_sample_info, relevant_lists_sample_info );
        
        %%% Anova
        
        mean_col_names = [];
        median_col_names = [];
        for wayi = 1:length(anova.labels)
            mean_col_names = [ mean_col_names, string([ 'p value for ' anova.labels{wayi} ' effect (mean)' ]) ];
            median_col_names = [ median_col_names, string([ 'p value for ' anova.labels{wayi} ' effect (median)' ]) ];
        end
        
        anova_analysis_table = [ ...
            mean_col_names, col_mean, ...
            median_col_names, col_median, ...
            "meas mz", "molecule", "mono mz", "adduct", "ppm", "database (by mono mz)"
            ];
        
        for mzi = 1:size(data4anova,2)
            
            mean_d = zeros(1,length(anova.masks));
            median_d = zeros(1,length(anova.masks));
            
            for anovamaski = unique(pixels_per_model)'
                mean_d(1,anovamaski) = mean(data4anova(pixels_per_model(:,1)==anovamaski,mzi),'omitnan');
                median_d(1,anovamaski) = median(data4anova(pixels_per_model(:,1)==anovamaski,mzi),'omitnan');
            end
            
            if sum(~isnan(mean_d))>0
                
                [ mean_p, ~, ~, ~ ] = anovan(mean_d, anova.effects, 'display','off');
                [ median_p, ~, ~, ~ ] = anovan(median_d, anova.effects, 'display','off');
                
                indexes2add = (abs(datacubeonly_peakDetails(mzi,2)-double(new_hmdb_sample_info(:,3))) < 1e-10);
                
                if sum(indexes2add) >= 1
                    
                    aux_row = string(repmat([ mean_p', mean_d, median_p', median_d ], sum(indexes2add), 1));
                    aux_row(ismissing(aux_row)) = "NaN";
                    
                    anova_analysis_table = [
                        anova_analysis_table
                        [ aux_row, new_hmdb_sample_info(indexes2add,[3 1:2 4:end]) ]
                        ];
                    
                else
                    
                    aux_row = string(repmat([ mean_p', mean_d, median_p', median_d, datacubeonly_peakDetails(mzi,2)], 1, 1));
                    aux_row(ismissing(aux_row)) = "NaN";
                    
                    anova_analysis_table = [
                        anova_analysis_table
                        [ aux_row, repmat("not assigned", 1, size(new_hmdb_sample_info(indexes2add,[1:2 4:end]),2)) ]
                        ];
                    
                end
                
            end
            
        end
        
        mkdir([ anova_path char(main_mask) '\' char(norm_type) ])
        cd([ anova_path char(main_mask) '\' char(norm_type) ])
        
        file_name = 'anova';
        for wayi = 1:length(anova_effects_names)
            file_name = [file_name, ['-', anova_effects_names{wayi}]];
        end
        
        save([ file_name '.mat' ],'anova_analysis_table' )
        
        txt_row = strcat(repmat('%s\t',1,size(anova_analysis_table,2)-1),'%s\n');
        
        fileID = fopen([ file_name '.txt' ],'w');
        fprintf(fileID,txt_row, anova_analysis_table');
        fclose(fileID);
        
    end
    
end

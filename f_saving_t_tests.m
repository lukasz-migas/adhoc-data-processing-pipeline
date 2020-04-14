function f_saving_t_tests( filesToProcess, main_mask_list, group0, group0_name, group1, group1_name, norm_list )

filesToProcess = f_unique_extensive_filesToProcess(filesToProcess); % This function collects all files that need to have a common axis.

csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
ttest_path              = [ char(outputs_path) '\ttest\' ]; if ~exist(ttest_path, 'dir'); mkdir(ttest_path); end
rois_path               = [ char(outputs_path) '\rois\' ];

for main_mask = main_mask_list
    
    for norm_type = norm_list
        
        data4roc = [];
        pixels_per_model = [];
        small_mask_1 = 0;
        small_mask_2 = 0;
        
        roi_mean_col_names_1 = string([]);
        roi_median_col_names_1 = string([]);
        roi_mean_col_names_2 = string([]);
        roi_median_col_names_2 = string([]);
        
        for file_index = 1:length(filesToProcess)
            
            % Datacube loading
            
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacube' ])
            load([ rois_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\roi'])
            
            if file_index
                load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_mzvalues' ])
            end
            
            % Data normalisation
            
            norm_data = f_norm_datacube( datacube, norm_type );
            
            % Data compilation
            
            data4roc = [ data4roc; norm_data ];
            
            % Masks
            
            pixels_per_model0 = zeros(size(norm_data,1),2);
            
            %
            
            all_folders = dir([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep '*']);
            all_folders_names = string([]); for fi = 3:size(all_folders,1); all_folders_names(fi-2) = all_folders(fi).name; end
            
            [ common1, all_folders_names_i1, ~ ] = intersect(all_folders_names,group0);
            
            if ~isempty(common1)
                
                disp(filesToProcess(file_index).name(1,1:end-6))
                
                for aux_i = all_folders_names_i1'
                    small_mask_1 = small_mask_1 + 1;
                    
                    disp(all_folders_names(aux_i))
                    % disp(aux_i)
                    % disp(small_mask_1)
                    
                    roi_mean_col_names_1 = [ roi_mean_col_names_1, join([all_folders_names(aux_i), " mean" ]) ];
                    roi_median_col_names_1 = [ roi_median_col_names_1, join([all_folders_names(aux_i), " median" ]) ];
                    
                    load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(all_folders_names(aux_i)) filesep 'roi' ])
                    
                    model_mask = reshape(roi.pixelSelection',[],1);
                    pixels_per_model0(:,1) = pixels_per_model0(:,1) + small_mask_1*model_mask;
                    
                end
                
            end
            
            [ common2, all_folders_names_i2, ~ ] = intersect(all_folders_names,group1);
            
            if ~isempty(common2)
                
                disp(filesToProcess(file_index).name(1,1:end-6))
                
                for aux_i = all_folders_names_i2'
                    small_mask_2 = small_mask_2 + 1;
                    
                    disp(all_folders_names(aux_i))
                    % disp(aux_i)
                    % disp(small_mask_2)
                    
                    roi_mean_col_names_2 = [ roi_mean_col_names_2, join([all_folders_names(aux_i), " mean" ]) ];
                    roi_median_col_names_2 = [ roi_median_col_names_2, join([all_folders_names(aux_i), " median" ]) ];
                    
                    load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(all_folders_names(aux_i)) filesep 'roi' ])
                    
                    model_mask = reshape(roi.pixelSelection',[],1);
                    pixels_per_model0(:,2) = pixels_per_model0(:,2) + small_mask_2*model_mask;
                    
                end
                
            end
            
            pixels_per_model = [ pixels_per_model; pixels_per_model0 ];
            
            pixels_num = sum(pixels_per_model0,1);
            disp(join(['Sum of Pixels Number in group' group0_name ': ' num2str(pixels_num(1))]))
            disp(join(['Sum of Pixels Number in group' group1_name ': ' num2str(pixels_num(2))]))
            
        end
        
        % removing pixels belonging to more then 1 region
        
        pixels_per_model( pixels_per_model(:,1) > length(all_folders_names_i1), 1) = 0; 
        pixels_per_model( pixels_per_model(:,2) > length(all_folders_names_i2), 2) = 0;
        
        load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\hmdb_sample_info' ])
        load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
        
        extended_hmdb_sample_info = [
            hmdb_sample_info
            [ relevant_lists_sample_info, repmat("",size( relevant_lists_sample_info,1),size(hmdb_sample_info,2)-size(relevant_lists_sample_info,2))]
            ];
        
        new_hmdb_sample_info = f_saving_curated_hmdb_info( extended_hmdb_sample_info, relevant_lists_sample_info );
        
        %%% Statistical test curves
        
        ttest_analysis_table = [  "p value (ttest2, mean)", "p value (ranksum, mean)", roi_mean_col_names_1, roi_mean_col_names_2, "p value (ttest2, median)", "p value (ranksum, median)", roi_median_col_names_1, roi_median_col_names_2, "meas mz", "molecule", "mono mz", "adduct", "ppm", "database (by mono mz)" ];
        
        for mzi = 1:size(datacube.spectralChannels,1)
                        
            d1 = NaN*ones(size(data4roc,1),size(unique(pixels_per_model(:,1)),1));
            i = 0;
            for maski = unique(pixels_per_model(:,1))'
                i = i+1;
                d1(logical(pixels_per_model(:,1) == maski),i) = data4roc(logical(pixels_per_model(:,1) == maski),mzi);
            end
            d1 = d1(:,2:end);
            d1(d1==0)=NaN;
            
            d2 = NaN*ones(size(data4roc,1),size(unique(pixels_per_model(:,2)),1));
            i = 0;
            for maski = unique(pixels_per_model(:,2))'
                i = i+1;
                d2(logical(pixels_per_model(:,2) == maski),i) = data4roc(logical(pixels_per_model(:,2) == maski),mzi);
            end
            d2 = d2(:,2:end);
            d2(d2==0)=NaN;
            
            mean_d1     = mean(d1,1,'omitnan');
            median_d1   = median(d1,1,'omitnan');
            
            mean_d2     = mean(d2,1,'omitnan');
            median_d2   = median(d2,1,'omitnan');
            
            if sum(~isnan(mean_d1))>0 && sum(~isnan(mean_d2))>0
                
                [ ~, p_ttest2_mean, ~, ~ ] = ttest2( mean_d1(~isnan(mean_d1)), mean_d2(~isnan(mean_d2)), 'Alpha', 0.05, 'Vartype', 'unequal' );
                if sum(isnan(mean_d1))~=length(mean_d1); [ p_ranksum_mean, ~, ~ ] = ranksum( mean_d1(~isnan(mean_d1)), mean_d2(~isnan(mean_d2)), 'Alpha', 0.05 ); else; p_ranksum_mean = NaN; end
                
                [ ~, p_ttest2_median, ~, ~ ] = ttest2( median_d1(~isnan(median_d1)), median_d2(~isnan(median_d2)), 'Alpha', 0.05, 'Vartype', 'unequal' );
                if sum(isnan(median_d1))~=length(median_d1); [ p_ranksum_median, ~, ~ ] = ranksum( median_d1(~isnan(median_d1)), median_d2(~isnan(median_d2)), 'Alpha', 0.05 ); else; p_ranksum_median = NaN; end
                
                indexes2add = (abs(datacube.spectralChannels(mzi)-double(new_hmdb_sample_info(:,3))) < min(diff(totalSpectrum_mzvalues)));
                
                if sum(indexes2add) >= 1
                    
                    aux_row = string(repmat([ p_ttest2_mean, p_ranksum_mean, mean_d1, mean_d2, p_ttest2_median, p_ranksum_median, median_d1, median_d2, datacube.spectralChannels(mzi) ], sum(indexes2add), 1));
                    aux_row(ismissing(aux_row)) = "NaN";
                    
                    ttest_analysis_table = [
                        ttest_analysis_table
                        [ aux_row, new_hmdb_sample_info(indexes2add,[1:2 4:end]) ]
                        ];
                    
                else
                    
                    aux_row = string(repmat([ p_ttest2_mean, p_ranksum_mean, mean_d1, mean_d2, p_ttest2_median, p_ranksum_median, median_d1, median_d2, datacube.spectralChannels(mzi) ], 1, 1));
                    aux_row(ismissing(aux_row)) = "NaN";
                    
                    ttest_analysis_table = [
                        ttest_analysis_table
                        [ aux_row, repmat("not assigned", 1, size(new_hmdb_sample_info(indexes2add,[1:2 4:end]),2)) ]
                        ];
                    
                end
                
            end
            
        end
        
        mkdir([ ttest_path char(main_mask) '\' char(norm_type) ])
        cd([ ttest_path char(main_mask) '\' char(norm_type) ])
        
        save([ 'ttest ' char(group1_name), ' vs ', char(group0_name), '.mat' ],'ttest_analysis_table' )
        
        txt_row = strcat(repmat('%s\t',1,size(ttest_analysis_table,2)-1),'%s\n');
        
        fileID = fopen([ 'ttest ' char(group1_name), ' vs ', char(group0_name), '.txt' ],'w');
        fprintf(fileID,txt_row, ttest_analysis_table');
        fclose(fileID);
        
    end
    
end

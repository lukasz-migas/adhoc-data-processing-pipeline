function f_saving_t_tests_ca( filesToProcess, main_mask_list, group0, group0_name, group1, group1_name, norm_list )

aux_names = []; for i = 1:length(filesToProcess); aux_names = [ aux_names, string(filesToProcess(i).name) ]; end
[ ~, uindexes ] = unique(aux_names);
filesToProcess = filesToProcess(uindexes,:);

csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
ttest_path              = [ char(outputs_path) '\ttest\' ]; if ~exist(ttest_path, 'dir'); mkdir(ttest_path); end
rois_path               = [ char(outputs_path) '\rois\' ];

for main_mask = main_mask_list
    
    for norm_type = norm_list
        
        data4roc = [];
        pixels_per_model = [];
        
        for file_index = 1:length(filesToProcess)
            
            % Datacube loading
            
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacube' ])
            load([ rois_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\roi'])
            
            if file_index
                load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_mzvalues' ])
            end
            
            norm_mask = reshape(roi.pixelSelection',[],1);
            
            % Data normalisation
            
            norm_data = f_norm_datacube_v2( datacube, norm_mask, norm_type );
            
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
                    
                    disp(all_folders_names(aux_i))
                    
                    load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(all_folders_names(aux_i)) filesep 'roi' ])
                    
                    model_mask = reshape(roi.pixelSelection',[],1);
                    pixels_per_model0(:,1) = pixels_per_model0(:,1) + model_mask;
                    
                end
                
            end
            
            [ common2, all_folders_names_i2, ~ ] = intersect(all_folders_names,group1);
            
            if ~isempty(common2)
                
                disp(filesToProcess(file_index).name(1,1:end-6))
                
                for aux_i = all_folders_names_i2'
                    
                    disp(all_folders_names(aux_i))
                    
                    load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(all_folders_names(aux_i)) filesep 'roi' ])
                    
                    model_mask = reshape(roi.pixelSelection',[],1);
                    pixels_per_model0(:,2) = pixels_per_model0(:,2) + model_mask;
                    
                end
                
            end
            
            pixels_per_model = [ pixels_per_model; pixels_per_model0 ];
            
            disp(sum(pixels_per_model,1))
            
        end
        
        load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\hmdb_sample_info' ])
        load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
        
        extended_hmdb_sample_info = [
            hmdb_sample_info
            [ relevant_lists_sample_info, repmat("",size( relevant_lists_sample_info,1),size(hmdb_sample_info,2)-size(relevant_lists_sample_info,2))]
            ];
        
        new_hmdb_sample_info = f_saving_curated_hmdb_info( extended_hmdb_sample_info, relevant_lists_sample_info );
        
        %%% Statistical test curves
        
        ttest_analysis_table = [ "p value(ttest2,mean)", "p value(ttest2,median)", "p value(ranksum,mean)", "p value(ranksum,median)", "meas mz", "molecule", "mono mz", "adduct", "ppm", "database (by mono mz)" ];
        
        for mzi = 1:size(datacube.spectralChannels,1)
            
            d1 = data4roc(logical(pixels_per_model(:,1) == 1),mzi);
            d2 = data4roc(logical(pixels_per_model(:,2) == 1),mzi);
            
            mean_d1     = mean(d1,'omitnan');
            median_d1   = median(d1,'omitnan');
            
            mean_d2     = mean(d2,'omitnan');
            median_d2   = median(d2,'omitnan');
            
            
            [ h_ttest2_mean, p_ttest2_mean, ci_ttest2_mean, ~ ] = ttest2( mean_d1, mean_d2, 'Alpha', 0.05, 'Vartype', 'unequal' );
            [ h_ttest2_median, p_ttest2_median, ci_ttest2_median, ~ ] = ttest2( median_d1, median_d2, 'Alpha', 0.05, 'Vartype', 'unequal' );
            
            [ p_ranksum_mean, h_ranksum_mean, ~ ] = ranksum( mean_d1, mean_d2,'Alpha', 0.05 );
            [ p_ranksum_median, h_ranksum_median, ~ ] = ranksum( median_d1, median_d2,'Alpha', 0.05 );
            
            indexes2add = (abs(datacube.spectralChannels(mzi)-double(new_hmdb_sample_info(:,3))) < min(diff(totalSpectrum_mzvalues)));
            
            ttest_analysis_table = [
                ttest_analysis_table
                [ string(repmat([ p_ttest2_mean, p_ttest2_median, p_ranksum_mean, p_ranksum_median, datacube.spectralChannels(mzi)],sum(indexes2add),1)) new_hmdb_sample_info(indexes2add,[1:2 4:end]) ]
                ];
            
        end
        
        mkdir([ ttest_path char(main_mask) '\' char(norm_type) ])
        cd([ ttest_path char(main_mask) '\' char(norm_type) ])
        
        save([ 'ttest_' char(strjoin([ group1_name ' vs ' group0_name])) '.mat'],'ttest_analysis_table' )
        
        txt_row = strcat(repmat('%s\t',1,size(ttest_analysis_table,2)-1),'%s\n');
        
        fileID = fopen([ 'ttest_' char(strjoin([ group1_name ' vs ' group0_name])) '.txt' ],'w');
        fprintf(fileID,txt_row, ttest_analysis_table');
        fclose(fileID);
        
    end
    
end

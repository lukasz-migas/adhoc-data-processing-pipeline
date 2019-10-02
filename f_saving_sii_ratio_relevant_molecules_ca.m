function f_saving_sii_ratio_relevant_molecules_ca( filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, ratios_info_file )
 
metabolite_lists_path = 'X:\2019_Scripts for Data Processing\molecules-lists\';

csv_inputs = [ filesToProcess(1).folder filesep 'inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, fig_ppm, outputs_path ] = f_reading_inputs(csv_inputs);

peak_assignments_path   = [ char(outputs_path) filesep 'peak assignments' filesep ];

database_col = 7;

for main_mask = main_mask_list
    
    load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) filesep char(main_mask) filesep 'relevant_lists_sample_info' ])
            [ ~, ~, cell ] = xlsread([metabolite_lists_path filesep char(ratios_info_file) '.xlsx']);
        
    sample_info_1 = [];
    sample_info_2 = [];
    
    for molecules_i = 1:size(cell,1)
        
        logical_string  = strfind(relevant_lists_sample_info(:,1), cell{molecules_i,1});
        logical_vector  = []; for logical_string_i = 1:size(logical_string,1); logical_vector(logical_string_i,1)  = ~isempty(logical_string{logical_string_i,1}); end
        sample_info_1   = [ sample_info_1; [ relevant_lists_sample_info(logical(logical_vector),:) ones(sum(logical_vector),1) molecules_i.*ones(sum(logical_vector),1) ]];
        
        logical_string  = strfind(relevant_lists_sample_info(:,1), cell{molecules_i,2});
        logical_vector  = []; for logical_string_i = 1:size(logical_string,1); logical_vector(logical_string_i,1)  = ~isempty(logical_string{logical_string_i,1}); end
        sample_info_2   = [ sample_info_2; [ relevant_lists_sample_info(logical(logical_vector),:) 2*ones(sum(logical_vector),1) molecules_i.*ones(sum(logical_vector),1) ]];
    
    end
    
    for norm_type = norm_list
        
        [ smaller_masks_list, sample_info_1, sample_info_indexes_1, norm_sii_cell_1, smaller_masks_cell, peak_details_1, pixels_num_cell, totalSpectrum_intensities_cell, totalSpectrum_mzvalues_cell ] = ...
            f_saving_sii_ratio_sample_info_ca( filesToProcess, main_mask, smaller_masks_list, norm_type, sample_info_1 );
        
        [ ~, sample_info_2, sample_info_indexes_2, norm_sii_cell_2, ~, peak_details_2, ~, ~, ~ ] = ...
            f_saving_sii_ratio_sample_info_ca( filesToProcess, main_mask, smaller_masks_list, norm_type, sample_info_2 );
        
        if ~strcmpi(outputs_folder_name_list,"all")
            sample_info = [];
            for listi = outputs_folder_name_list
                sample_info = [ sample_info; relevant_lists_sample_info(strcmpi(outputs_folder_name_list,relevant_lists_sample_info(:,database_col)),:) ];
            end
        elseif strcmpi(outputs_folder_name_list,"all")
            sample_info = relevant_lists_sample_info;
        else
            disp('Unkown list of molecules. Please specify a valid list.')
        end
        
        f_saving_sii_sample_info_ca( filesToProcess, main_mask, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, sample_info )
        
    end
    
end
function f_saving_sii_relevant_molecules_ca( filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, outputs_folder_name_list )

file_index = 1;

csv_inputs = [ filesToProcess(file_index).folder filesep 'inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

peak_assignments_path   = [ char(outputs_path) filesep 'peak assignments' filesep ];

database_col = 7;

for main_mask = main_mask_list
    
    load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) filesep char(main_mask) filesep 'relevant_lists_sample_info' ])
    
    if ~strcmpi(outputs_folder_name_list(1),"all")
        sample_info = [];
        for listi = outputs_folder_name_list
            sample_info = [ 
                sample_info
                relevant_lists_sample_info(strcmpi(listi,relevant_lists_sample_info(:,database_col)),:) 
                relevant_lists_sample_info(strcmpi(listi,relevant_lists_sample_info(:,database_col)),:)
                ];
        end
    elseif strcmpi(outputs_folder_name_list(1),"all")
        sample_info = relevant_lists_sample_info;
    else
        disp('Unkown list of molecules. Please specify a valid list.')
    end
    
    f_saving_sii_sample_info_ca( filesToProcess, main_mask, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, sample_info )
    
end
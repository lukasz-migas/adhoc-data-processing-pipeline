function f_saving_sii_relevant_molecules( filesToProcess, mask_list, norm_list, outputs_folder_name_list )

database_col = 7;

for file_index = 1:length(filesToProcess)
    
    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
    
    [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
    
    peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
    
    for mask = mask_list
        
        load([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) filesep char(mask) filesep 'relevant_lists_sample_info' ])
        
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
        
        f_saving_sii_sample_info(filesToProcess, mask, norm_list, sample_info )
        
    end
    
end
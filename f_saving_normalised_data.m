function f_saving_normalised_data( filesToProcess, mask_list, norm_list )

for mask_type = mask_list
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\datacube.mat' ])
        
        for norm_type = norm_list
            
            disp(['! Normalising ' filesToProcess(file_index).name(1,1:end-6) ' data using ' char(norm_type) ' ...'])
            
            data = f_norm_datacube( datacube, norm_type ); % normalisation
            
            mkdir([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(norm_type) ])
            cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(norm_type) ])
            
            save('data.mat','data','-v7.3')
            
            disp('! Normalised data saved.')
            
        end
    end
end
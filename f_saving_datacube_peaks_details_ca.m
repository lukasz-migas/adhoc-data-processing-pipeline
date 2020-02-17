function f_saving_datacube_peaks_details_ca( filesToProcess, mask_list )

for mask_type = mask_list
    
    file_index = 1;
    
    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
    
    [ ~, ~, ~, ~, amplratio4mva_array, numPeaks4mva_array, perc4mva_array, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
    
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
    peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
    
    % Loading relevant molecules peak details (meas mz values of assigned peaks are equal across all combined datasets)
    
    load([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\hmdb_sample_info.mat' ])
    load([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\relevant_lists_sample_info.mat' ])
    load([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\relevant_lists_sample_info_aux.mat' ])
    
    % Loading tissue only peak details (peak details are equal across all combined datasets)
    
    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\peakDetails.mat' ])
    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_mzvalues.mat' ])
    
    % Total spectra need to be summed up for the common axis approach
    
    y = 0;
    
    for file_index0 = 1:length(filesToProcess)
        
        load([ spectra_details_path filesToProcess(file_index0).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_intensities.mat' ])
        
        y = y + totalSpectrum_intensities;
        
    end
    
    disp('! Defining mz values that have to be saved in each data cube...')
    
    % Peak selection
    
    molecules_classes_specification_path = [ filesToProcess(file_index).folder '\molecules_classes_specification' ];
                
    datacubeonly_peakDetails = f_peakdetails4datacube( relevant_lists_sample_info, amplratio4mva_array, numPeaks4mva_array, perc4mva_array, molecules_classes_specification_path, hmdb_sample_info, peakDetails, totalSpectrum_mzvalues, y );
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        
        cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        
        save('datacubeonly_peakDetails','datacubeonly_peakDetails','-v7.3')
        
        disp('! Data cube specific peak details have been saved.')
        
    end
    
end
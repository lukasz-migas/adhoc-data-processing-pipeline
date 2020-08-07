function f_saving_peaks_details_ca( filesToProcess, mask_list )

for mask_type = mask_list
    
    disp('! Loading and adding all total spectra...')
    
    y = 0;
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        
        cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        
        if file_index == length(filesToProcess); load('totalSpectrum_mzvalues'); end
        
        load('totalSpectrum_intensities')
        
        y = y + totalSpectrum_intensities;
        
    end
    
    disp('! Running peak picking on total spectum...')
    
    addJARsToClassPath()
    
    peakPicking = GradientPeakDetection();
    
    peaks = peakPicking.process(SpectralData(totalSpectrum_mzvalues, y)); % peak pick total spectrum
    
    peakDetails = [ [ peaks.minSpectralChannel ]', [ peaks.centroid ]', [ peaks.maxSpectralChannel ]', [ peaks.intensity ]' ];
    
    % Saving a unique peak details mat file
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        
        cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        
        save('peakDetails','peakDetails','-v7.3')
        
        disp('! Peak details saved.')
        
    end
    
end



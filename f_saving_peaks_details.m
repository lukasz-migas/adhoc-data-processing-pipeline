function f_saving_peaks_details( filesToProcess, mask_list)

for mask_type = mask_list
            
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        
        cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        
        disp('! Loading total spectrum...')
        
        load('totalSpectrum_mzvalues')
        load('totalSpectrum_intensities')
        
        disp('! Running peak picking on total spectum...')
        
        peakPicking = GradientPeakDetection();
                
        peaks = peakPicking.process(SpectralData(totalSpectrum_mzvalues, totalSpectrum_intensities)); % peak pick total spectrum
                
        peakDetails = [ [ peaks.minSpectralChannel ]', [ peaks.centroid ]', [ peaks.maxSpectralChannel ]', [ peaks.intensity ]' ]; 
        
        % Saving a unique peak details mat file
        
        save('peakDetails','peakDetails','-v7.3')
        
        disp('! Peak details saved.')
        
    end
    
end



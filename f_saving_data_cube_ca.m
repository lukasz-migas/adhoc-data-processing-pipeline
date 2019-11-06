function f_saving_data_cube_ca( filesToProcess, mask_list )

for mask_type = mask_list

    for file_index = 1:length(filesToProcess)
    
        if file_index == 1
            
            csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
            
            [ ~, ~, ~, ~, numPeaks4mva_array, perc4mva_array, ~, ~, ~, ~, ~, ~, ~, ppmTolerance, ~, outputs_path ] = f_reading_inputs(csv_inputs);
            
            spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
            peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
            
            % Loading relevant molecules peak details (meas mz values of assigned peaks are equal across all combined datasets)
            
            load([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\relevant_lists_sample_info.mat' ])
            load([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\relevant_lists_sample_info_aux.mat' ])
            
            % Loading tissue only peak details (peak details are equal across all combined datasets)
        
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\peakDetails.mat' ])
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_mzvalues.mat' ])

            % Total spectra need to be summed up for the common axis approach
            
            totalSpectrum_intensities0 = 0;
            for file_index0 = 1:length(filesToProcess)
                load([ spectra_details_path filesToProcess(file_index0).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_intensities.mat' ])
                totalSpectrum_intensities0 = totalSpectrum_intensities0+totalSpectrum_intensities;
            end
            
            % Peak selection
        
            datacubeonly_peakDetails = f_peakdetails4datacube( relevant_lists_sample_info, ppmTolerance, numPeaks4mva_array, perc4mva_array, peakDetails, totalSpectrum_mzvalues, totalSpectrum_intensities0 );
   
        end
        
        %%% Generating the data cube
        
        % Data loading (SpectralAnalysis functions)
        
        parser = ImzMLParser([filesToProcess(file_index).folder '\' filesToProcess(file_index).name]);
        parser.parse;
        data = DataOnDisk(parser);
        
        reduction = DatacubeReductionAutomated('integrate over peak', 'New Window');
        reduction.setPeakList(datacubeonly_peakDetails(:,2));
        reduction.setPeakDetails(datacubeonly_peakDetails);
        reduction.setIntegrateOverPeak;
        
        datacube = reduction.process(data);
        
        cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        save('datacubeonly_peakDetails','datacubeonly_peakDetails','-v7.3')
        save('datacube','datacube','-v7.3')
        
        width = datacube.width;
        height = datacube.height;
        
        save('width','width','-v7.3')
        save('height','height','-v7.3')
        
        % Checking section!
        
        if file_index>1; disp([ '!!! datacubeonly_peakDetails consistency: ' num2str(isequal(datacubeonly_peakDetails, datacubeonly_peakDetails1))]); end
        
        datacubeonly_peakDetails1 = datacubeonly_peakDetails;
        
        %
        
    end
    
end
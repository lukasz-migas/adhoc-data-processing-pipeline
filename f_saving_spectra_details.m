function f_saving_spectra_details( filesToProcess, preprocessing_file, mask_list)

for file_index = 1:length(filesToProcess)
    
    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
    
    [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
    
    rois_path               = [ char(outputs_path) '\rois\' ];
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ]; if ~exist(spectra_details_path,'dir'); mkdir(spectra_details_path); end
    
    for mask_type = mask_list
        
        mkdir([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        
        % Pre-processing of data, representative spectrum computation, and pick peaking
        
        disp('! Running pre-processing and generating representative spectra...')
        
        preprocessing = PreprocessingWorkflow;
        preprocessing.loadWorkflow(preprocessing_file);
        
        parser = ImzMLParser([filesToProcess(file_index).folder filesep filesToProcess(file_index).name]);
        parser.parse; % parse the imzML file
        
        % Total Spectrum
        
        spectrumGeneration = TotalSpectrumAutomated(); % this function is changed to output SpectralData instead of SpectralList
        spectrumGeneration.setPreprocessingWorkflow(preprocessing); % set preprocessing workflow
        
        % ROI
        
        data = DataOnDisk(parser);
        
        pixels_num = sum(sum(data.regionOfInterest.pixelSelection));
        
        if ~isequal(mask_type,"no mask")
            
            load([ rois_path filesToProcess(file_index).name(1,1:end-6)  '\' char(mask_type) '\roi' ]) % loading region of interest mask
            
            roiList = RegionOfInterestList;
            roiList.add(roi);
            spectrumGeneration.processEntireDataset(false);
            spectrumGeneration.setRegionOfInterestList(roiList);
            
            pixels_num = sum(sum(roi.pixelSelection));
            
        end
                
        totalSpectrum = spectrumGeneration.process(data); % create total spectrum
        
        totalSpectrum_mzvalues      = totalSpectrum.spectralChannels;
        totalSpectrum_intensities   = totalSpectrum.intensities;
        
        save('totalSpectrum_mzvalues','totalSpectrum_mzvalues','-v7.3')
        save('totalSpectrum_intensities','totalSpectrum_intensities','-v7.3')
        save('pixels_num','pixels_num','-v7.3')
        
        disp('! Total spectrum saved.')
        
        disp('! Running peak picking on total spectum...')
        
        peakPicking = GradientPeakDetection();
        
        [ ~, ~, peakDetails ] = peakPicking.process(totalSpectrum.spectralChannels, totalSpectrum.intensities); % peak pick total spectrum
        
        save('peakDetails','peakDetails','-v7.3')
        
        disp('! Peak details saved.')
        
    end
    
end


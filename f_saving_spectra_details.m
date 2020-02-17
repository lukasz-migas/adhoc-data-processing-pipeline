function f_saving_spectra_details( filesToProcess, preprocessing_file, mask_list)
% for each file to process
for file_index = 1:length(filesToProcess)
    % find the inputs file in the folder of origin
    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
    % from the inputs file, take the outputs path
    [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
    % create the path at which you will output the ROIS
    rois_path               = [ char(outputs_path) '\rois\' ];
    % create the path at which you will save the spectra details, if there
    % is no folder with the said path, create one
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ]; if ~exist(spectra_details_path,'dir'); mkdir(spectra_details_path); end
    % for each type of mask requested
    for mask_type = mask_list
        %  create a folder at the requiered location
        mkdir([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        % relocate yourself in this folder
        cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        
        % Pre-processing of data, representative spectrum computation, and pick peaking
        
        disp('! Running pre-processing and generating representative spectra...')
        
        addJARsToClassPath()
        preprocessing = PreprocessingWorkflow;
        preprocessing.loadWorkflow(preprocessing_file);
        
        parser = ImzMLParser([filesToProcess(file_index).folder filesep filesToProcess(file_index).name]);
        parser.parse; % parse the imzML file
        
        % Total Spectrum
        
        spectrumGeneration = TotalSpectrum();
        spectrumGeneration.setPreprocessingWorkflow(preprocessing); % set preprocessing workflow

        addlistener(spectrumGeneration, 'FastMethods', @(src, canUseFastMethods)disp(['! Using fast Methods? A: ' num2str(canUseFastMethods)]));
        
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
        totalSpectrum = totalSpectrum.get(1);
        
        totalSpectrum_mzvalues      = totalSpectrum.spectralChannels;
        totalSpectrum_intensities   = totalSpectrum.intensities;
        
        save('totalSpectrum_mzvalues','totalSpectrum_mzvalues','-v7.3')
        save('totalSpectrum_intensities','totalSpectrum_intensities','-v7.3')
        save('pixels_num','pixels_num','-v7.3')
        
        disp('! Total spectrum saved.')
        
    end
    
end
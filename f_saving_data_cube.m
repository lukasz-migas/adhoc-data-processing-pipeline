function f_saving_data_cube( filesToProcess, mask_list )

for mask_type = mask_list
    
    clear datacubeonly_peakDetails
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];

        disp('! Loading mz values that have to be saved in each data cube...')
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\datacubeonly_peakDetails.mat' ])
        
        %%% Generating the data cube
        
        disp(['! Generating data cube with ' num2str(size(datacubeonly_peakDetails,1)) ' peaks...'])
        
        % Data loading (SpectralAnalysis functions)
        
        addJARsToClassPath()
        
        parser = ImzMLParser([filesToProcess(file_index).folder '\' filesToProcess(file_index).name]);
        parser.parse;
        data = DataOnDisk(parser);
        
        peakTolerance = -1; % for integration over the peak width as defined per the gradient method
        toleranceUnit = 'Spectrum Unit';
        output = 'New Window';
        intensityDataType = 'Double';
        storageType = 'Processed';
        
        reduction = DatacubeReduction(peakTolerance, toleranceUnit, output, intensityDataType, storageType);
        
        addlistener(reduction, 'FastMethods', @(src, canUseFastMethods)disp(['! Using fast Methods?   ' num2str(canUseFastMethods.bool)]));
        
        peakList.minSpectralChannel = [ datacubeonly_peakDetails(:,1) ];
        peakList.centroid = [ datacubeonly_peakDetails(:,2) ];
        peakList.maxSpectralChannel = [ datacubeonly_peakDetails(:,3) ];
        
        reduction.setPeakList(peakList);
        
        datacube = reduction.process(data);
        datacube = datacube.get(1);
        datacube = datacube.saveobj();
        
        cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        
        save('datacube.mat','datacube','-v7.3')
        
        disp('! Data cube has been saved.')
        
        width = datacube.width;
        height = datacube.height;
        pixels_coord = datacube.pixels;
        
        save('width','width','-v7.3')
        save('height','height','-v7.3')
        save('pixels_coord','pixels_coord','-v7.3')
        
        % Checking section!
        
        if (file_index~=1); disp([ '!!! datacubeonly_peakDetails consistency: ' num2str(isequal(datacubeonly_peakDetails, datacubeonly_peakDetails1))]); end
        
        datacubeonly_peakDetails1 = datacubeonly_peakDetails;
        
        %
        
    end
    
end
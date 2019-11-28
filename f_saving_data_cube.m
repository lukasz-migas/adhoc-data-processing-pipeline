function f_saving_data_cube( filesToProcess, mask_list )

for mask_type = mask_list
    
    clear datacubeonly_peakDetails
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];

        disp('! Loading mz values that have to be saved in each data cube...')
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\datacubeonly_peakDetails.mat' ])
        
        %%% Generating the data cube
        
        disp('! Generating data cube...')
        
        % Data loading (SpectralAnalysis functions)
        
        parser = ImzMLParser([filesToProcess(file_index).folder '\' filesToProcess(file_index).name]);
        parser.parse;
        data = DataOnDisk(parser);
        
        reduction = DatacubeReduction('Integrate over peak', 'New Window', 'Double', 'Processed');
        reduction.setPeakList(datacubeonly_peakDetails(:,2));
        reduction.setPeakDetails(datacubeonly_peakDetails);
        reduction.setIntegrateOverPeak;
        
        datacube = reduction.process(data);
        
        cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        
        save('datacube','datacube','-v7.3')
        
        disp('! Data cube has been saved.')
        
        width = datacube.width;
        height = datacube.height;
        
        save('width','width','-v7.3')
        save('height','height','-v7.3')
        
        % Checking section!
        
        if (file_index~=1); disp([ '!!! datacubeonly_peakDetails consistency: ' num2str(isequal(datacubeonly_peakDetails, datacubeonly_peakDetails1))]); end
        
        datacubeonly_peakDetails1 = datacubeonly_peakDetails;
        
        %
        
    end
    
end
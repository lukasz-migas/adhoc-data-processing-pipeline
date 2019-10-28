function f_saving_data_cube( filesToProcess, mask_list )

for file_index = 1:length(filesToProcess)
    
    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
    
    [ ~, ~, ~, ~, numPeaks4mva, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
    
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
    peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
    
    for mask_type = mask_list
        
        % Loading relevant molecules peak details
                
        load([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\relevant_lists_sample_info.mat' ])
        load([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\relevant_lists_sample_info_aux.mat' ])
        
        % Loading tissue only peak details
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\peakDetails.mat' ])
        
        % Peaks
        
        peakDetails1 = peakDetails;
        
        [~, sorted_peakDetails_indexes ] = sort(peakDetails1(:,4),'descend');
                
        sample_peaks_mzvalues = [ relevant_lists_sample_info_aux; peakDetails1(sorted_peakDetails_indexes(1:numPeaks4mva),2) ];
        
        mzvalues2plot = unique(sample_peaks_mzvalues); % detected mz values
        
        [ ~, unique_mzvalues ] = unique(peakDetails(:,2));
        
        peakDetails = peakDetails(unique_mzvalues,:);
        
        mzvalues2plot_aux = repmat(mzvalues2plot,1,size(peakDetails(:,2),1));
        mzvaluesdetecetd = repmat(peakDetails(:,2)',size(mzvalues2plot,1),1);
        
        datacubeonly_peakDetails = peakDetails(logical(sum(abs(mzvaluesdetecetd-mzvalues2plot_aux)<0.0000001,1))',:);
        
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
        
    end
    
end
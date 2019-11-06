function f_running_mva_testing( filesToProcess, main_mask_list, norm_list, mva_molecules_lists_label_list0 )

for main_mask = main_mask_list
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];
        
        [ ~, ~, ~, ...
            mva_list, numPeaks4mva_array, perc4mva_array, numComponents_array, ...
            ~, ~, ...
            mva_molecules_lists_label_list, ppmTolerance, ...
            ~, ~, ...
            pa_max_ppm, ...
            ~, ...
            outputs_path ] = f_reading_inputs(csv_inputs);
        
        if isnan(ppmTolerance); ppmTolerance = pa_max_ppm; end
        
        if ~isempty(mva_molecules_lists_label_list0)
            mva_molecules_lists_label_list = mva_molecules_lists_label_list0;
            numPeaks4mva_array = [];
            perc4mva_array = [];
        end
        
        % Defining all paths needed
        
        rois_path               = [ char(outputs_path) '\rois\' ];
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
        
        
        
        % Loading information about the peaks, the mz values saved as a
        % dacube cube and the matching of the dataset with a set of lists
        % of relevant molecules
        
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_mzvalues' ])
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_intensities' ])
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\peakDetails' ])
        load([ peak_assignments_path    filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacubeonly_peakDetails' ])
        
        % Loading datacube
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacube' ])
        
        % Loading main mask information
        
        if ~strcmpi(main_mask,"no mask")
            load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'roi'])
            mask = reshape(roi.pixelSelection',[],1);
        else
            mask = true(ones(size(datacube,1),1));
        end
        
        %%
        
        for norm_type = norm_list
            
            % Data normalisation and compilation
            
            norm_data = f_norm_datacube_v2( datacube, mask, norm_type );
            
            %
            
            mvai = 0;
            for mva_type = mva_list
                mvai = mvai+1;
                
                numComponents = numComponents_array(mvai);
                
                % Different peak lists
                
                % Lists
                
                for molecules_list = mva_molecules_lists_label_list
                    
                    mva_path = [ char(outputs_path) '\mva ' char(molecules_list) '\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    datacube_mzvalues_indexes = f_datacube_mzvalues_lists( molecules_list, ppmTolerance, relevant_lists_sample_info, datacubeonly_peakDetails, totalSpectrum_mzvalues );
                    
                    data4mva = norm_data(logical(mask.*(sum(norm_data(:,datacube_mzvalues_indexes),2)>0)),datacube_mzvalues_indexes);
                    mask4mva = logical(mask.*(sum(norm_data(:,datacube_mzvalues_indexes),2)>0));
                    
                    % Creating a new folder, running and saving MVA results
                    
                    f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, datacube_mzvalues_indexes, numComponents )
                    
                end
                
                % Highest peaks
                
                for numPeaks4mva = numPeaks4mva_array
                    
                    mva_path = [ char(outputs_path) '\mva ' char(num2str(numPeaks4mva)) ' highest peaks\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    % Determining the indexes of the mzvalues that are of interest from the datacube
                    
                    datacube_mzvalues_indexes = f_datacube_mzvalues_highest_peaks( numPeaks4mva, peakDetails, datacubeonly_peakDetails, totalSpectrum_mzvalues );
                    
                    % Data normalisation and compilation
                    
                    data4mva = norm_data(logical(mask.*(sum(norm_data(:,datacube_mzvalues_indexes),2)>0)),datacube_mzvalues_indexes);
                    mask4mva = logical(mask.*(sum(norm_data(:,datacube_mzvalues_indexes),2)>0));
                    
                    % Creating a new folder, running and saving MVA results
                    
                    f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, datacube_mzvalues_indexes, numComponents )
                    
                end
                
                % Percentile survival test
                
                for perc4mva = perc4mva_array
                    
                    mva_path = [ char(outputs_path) '\mva ' char(num2str(perc4mva)) ' percentile\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    % Determining the indexes of the mzvalues that are of interest from the datacube
                    
                    datacube_mzvalues_indexes = f_datacube_mzvalues_percentile( perc4mva, ppmTolerance, peakDetails, datacubeonly_peakDetails, totalSpectrum_mzvalues, totalSpectrum_intensities );
                    
                    % Data normalisation and compilation
                    
                    data4mva = norm_data(logical(mask.*(sum(norm_data(:,datacube_mzvalues_indexes),2)>0)),datacube_mzvalues_indexes);
                    mask4mva = logical(mask.*(sum(norm_data(:,datacube_mzvalues_indexes),2)>0));
                    
                    % Creating a new folder, running and saving MVA results
                    
                    f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, datacube_mzvalues_indexes, numComponents )
                    
                end
                
            end
        end
    end
end

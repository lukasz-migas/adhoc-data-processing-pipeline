function f_running_mva_ca( filesToProcess, main_mask_list, smaller_masks_list, dataset_name, norm_list, mva_molecules_list0, mva_classes_list0 )

for main_mask = main_mask_list
    
    % Creating the cells that will comprise the information regarding the
    % single ion images, the main mask, and the smaller mask.
    % Main mask - Mask used at the preprocessing step (usually tissue only).
    % Small mask - Mask used to plot the results in the shape of a grid
    % defined by the user (it can be a reference to a particular piece of
    % tissue or a set of tissues).
    
    datacube_cell = {};
    main_mask_cell = {};
    smaller_masks_cell = {};
    
    % Loading peak details information
    
    csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];
    
    [ ~, ~, ~, ...
        mva_list, numPeaks4mva_array, perc4mva_array, numComponents_array, ...
        ~, ~, ...
        mva_molecules_list, ppmTolerance, ...
        ~, ~, ...
        pa_max_ppm, ...
        ~, ...
        outputs_path ] = f_reading_inputs(csv_inputs);
    
    if isnan(ppmTolerance); ppmTolerance = pa_max_ppm; end
    
    if ~isempty(mva_molecules_list0)
        mva_molecules_list = mva_molecules_list0;
        numPeaks4mva_array = [];
        perc4mva_array = [];
    end
    
    mva_classes_list = mva_classes_list0;
    
    if ~isempty(mva_classes_list0)
        numPeaks4mva_array = [];
        perc4mva_array = [];
    end
    
    % Defining all paths needed
    
    rois_path               = [ char(outputs_path) '\rois\' ];
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
    peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
    
    % Adding total spectra
    
    filesToProcess0 = f_unique_extensive_filesToProcess(filesToProcess); % This function collects all files that need to have a common axis.
    
    y = 0;
    
    for file_index0 = 1:length(filesToProcess0)
        
        % Loading total spectrum
        
        load([ spectra_details_path filesToProcess0(file_index0).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_intensities' ])
        
        y = y + totalSpectrum_intensities;
        
    end
    
    for file_index = 1:length(filesToProcess)
        
        % Loading information about the peaks, the mz values saved as a
        % dacube cube and the matching of the dataset with a set of lists
        % of relevant molecules
        
        if file_index == 1
            
            load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_mzvalues' ])
            
            load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\peakDetails' ])
            load([ peak_assignments_path    filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
            load([ peak_assignments_path    filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\hmdb_sample_info' ])
            load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacubeonly_peakDetails' ])
        
        end
        
        % Loading datacube
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacube' ])
        
        datacube_cell{file_index} = datacube;
        
        % Loading main mask information
        
        if ~strcmpi(main_mask,"no mask")
            load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'roi'])
            main_mask_cell{file_index} = reshape(roi.pixelSelection',[],1);
        else
            main_mask_cell{file_index} = true(ones(size(datacube,1),1));
        end
        
        % Loading smaller masks information
        
        load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(smaller_masks_list(file_index)) filesep 'roi'])
        smaller_masks_cell{file_index} = logical(reshape(roi.pixelSelection',[],1));
        
    end
    
    %%
    
    for norm_type = norm_list
        
        mvai = 0;
        for mva_type = mva_list
            mvai = mvai+1;
            
            numComponents = numComponents_array(mvai);
            
            % Different peak lists
            
            % Lists
            
            for molecules_list = mva_molecules_list
                
                mva_path = [ char(outputs_path) '\mva ' char(molecules_list) '\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                                
                datacube_mzvalues_indexes = f_datacube_mzvalues_lists( molecules_list, ppmTolerance, relevant_lists_sample_info, datacubeonly_peakDetails, totalSpectrum_mzvalues );
            
                % Data normalisation and compilation
                
                [ data4mva, mask4mva ] = f_data4mva_ca_comp_norm(filesToProcess, datacube_cell, main_mask_cell, smaller_masks_cell, norm_type, datacube_mzvalues_indexes );
                
                % Creating a new folder, running and saving MVA results
                
                f_running_mva_auxiliar( mva_type, mva_path, dataset_name, main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                
            end
                        
            % Highest peaks
            
            for numPeaks4mva = numPeaks4mva_array
                
                mva_path = [ char(outputs_path) '\mva ' char(num2str(numPeaks4mva)) ' highest peaks\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                
                % Determining the indexes of the mzvalues that are of interest from the datacube
                
                datacube_mzvalues_indexes = f_datacube_mzvalues_highest_peaks( numPeaks4mva, peakDetails, datacubeonly_peakDetails, totalSpectrum_mzvalues );
                
                % Data normalisation and compilation
                
                [ data4mva, mask4mva ] = f_data4mva_ca_comp_norm(filesToProcess, datacube_cell, main_mask_cell, smaller_masks_cell, norm_type, datacube_mzvalues_indexes );
                
                % Creating a new folder, running and saving MVA results
                
                f_running_mva_auxiliar( mva_type, mva_path, dataset_name, main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                
            end
            
            % Percentile survival test
            
            for perc4mva = perc4mva_array
                
                mva_path = [ char(outputs_path) '\mva ' char(num2str(perc4mva)) ' percentile\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                                
                % Determining the indexes of the mzvalues that are of interest from the datacube
                
                datacube_mzvalues_indexes = f_datacube_mzvalues_percentile( perc4mva, ppmTolerance, peakDetails, datacubeonly_peakDetails, totalSpectrum_mzvalues, y );
                
                % Data normalisation and compilation
                
                [ data4mva, mask4mva ] = f_data4mva_ca_comp_norm(filesToProcess, datacube_cell, main_mask_cell, smaller_masks_cell, norm_type, datacube_mzvalues_indexes );
                
                % Creating a new folder, running and saving MVA results
                
                f_running_mva_auxiliar( mva_type, mva_path, dataset_name, main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                
            end
            
            % Classes of molecules
            
            molecules_classes_specification_path = [ filesToProcess(1).folder '\molecules_classes_specification' ];
            
            [ ~, ~, classes_info ] = xlsread(molecules_classes_specification_path);
            
            %
            
            for classes_list = mva_classes_list
                
                for classi = 2:size(classes_info,1)
                    
                    if strcmpi(classes_list,classes_info{classi,1})==1
                        
                        mva_path = [ char(outputs_path) '\mva ' char(classes_info{classi,1}) '\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                        
                        % Determining the indexes of the mzvalues that are of interest from the datacube
                        
                        datacube_mzvalues_indexes = f_datacube_mzvalues_classes( classes_info, classi, hmdb_sample_info, datacubeonly_peakDetails, totalSpectrum_mzvalues );
                        
                        % Data normalisation and compilation
                        
                        [ data4mva, mask4mva ] = f_data4mva_ca_comp_norm(filesToProcess, datacube_cell, main_mask_cell, smaller_masks_cell, norm_type, datacube_mzvalues_indexes );
                        
                        % Creating a new folder, running and saving MVA results
                        
                        f_running_mva_auxiliar( mva_type, mva_path, dataset_name, main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                                                
                    end
                    
                end
                
            end
            
            if strcmpi( mva_classes_list, "all" )
                
                for classi = 2:size(classes_info,1)
                    
                    mva_path = [ char(outputs_path) '\mva ' char(classes_info{classi,1}) '\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    % Determining the indexes of the mzvalues that are of interest from the datacube
                    
                    datacube_mzvalues_indexes = f_datacube_mzvalues_classes( classes_info, classi, hmdb_sample_info, datacubeonly_peakDetails, totalSpectrum_mzvalues );
                    
                    % Data normalisation and compilation
                    
                    [ data4mva, mask4mva ] = f_data4mva_ca_comp_norm(filesToProcess, datacube_cell, main_mask_cell, smaller_masks_cell, norm_type, datacube_mzvalues_indexes );
                    
                    % Creating a new folder, running and saving MVA results
                    
                    f_running_mva_auxiliar( mva_type, mva_path, dataset_name, main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                    
                end                
                
            end
                                                
        end
    end
end


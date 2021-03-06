function f_saving_pca_nmf_scatter_plots_ca( filesToProcess, mva_list, numComponents_array, component_x, component_y, component_z, main_mask_list, smaller_masks_list, smaller_masks_colours, dataset_name, norm_list, mva_molecules_list0, mva_classes_list0 )

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
        ~, ...
        amplratio4mva_array, numPeaks4mva_array, perc4mva_array, ...
        ~, ~, ...
        ~, ...
        mva_molecules_list, ppmTolerance, ...
        ~, ~, ...
        pa_max_ppm, ~, outputs_path ] = f_reading_inputs(csv_inputs);
    
    if isnan(ppmTolerance); ppmTolerance = pa_max_ppm; end
    
    if isempty(mva_molecules_list0)
        mva_mzvalues_vector = [];
    elseif isstring(mva_molecules_list0)
        mva_molecules_list = mva_molecules_list0;
        mva_mzvalues_vector = [];
        numPeaks4mva_array = [];
        perc4mva_array = [];
    elseif isvector(mva_molecules_list0)
        mva_mzvalues_vector = mva_molecules_list0;
        mva_molecules_list = [];
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
    
    for file_index = 1:length(filesToProcess)
        
        % Loading imzml width and height
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\width' ])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\height' ])
        
        datacube_cell{file_index}.width = width;
        datacube_cell{file_index}.height = height;
        
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
    
    %
    
    mvai = 0;
    for mva_type = mva_list
        mvai = mvai + 1;
        
        for norm_type = norm_list
            
            numComponents = numComponents_array(mvai);
            
            % Different peak lists
            
            % Vector of mz values
            
            if ~isempty(mva_mzvalues_vector)
                
                mva_path = [ char(outputs_path) '\mva ' char(num2str(length(mva_mzvalues_vector))) ' adhoc mz values\' ];
                
                f_saving_pca_nmf_scatter_plots_auxiliar_ca( mva_type, mva_path, dataset_name, main_mask, norm_type, numComponents, datacube_cell, smaller_masks_colours, component_x, component_y, component_z )
                
            end
            
            % Lists
            
            for molecules_list = mva_molecules_list
                
                mva_path = [ char(outputs_path) '\mva ' char(molecules_list) '\' ];
                
                f_saving_pca_nmf_scatter_plots_auxiliar_ca( mva_type, mva_path, dataset_name, main_mask, norm_type, numComponents, datacube_cell, smaller_masks_colours, component_x, component_y, component_z )
                
            end
            
            % Highest peaks
            
            % Number
            
            for numPeaks4mva = numPeaks4mva_array
                
                mva_path = [ char(outputs_path) '\mva ' char(num2str(numPeaks4mva)) ' highest peaks\' ];
                
                f_saving_pca_nmf_scatter_plots_auxiliar_ca( mva_type, mva_path, dataset_name, main_mask, norm_type, numComponents, datacube_cell, smaller_masks_colours, component_x, component_y, component_z )
                
            end
            
            % Percentile
            
            for perc4mva = perc4mva_array
                
                mva_path = [ char(outputs_path) '\mva percentile ' char(num2str(perc4mva)) ' peaks\' ];
                
                f_saving_pca_nmf_scatter_plots_auxiliar_ca( mva_type, mva_path, dataset_name, main_mask, norm_type, numComponents, datacube_cell, smaller_masks_colours, component_x, component_y, component_z )
                
            end
            
            % Highest peaks after a thresholding step based on the ratio between the two amplitudes of each peak
            
            for amplratio4mva = amplratio4mva_array
                
                % Number
                
                for numPeaks4mva = numPeaks4mva_array
                    
                    mva_path = [ char(outputs_path) '\mva ' char(num2str(numPeaks4mva)) ' highest peaks + ' char(num2str(amplratio4mva)) ' ampls ratio\' ];
                    
                    f_saving_pca_nmf_scatter_plots_auxiliar_ca( mva_type, mva_path, dataset_name, main_mask, norm_type, numComponents, datacube_cell, smaller_masks_colours, component_x, component_y, component_z )
                    
                end
                
                % Percentile
                
                for perc4mva = perc4mva_array
                    
                    mva_path = [ char(outputs_path) '\mva percentile ' char(num2str(perc4mva)) ' peaks + ' char(num2str(amplratio4mva)) ' ampls ratio\' ];
                    
                    f_saving_pca_nmf_scatter_plots_auxiliar_ca( mva_type, mva_path, dataset_name, main_mask, norm_type, numComponents, datacube_cell, smaller_masks_colours, component_x, component_y, component_z )
                    
                end
                
            end
            
            % Classes of molecules
            
            if ~isempty(mva_classes_list)
                
                molecules_classes_specification_path = [ filesToProcess(1).folder '\molecules_classes_specification' ];
                
                [ ~, ~, classes_info ] = xlsread(molecules_classes_specification_path);
                
            end
            
            %
            
            for classes_list = mva_classes_list
                
                for classi = 2:size(classes_info,1)
                    
                    if strcmpi(classes_list,classes_info{classi,1})==1
                        
                        mva_path = [ char(outputs_path) '\mva ' char(classes_info{classi,1}) '\' ];
                        
                        f_saving_pca_nmf_scatter_plots_auxiliar_ca( mva_type, mva_path, dataset_name, main_mask, norm_type, numComponents, datacube_cell, smaller_masks_colours, component_x, component_y, component_z )
                        
                    end
                    
                end
                
            end
            
            if strcmpi( mva_classes_list, "all" )
                
                for classi = 2:size(classes_info,1)
                    
                    mva_path = [ char(outputs_path) '\mva ' char(classes_info{classi,1}) '\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    f_saving_pca_nmf_scatter_plots_auxiliar_ca( mva_type, mva_path, dataset_name, main_mask, norm_type, numComponents, datacube_cell, smaller_masks_colours, component_x, component_y, component_z )
                    
                end
                
            end
            
        end
    end
    
end

function f_saving_mva_outputs( filesToProcess, main_mask_list, norm_list, mva_molecules_list0, mva_classes_list0 )

for main_mask = main_mask_list
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];
        
        [ ~, ~, ~, ...
            mva_list, numPeaks4mva_array, perc4mva_array, numComponents_array, numLoadings_array, ~, ...
            mva_molecules_list, ppmTolerance, ...
            ~, ~, ...
            pa_max_ppm, fig_ppmTolerance, outputs_path ] = f_reading_inputs(csv_inputs);
        
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
        
        % Loading information about the peaks, the mz values saved as a
        % dacube cube and the matching of the dataset with a set of lists
        % of relevant molecules
        
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_mzvalues' ])
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_intensities' ])
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\pixels_num' ])
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\peakDetails' ])
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacubeonly_peakDetails' ])
        
        load([ peak_assignments_path    filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
        load([ peak_assignments_path    filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\hmdb_sample_info' ])
        
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
                numLoadings = numLoadings_array(mvai);
                
                % Different peak lists
                
                % Lists
                
                for molecules_list = mva_molecules_list
                    
                    mva_path = [ char(outputs_path) '\mva ' char(molecules_list) '\' ];
                    
                    f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, numComponents, numLoadings, datacube, datacubeonly_peakDetails, mask, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num,  fig_ppmTolerance)
                    
                end
                
                % Highest peaks
                
                for numPeaks4mva = numPeaks4mva_array
                    
                    mva_path = [ char(outputs_path) '\mva ' char(num2str(numPeaks4mva)) ' highest peaks\' ];
                    
                    f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, numComponents, numLoadings, datacube, datacubeonly_peakDetails, mask, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num,  fig_ppmTolerance)
                    
                end
                
                % Percentile survival test
                
                for perc4mva = perc4mva_array
                    
                    mva_path = [ char(outputs_path) '\mva ' char(num2str(perc4mva)) ' percentile\' ];
                    
                    f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, numComponents, numLoadings, datacube, datacubeonly_peakDetails, mask, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num,  fig_ppmTolerance)
                    
                end
                
                % Classes of molecules
                
                molecules_classes_specification_path = [ filesToProcess(1).folder '\molecules_classes_specification' ];
                
                if isfile(molecules_classes_specification_path)
                    [ ~, ~, classes_info ] = xlsread(molecules_classes_specification_path);
                elseif ~isempty(mva_classes_list)
                    disp(['! No file specifying classes available in ' char(molecules_classes_specification_path) '.'])
                end
                
                %
                
                for classes_list = mva_classes_list
                    
                    for classi = 2:size(classes_info,1)
                        
                        if strcmpi(classes_list,classes_info{classi,1})==1
                            
                            mva_path = [ char(outputs_path) '\mva ' char(classes_info{classi,1}) '\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                            
                            f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, numComponents, numLoadings, datacube, datacubeonly_peakDetails, mask, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num,  fig_ppmTolerance)
                            
                        end
                        
                    end
                    
                end
                
                if strcmpi( mva_classes_list, "all" )
                    
                    for classi = 2:size(classes_info,1)
                        
                        mva_path = [ char(outputs_path) '\mva ' char(classes_info{classi,1}) '\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                        
                        f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, numComponents, numLoadings, datacube, datacubeonly_peakDetails, mask, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num,  fig_ppmTolerance)
                        
                    end
                    
                end
                
            end
        end
    end
end

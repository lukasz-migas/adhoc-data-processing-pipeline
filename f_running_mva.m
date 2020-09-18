function f_running_mva( filesToProcess, main_mask_list, norm_list, mva_molecules_list0, mva_classes_list0, mzvalues2discard )

if nargin <= 5; mzvalues2discard = []; end

for main_mask = main_mask_list
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];
        
        [ ~, ~, ~, ...
            mva_list, ...
            amplratio4mva_array, numPeaks4mva_array, perc4mva_array, ...
            numComponents_array, ...
            ~, ~, ...
            mva_molecules_list, ppmTolerance, ...
            ~, ~, ...
            pa_max_ppm, ...
            ~, ...
            outputs_path ] = f_reading_inputs(csv_inputs);
        
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
        peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
        
        % Loading information about the peaks, the mz values saved as a
        % dacube cube and the matching of the dataset with a set of lists
        % of relevant molecules
        
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_intensities' ])
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\peakDetails' ])
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacubeonly_peakDetails' ])
        
        load([ peak_assignments_path    filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\hmdb_sample_info' ])
        load([ peak_assignments_path    filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
        
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
            
            % Loading normalised data
            
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep char(norm_type) filesep 'data'])
                        
            %
            
            % Compiling data
            
            mvai = 0;
            for mva_type = mva_list
                mvai = mvai+1;
                
                numComponents = numComponents_array(mvai);
                
                % Different peak lists
                
                % Vector of mz values
                
                if ~isempty(mva_mzvalues_vector)
                    
                    mva_path = [ char(outputs_path) '\mva ' char(num2str(length(mva_mzvalues_vector))) ' adhoc mz values\' ];
                    
                    datacube_mzvalues_indexes = f_datacube_mzvalues_vector( mva_mzvalues_vector, datacubeonly_peakDetails );
                    
                    % Remove a particular list of meas mz
                    
                    if ~isempty(mzvalues2discard)
                        mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                        datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                    end
                    
                    mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                    data4mva = data(mask4mva,datacube_mzvalues_indexes);
                    
                    % Creating a new folder, running and saving MVA results
                    
                    if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                    
                end
                
                % Lists
                
                for molecules_list = mva_molecules_list
                    
                    mva_path = [ char(outputs_path) '\mva ' char(molecules_list) '\' ];
                    
                    datacube_mzvalues_indexes = f_datacube_mzvalues_lists( molecules_list, ppmTolerance, relevant_lists_sample_info, datacubeonly_peakDetails );
                    
                    % Remove a particular list of meas mz
                    
                    if ~isempty(mzvalues2discard)
                        mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                        datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                    end
                    
                    mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                    data4mva = data(mask4mva,datacube_mzvalues_indexes);
                    
                    % Creating a new folder, running and saving MVA results
                    
                    if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                    
                end
                
                % Highest peaks
                
                % Number
                
                for numPeaks4mva = numPeaks4mva_array
                    
                    mva_path = [ char(outputs_path) '\mva ' char(num2str(numPeaks4mva)) ' highest peaks\' ];
                    
                    % Determining the indexes of the mzvalues that are of interest from the datacube
                    
                    datacube_mzvalues_indexes = f_datacube_mzvalues_highest_peaks( numPeaks4mva, peakDetails, datacubeonly_peakDetails );
                    
                    % Remove a particular list of meas mz
                    
                    if ~isempty(mzvalues2discard)
                        mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                        datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                    end
                    
                    mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                    data4mva = data(mask4mva,datacube_mzvalues_indexes);
                    
                    % Creating a new folder, running and saving MVA results
                    
                    if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                    
                end
                
                % Percentile
                
                for perc4mva = perc4mva_array
                    
                    mva_path = [ char(outputs_path) '\mva percentile ' char(num2str(perc4mva)) ' peaks\' ];
                    
                    % Determining the indexes of the mzvalues that are of interest from the datacube
                    
                    datacube_mzvalues_indexes = f_datacube_mzvalues_highest_peaks_percentile( perc4mva, peakDetails, datacubeonly_peakDetails );
                    
                    % Remove a particular list of meas mz
                    
                    if ~isempty(mzvalues2discard)
                        mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                        datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                    end
                    
                    mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                    data4mva = data(mask4mva,datacube_mzvalues_indexes);
                    
                    % Creating a new folder, running and saving MVA results
                    
                    if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                    
                end
                
                % Highest peaks after a thresholding step based on the ratio between the two amplitudes of each peak
                
                for amplratio4mva = amplratio4mva_array
                    
                    % Number
                    
                    for numPeaks4mva = numPeaks4mva_array
                        
                        mva_path = [ char(outputs_path) '\mva ' char(num2str(numPeaks4mva)) ' highest peaks + ' char(num2str(amplratio4mva)) ' ampls ratio\' ];
                        
                        % Determining the indexes of the mzvalues that are of interest from the datacube
                        
                        datacube_mzvalues_indexes = f_datacube_mzvalues_ampl_ratio_highest_peaks( amplratio4mva, numPeaks4mva, peakDetails, datacubeonly_peakDetails, totalSpectrum_intensities );
                        
                        % Remove a particular list of meas mz
                        
                        if ~isempty(mzvalues2discard)
                            mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                            datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                        end
                        
                        mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                        data4mva = data(mask4mva,datacube_mzvalues_indexes);
                        
                        % Creating a new folder, running and saving MVA results
                        
                        if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                        
                        f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                        
                    end
                    
                    % Percentile
                    
                    for perc4mva = perc4mva_array
                        
                        mva_path = [ char(outputs_path) '\mva percentile ' char(num2str(perc4mva)) ' peaks + ' char(num2str(amplratio4mva)) ' ampls ratio\' ];
                        
                        % Determining the indexes of the mzvalues that are of interest from the datacube
                        
                        datacube_mzvalues_indexes = f_datacube_mzvalues_ampl_ratio_highest_peaks_percentile( amplratio4mva, perc4mva, peakDetails, datacubeonly_peakDetails, totalSpectrum_intensities );
                        
                        % Remove a particular list of meas mz
                        
                        if ~isempty(mzvalues2discard)
                            mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                            datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                        end
                        
                        mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                        data4mva = data(mask4mva,datacube_mzvalues_indexes);
                        
                        % Creating a new folder, running and saving MVA results
                        
                        if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                        
                        f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                        
                    end
                    
                end
                
                % Classes of molecules
                
                if ~isempty(mva_classes_list)
                    
                    molecules_classes_specification_path = [ filesToProcess(1).folder '\molecules_classes_specification' ];
                    
                    if isfile(molecules_classes_specification_path)
                        [ ~, ~, classes_info ] = xlsread(molecules_classes_specification_path);
                    elseif ~isempty(mva_classes_list)
                        disp(['! No file specifying classes available in ' char(molecules_classes_specification_path) '.'])
                    end
                    
                end
                
                for classes_list = mva_classes_list
                    
                    for classi = 2:size(classes_info,1)
                        
                        if strcmpi(classes_list,classes_info{classi,1})==1
                            
                            mva_path = [ char(outputs_path) '\mva ' char(classes_info{classi,1}) '\' ];
                            
                            % Determining the indexes of the mzvalues that are of interest from the datacube
                            
                            datacube_mzvalues_indexes = f_datacube_mzvalues_classes( classes_info, classi, hmdb_sample_info, datacubeonly_peakDetails );
                            
                            % Remove a particular list of meas mz
                            
                            if ~isempty(mzvalues2discard)
                                mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                                datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                            end
                            
                            mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                            data4mva = data(mask4mva,datacube_mzvalues_indexes);
                            
                            % Creating a new folder, running and saving MVA results
                            
                            if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                            
                            f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                            
                        end
                        
                    end
                    
                end
                
                if strcmpi( mva_classes_list, "all" )
                    
                    for classi = 2:size(classes_info,1)
                        
                        mva_path = [ char(outputs_path) '\mva ' char(classes_info{classi,1}) '\' ];
                        
                        % Determining the indexes of the mzvalues that are of interest from the datacube
                        
                        datacube_mzvalues_indexes = f_datacube_mzvalues_classes( classes_info, classi, hmdb_sample_info, datacubeonly_peakDetails );
                        
                        % Remove a particular list of meas mz
                        
                        if ~isempty(mzvalues2discard)
                            mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                            datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                        end
                        
                        mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                        data4mva = data(mask4mva,datacube_mzvalues_indexes);
                        
                        % Creating a new folder, running and saving MVA results
                        
                        if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                        
                        f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                        
                    end
                    
                end
                
            end
        end
    end
end

function f_running_mva( filesToProcess, main_mask_list, norm_list, mva_molecules_list0, mva_classes_list0, mzvalues2discard )

% This function runs the multivariate analyses specified in
% "inputs_file.xlsx", or as specified by the inputs (mva_molecules_list0,
% mva_classes_list0, and mzvalues2discard). If mva_molecules_list0 or
% mva_classes_list0 are specified as inputs, the top peaks (as specified
% in the "inputs_file.xlsx") are not used. This function saves the standard
% of the available MVAs (which differ from algorithm to algorithm) as
% Matlab files.
% The multivariate analyses can be run using a predefined set of peaks:
% - the top N peaks (in terms of total intensity)
% - the top percentil P (in terms of total intensity)
% - those beloging to one of the lists of molecules of interest
% - those beloging to one of the kingdoms, super-class, class, or subclass
% specified in a partcular file (this functionality is incomplete at the
% moment 21 Sept 2020)
% This set of peaks can be curated using the results of univariate analysis
% (ANOVA) to define an array of m/s to be discarded.
%
% Inputs:
% filesToProcess - Matlab structure created by matlab function dir,
% containing the list of files to process and their locations / paths
% mask_list - array with names of masks to be used (sequentially) to reduce
% data to a particular group of pixels
% norm_list - list of strings specifying the normalisations of interest,
% which can be one or more of the following options: "no norm", "tic", "RMS",
% "pqn mean", "pqn median", "zscore"
% mva_molecules_list0 - an array of strings listing the names of the lists
% of the molecules of interest, or an array of doubles specifying which m/z
% are to be included in the analysis
% mva_classes_list0 - an array with strings listing the classes of
% molecules of interest
% mzvalues2discard - an array of doubles (a Matlab vector) specifying which
% m/z are to be discarded from the analysis
%
% Note:
% The masks in mask_list can be “no mask” (all pixels of the imzml file are
% used), or names of folders saved in the outputs folder “rois” (created as
% part of the pipeline)
%
% Outputs:
% pca - firstCoeffs, firstScores, explainedVariance
% nnmf - W, H
% ica - z, model
% kmeans - idx, C, optimal_numComponents
% tsne - rgbData, idx, cmap, loss, tsne_parameters
% nntsne - rgbData, idx, cmap, outputSpectralContriubtion  
% See the help of each function for details on its outputs. With the
% exception of nntsne, Matlab functions are called.
         
if nargin < 4; mva_molecules_list0 = []; mva_classes_list0 = []; mzvalues2discard = []; end
if nargin < 5; mva_classes_list0 = []; mzvalues2discard = []; end
if nargin < 6; mzvalues2discard = []; end

for main_mask = main_mask_list
    
    for file_index = 1:length(filesToProcess)
        
        % Read relevant information from "inputs_file.xlsx"
        
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
        
        % Define sets of peaks of interest (if not given as an input, the array is set to empty)
        
        % If mva_molecules_list0 or mva_classes_list0 are specified as inputs,
        % the top peaks specified in "inputs_file.xlsx" are not used.
        
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
        
        % Define paths to regions of interest (ROI), spectral details and
        % peak assigments folders
        
        rois_path               = [ char(outputs_path) '\rois\' ];
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
        
        % Load continous total spectrum, peak details, datacube specific
        % peak details, and HMDB and molecules of interest assigments
        
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_intensities' ])
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\peakDetails' ])
        load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacubeonly_peakDetails' ])
        
        load([ peak_assignments_path    filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\hmdb_sample_info' ])
        load([ peak_assignments_path    filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
        
        for norm_type = norm_list
            
            % Load normalised data
            
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep char(norm_type) filesep 'data'])
            
            % Load main mask binary mask (region of interest)
            
            if ~strcmpi(main_mask,"no mask")
                load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'roi'])
                mask = reshape(roi.pixelSelection',[],1);
            else
                mask = true(size(data,1),1);
            end
            
            % Run multivariate analyses using different criteria for peak selection
            
            mvai = 0;
            for mva_type = mva_list
                mvai = mvai+1;
                numComponents = numComponents_array(mvai);
                
                % - Set of peaks of interest
                
                if ~isempty(mva_mzvalues_vector)
                    
                    mva_path = [ char(outputs_path) '\mva ' char(num2str(length(mva_mzvalues_vector))) ' adhoc mz values\' ];
                    
                    % Determine peaks of interest indicies in the datacube
                    
                    datacube_mzvalues_indexes = f_datacube_mzvalues_vector( mva_mzvalues_vector, datacubeonly_peakDetails );
                    
                    % Remove a particular set of meas mz
                    
                    if ~isempty(mzvalues2discard)
                        mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' peaks discarded)\' ];
                        datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                    end
                    
                    % Reduce data to pixels of interest - mask - and mass
                    % channels of interest - datacube_mzvalues_indexes.
                    
                    mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                    data4mva = data(mask4mva,datacube_mzvalues_indexes);
                    
                    % Create new folder, run and save MVA results
                    
                    if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                    
                end
                
                % - Lists of molecules of interest
                
                for molecules_list = mva_molecules_list
                    
                    mva_path = [ char(outputs_path) '\mva ' char(molecules_list) '\' ];
                    
                    % Determine peaks of interest indicies in the datacube
                    
                    datacube_mzvalues_indexes = f_datacube_mzvalues_lists( molecules_list, ppmTolerance, relevant_lists_sample_info, datacubeonly_peakDetails );
                    
                    % Remove a particular set of meas mz
                    
                    if ~isempty(mzvalues2discard)
                        mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' peaks discarded)\' ];
                        datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                    end
                    
                    % Reduce data to pixels of interest - mask - and mass
                    % channels of interest - datacube_mzvalues_indexes.
                    
                    mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                    data4mva = data(mask4mva,datacube_mzvalues_indexes);
                    
                    % Create a new folder, run and save MVA results
                    
                    if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                    
                end
                
                % - Top peaks
                
                % -- Number
                
                for numPeaks4mva = numPeaks4mva_array
                    
                    mva_path = [ char(outputs_path) '\mva ' char(num2str(numPeaks4mva)) ' highest peaks\' ];
                    
                    % Determine peaks of interest indicies in the datacube
                    
                    datacube_mzvalues_indexes = f_datacube_mzvalues_highest_peaks( numPeaks4mva, peakDetails, datacubeonly_peakDetails );
                    
                    % Remove a particular set of meas mz
                    
                    if ~isempty(mzvalues2discard)
                        mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' peaks discarded)\' ];
                        datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                    end
                    
                    % Reduce data to pixels of interest - mask - and mass
                    % channels of interest - datacube_mzvalues_indexes.
                    
                    mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                    data4mva = data(mask4mva,datacube_mzvalues_indexes);
                    
                    % Create a new folder, run and save MVA results
                    
                    if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                    
                end
                
                % -- Percentile
                
                for perc4mva = perc4mva_array
                    
                    mva_path = [ char(outputs_path) '\mva percentile ' char(num2str(perc4mva)) ' peaks\' ];
                    
                    % Determine peaks of interest indicies in the datacube
                    
                    datacube_mzvalues_indexes = f_datacube_mzvalues_highest_peaks_percentile( perc4mva, peakDetails, datacubeonly_peakDetails );
                    
                    % Remove a particular set of meas mz
                    
                    if ~isempty(mzvalues2discard)
                        mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' peaks discarded)\' ];
                        datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                    end
                    
                    % Reduce data to pixels of interest - mask - and mass
                    % channels of interest - datacube_mzvalues_indexes.
                    
                    mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                    data4mva = data(mask4mva,datacube_mzvalues_indexes);
                    
                    % Create a new folder, run and save MVA results
                    
                    if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                    
                    f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                    
                end
                
                % Highest peaks after a thresholding step based on the ratio between the two amplitudes of each peak
                
                for amplratio4mva = amplratio4mva_array
                    
                    % -- Number
                    
                    for numPeaks4mva = numPeaks4mva_array
                        
                        mva_path = [ char(outputs_path) '\mva ' char(num2str(numPeaks4mva)) ' highest peaks + ' char(num2str(amplratio4mva)) ' ampls ratio\' ];
                        
                        % Determine peaks of interest indicies in the datacube
                        
                        datacube_mzvalues_indexes = f_datacube_mzvalues_ampl_ratio_highest_peaks( amplratio4mva, numPeaks4mva, peakDetails, datacubeonly_peakDetails, totalSpectrum_intensities );
                        
                        % Remove a particular set of meas mz
                        
                        if ~isempty(mzvalues2discard)
                            mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' peaks discarded)\' ];
                            datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                        end
                        
                        % Reduce data to pixels of interest - mask - and mass
                        % channels of interest - datacube_mzvalues_indexes.
                        
                        mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                        data4mva = data(mask4mva,datacube_mzvalues_indexes);
                        
                        % Create a new folder, run and save MVA results
                        
                        if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                        
                        f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                        
                    end
                    
                    % -- Percentile
                    
                    for perc4mva = perc4mva_array
                        
                        mva_path = [ char(outputs_path) '\mva percentile ' char(num2str(perc4mva)) ' peaks + ' char(num2str(amplratio4mva)) ' ampls ratio\' ];
                        
                        % Determine peaks of interest indicies in the datacube
                        
                        datacube_mzvalues_indexes = f_datacube_mzvalues_ampl_ratio_highest_peaks_percentile( amplratio4mva, perc4mva, peakDetails, datacubeonly_peakDetails, totalSpectrum_intensities );
                        
                        % Remove a particular set of meas mz
                        
                        if ~isempty(mzvalues2discard)
                            mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' peaks discarded)\' ];
                            datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                        end
                        
                        % Reduce data to pixels of interest - mask - and mass
                        % channels of interest - datacube_mzvalues_indexes.
                        
                        mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                        data4mva = data(mask4mva,datacube_mzvalues_indexes);
                        
                        % Create a new folder, run and save MVA results
                        
                        if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                        
                        f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                        
                    end
                    
                end
                
                % - HMDB classes of molecules
                
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
                            
                            % Determine peaks of interest indicies in the datacube
                            
                            datacube_mzvalues_indexes = f_datacube_mzvalues_classes( classes_info, classi, hmdb_sample_info, datacubeonly_peakDetails );
                            
                            % Remove a particular set of meas mz
                            
                            if ~isempty(mzvalues2discard)
                                mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' peaks discarded)\' ];
                                datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                            end
                            
                            % Reduce data to pixels of interest - mask - and mass
                            % channels of interest - datacube_mzvalues_indexes.
                            
                            mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                            data4mva = data(mask4mva,datacube_mzvalues_indexes);
                            
                            % Create a new folder, run and save MVA results
                            
                            if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                            
                            f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                            
                        end
                        
                    end
                    
                end
                
                if strcmpi( mva_classes_list, "all" )
                    
                    for classi = 2:size(classes_info,1)
                        
                        mva_path = [ char(outputs_path) '\mva ' char(classes_info{classi,1}) '\' ];
                        
                        % Determine peaks of interest indicies in the datacube
                        
                        datacube_mzvalues_indexes = f_datacube_mzvalues_classes( classes_info, classi, hmdb_sample_info, datacubeonly_peakDetails );
                        
                        % Remove a particular set of meas mz
                        
                        if ~isempty(mzvalues2discard)
                            mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' peaks discarded)\' ];
                            datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes );
                        end
                        
                        % Reduce data to pixels of interest - mask - and mass
                        % channels of interest - datacube_mzvalues_indexes.
                        
                        mask4mva = logical(mask.*(sum(data(:,datacube_mzvalues_indexes),2)>0));
                        data4mva = data(mask4mva,datacube_mzvalues_indexes);
                        
                        % Create a new folder, run and save MVA results
                        
                        if ~exist(mva_path, 'dir'); mkdir(mva_path); end
                        
                        f_running_mva_auxiliar( mva_type, mva_path, filesToProcess(file_index).name(1,1:end-6), main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )
                        
                    end
                    
                end
                
            end
        end
    end
end

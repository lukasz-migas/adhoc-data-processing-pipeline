function f_saving_mva_outputs( filesToProcess, main_mask_list, mask_on, norm_list, mva_molecules_list0, mva_classes_list0, mzvalues2discard )

% This function runs the multivariate analysis specified in , and
% saves a data matrix that will be required at any further down the line 
% step using normalised data (e.g. univariate or multivariate analyses, 
% plotting of single ion images).
% 
% Inputs:
% filesToProcess - Matlab structure created by matlab function dir, 
% containing the list of files to process and their locations / paths
% mask_list - array with names of masks to be used (sequentially) to reduce 
% data to a particular group of pixels
% norm_list - list of strings specifying the normalisations of interest,
% which can be one or more of the following options: "no norm", "tic", "RMS", 
% "pqn mean", "pqn median", "zscore"
%
% Note: 
% The masks in mask_list can be “no mask” (all pixels of the imzml file are
% used), or names of folders saved in the outputs folder “rois” (created as
% part of the pipeline)
% 
% Outputs:
% data.mat - Matlab matrix with normalised data (dimentions: pixels (rows) 
% by mass channels (columns)) 

if nargin < 5; mva_molecules_list0 = []; mva_classes_list0 = []; mzvalues2discard = []; end
if nargin < 6; mva_classes_list0 = []; mzvalues2discard = []; end
if nargin < 7; mzvalues2discard = []; end

for main_mask = main_mask_list
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];
        
        [ ~, ~, ~, ...
            mva_list, ...
            amplratio4mva_array, numPeaks4mva_array, perc4mva_array, ...
            numComponents_array, numLoadings_array, ...
            ~, ...
            mva_molecules_list, ppmTolerance, ...
            ~, ~, ...
            pa_max_ppm, fig_ppmTolerance, outputs_path ] = f_reading_inputs(csv_inputs);
        
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
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
        rois_path               = [ char(outputs_path) '\rois\' ];
        
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
        
        if (mask_on == 1) && ~strcmpi(main_mask,"no mask")
            load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'roi'])
            mask = reshape(roi.pixelSelection',[],1);
        else
            mask = true(ones(size(datacube,1),1));
        end
        
        for norm_type = norm_list
            
            % Loading normalised data
            
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep char(norm_type) filesep 'data'])
            
            if mask_on == 1
                data(~mask,:) = NaN;
            end
            
            %
            
            mvai = 0;
            for mva_type = mva_list
                mvai = mvai+1;
                
                numComponents = numComponents_array(mvai);
                numLoadings = numLoadings_array(mvai);
                
                % Different peak lists
                
                % Vector of mz values
                
                if ~isempty(mva_mzvalues_vector)
                    
                    mva_path = [ char(outputs_path) '\mva ' char(num2str(length(mva_mzvalues_vector))) ' adhoc mz values\' ];
                    
                    if ~isempty(mzvalues2discard)
                        mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                    end
                    
                    f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, data, numComponents, numLoadings, datacube, datacubeonly_peakDetails, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num,  fig_ppmTolerance)
                    
                    
                end
                
                % Lists
                
                for molecules_list = mva_molecules_list
                    
                    mva_path = [ char(outputs_path) '\mva ' char(molecules_list) '\' ];
                    
                    if ~isempty(mzvalues2discard)
                        mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                    end
                    
                    f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, data, numComponents, numLoadings, datacube, datacubeonly_peakDetails, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num,  fig_ppmTolerance)
                    
                end
                
                % Highest peaks
                
                % Number
                
                for numPeaks4mva = numPeaks4mva_array
                    
                    mva_path = [ char(outputs_path) '\mva ' char(num2str(numPeaks4mva)) ' highest peaks\' ];
                    
                    if ~isempty(mzvalues2discard)
                        mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                    end
                    
                    f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, data, numComponents, numLoadings, datacube, datacubeonly_peakDetails, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num,  fig_ppmTolerance)
                    
                end
                
                % Percentile
                
                for perc4mva = perc4mva_array
                    
                    mva_path = [ char(outputs_path) '\mva percentile ' char(num2str(perc4mva)) ' peaks\' ];
                    
                    if ~isempty(mzvalues2discard)
                        mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                    end
                    
                    f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, data, numComponents, numLoadings, datacube, datacubeonly_peakDetails, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num, fig_ppmTolerance)
                    
                end
                
                % Highest peaks after a thresholding step based on the ratio between the two amplitudes of each peak
                
                for amplratio4mva = amplratio4mva_array
                    
                    % Number
                    
                    for numPeaks4mva = numPeaks4mva_array
                        
                        mva_path = [ char(outputs_path) '\mva ' char(num2str(numPeaks4mva)) ' highest peaks + ' char(num2str(amplratio4mva)) ' ampls ratio\' ];
                        
                        if ~isempty(mzvalues2discard)
                            mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                        end
                        
                        f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, data, numComponents, numLoadings, datacube, datacubeonly_peakDetails, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num, fig_ppmTolerance)
                        
                    end
                    
                    % Percentile
                    
                    for perc4mva = perc4mva_array
                        
                        mva_path = [ char(outputs_path) '\mva percentile ' char(num2str(perc4mva)) ' peaks + ' char(num2str(amplratio4mva)) ' ampls ratio\' ];
                        
                        if ~isempty(mzvalues2discard)
                            mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                        end
                        
                        f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, data, numComponents, numLoadings, datacube, datacubeonly_peakDetails, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num, fig_ppmTolerance)
                        
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
                
                %
                
                for classes_list = mva_classes_list
                    
                    for classi = 2:size(classes_info,1)
                        
                        if strcmpi(classes_list,classes_info{classi,1})==1
                            
                            mva_path = [ char(outputs_path) '\mva ' char(classes_info{classi,1}) '\' ];
                            
                            if ~isempty(mzvalues2discard)
                                mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                            end
                            
                            f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, data, numComponents, numLoadings, datacube, datacubeonly_peakDetails, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num, fig_ppmTolerance)
                            
                        end
                        
                    end
                    
                end
                
                if strcmpi( mva_classes_list, "all" )
                    
                    for classi = 2:size(classes_info,1)
                        
                        mva_path = [ char(outputs_path) '\mva ' char(classes_info{classi,1}) '\' ];
                        
                        if ~isempty(mzvalues2discard)
                            mva_path = [ mva_path(1:end-1)  ' (' num2str(length(mzvalues2discard)) ' black peaks removed)\' ];
                        end
                        
                        f_saving_mva_auxiliar( filesToProcess(file_index).name(1,1:end-6), main_mask, mva_type, mva_path, norm_type, data, numComponents, numLoadings, datacube, datacubeonly_peakDetails, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num, fig_ppmTolerance)
                        
                    end
                    
                end
                
            end
        end
    end
end

function f_saving_normalised_data( filesToProcess, mask_list, norm_list )

% This function normalises the data of all peaks saved in the datacube, and
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

for mask_type = mask_list
    
    for file_index = 1:length(filesToProcess)
        
        % Read relevant information from "inputs_file.xlsx"
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        % Define path to spectral details folder
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        
        % Load datacube
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\datacube.mat' ])
        
        for norm_type = norm_list
            
            disp(['! Normalising ' filesToProcess(file_index).name(1,1:end-6) ' data using ' char(norm_type) ' ...'])
            
            % Normalise data
            
            data = f_norm_datacube( datacube, norm_type ); % normalisation
            
            % Create folder for normalised data
            
            mkdir([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(norm_type) ])
            cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(norm_type) ])
            
            % Save normalised data
            
            save('data.mat','data','-v7.3')
            
            disp('! Normalised data saved.')
            
        end
    end
end
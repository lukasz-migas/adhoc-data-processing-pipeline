function f_saving_datacube_peaks_details( filesToProcess, mask_list )

% This function searches for all peaks of interest i.e. that will be
% required in any of the following steps of the data processing (e.g. 
% univariate or multivariate analyses, plotting of single ion images). Each
% peak is stored with information regarding its start, centroid, end, and
% intensity in the total spectrum.
% 
% Inputs:
% filesToProcess - Matlab structure created by matlab function dir, 
% containing the list of files to process and their locations / paths
% mask_list - array with names of masks to be used (sequentially) to reduce 
% data to a particular group of pixels
%
% Note: 
% The masks in mask_list can be “no mask” (all pixels of the imzml file are
% used), or names of folders saved in the outputs folder “rois” (created as
% part of the pipeline)
% 
% Outputs:
% datacubeonly_peakDetails.mat – Matlab variable with the start, centroid, 
% and end of each relevant peak (in m/z), as well as its intenisty in the 
% total spectrum

for file_index = 1:length(filesToProcess)
    
    for mask_type = mask_list
        
        % Read relevant information from "inputs_file.xlsx"
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        [ ~, ~, ~, ~, amplratio4mva_array, numPeaks4mva_array, perc4mva_array, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        % Define paths to spectral details and peak assigments folders
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
        
        % Load assigments information (to HMDB and lists of molecules of interest) information
        
        load([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\hmdb_sample_info.mat' ])
        load([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\relevant_lists_sample_info.mat' ])
        
        % Load peak details
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\peakDetails.mat' ])
                
        % Load total spectrum information
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_intensities.mat' ])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_mzvalues.mat' ])
                
        disp('! Defining mz values that have to be saved in each data cube...')
        
        molecules_classes_specification_path = [ filesToProcess(file_index).folder '\molecules_classes_specification' ];
        
        % Search for peaks of interest
        
        datacubeonly_peakDetails = f_peakdetails4datacube( relevant_lists_sample_info, amplratio4mva_array, numPeaks4mva_array, perc4mva_array, molecules_classes_specification_path, hmdb_sample_info, peakDetails, totalSpectrum_mzvalues, totalSpectrum_intensities );
        
        % Save details for peaks of interest
        
        cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        save('datacubeonly_peakDetails','datacubeonly_peakDetails','-v7.3')
        
        disp('! Data cube specific peak details saved.')
        
    end
    
end
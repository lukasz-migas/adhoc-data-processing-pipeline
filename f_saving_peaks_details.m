
function f_saving_peaks_details( filesToProcess, mask_list)

% This function performs peak detection in the total spectrum.
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
% peakDetails - matlab variable with the start, centroid and end of each 
% peak in terms of m/z values, and amplitude at the centroid of the peak

for mask_type = mask_list
            
    for file_index = 1:length(filesToProcess)
        
        % Read outputs path from "inputs_file.xlsx"
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        % Define spectral details paths
                
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        
        % Loading the total spectrum
        
        cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        
        disp('! Loading total spectrum...')
        
        load('totalSpectrum_mzvalues')
        load('totalSpectrum_intensities')
        
        disp('! Running peak picking on total spectum...')
        
        % Detecting peaks in the total spectrum using the Gradient algorithm
        
        peakPicking = GradientPeakDetection();
                
        peaks = peakPicking.process(SpectralData(totalSpectrum_mzvalues, totalSpectrum_intensities)); % peak pick total spectrum
                
        peakDetails = [ [ peaks.minSpectralChannel ]', [ peaks.centroid ]', [ peaks.maxSpectralChannel ]', [ peaks.intensity ]' ]; 
        
        % Saving the peak details mat file
        
        save('peakDetails','peakDetails','-v7.3')
        
        disp('! Peak details saved.')
        
    end
    
end



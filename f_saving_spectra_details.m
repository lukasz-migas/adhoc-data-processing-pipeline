% * This function performs:*
% - data pre-processing
% - total spectrum computation
%
% *Inputs:*
% filesToProcess - Matlab structure created by the function “dir” which 
% contains the list of files to process and their locations (paths)
% preprocessing_file - SpectralAnalysis pre-processing file
% mask - Name of the mask to be used to reduce the data to a particular 
% group of pixels of interest. This name can  be either “no mask”, in which
% case all pixels of the imzml file are used, or a name of a folder saved 
% in a folder called “rois” which is part of the folders created by the 
% pipeline
% 
% *Outputs:*
% totalSpectrum_intensities - total spectrum counts (per imzml and mask)
% totalSpectrum_mzvalues - total spectrum mass channels (per imzml and mask)
% pixels_num - number of pixels of interest (per imzml and mask)

function f_saving_spectra_details( filesToProcess, preprocessing_file, mask_list)

for file_index = 1:length(filesToProcess)

    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
    
    % Read outputs path from "inputs_file.xlsx"

    [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
    
    % Define rois and spectral details paths

    rois_path               = [ char(outputs_path) '\rois\' ];
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ]; if ~exist(spectra_details_path,'dir'); mkdir(spectra_details_path); end

    for mask_type = mask_list
        
        % Create and move to the folder where the spectral details of the 
        % dataset will be saved. The representative spectrum will differ
        % depending on the mask used.
        
        mkdir([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        
        % Data pre-processing and total spectrum computation
        
        disp('! Running pre-processing and generating total spectra...')
        
        addJARsToClassPath()
        preprocessing = PreprocessingWorkflow;
        preprocessing.loadWorkflow(preprocessing_file);
        
        parser = ImzMLParser([filesToProcess(file_index).folder filesep filesToProcess(file_index).name]);
        parser.parse; % parse the imzML file
                
        spectrumGeneration = TotalSpectrum();
        spectrumGeneration.setPreprocessingWorkflow(preprocessing); % setting preprocessing workflow
        
        % Data reduction based on the pixels of interest
        
        data = DataOnDisk(parser);
        
        pixels_num = sum(sum(data.regionOfInterest.pixelSelection));
        
        if ~isequal(mask_type,"no mask")
            
            load([ rois_path filesToProcess(file_index).name(1,1:end-6)  '\' char(mask_type) '\roi' ]) % loading region of interest
            
            roiList = RegionOfInterestList;
            roiList.add(roi);
            spectrumGeneration.processEntireDataset(false);
            spectrumGeneration.setRegionOfInterestList(roiList);
            
            pixels_num = sum(sum(roi.pixelSelection));
            
        end
                
        totalSpectrum = spectrumGeneration.process(data); % computing total spectrum
        totalSpectrum = totalSpectrum.get(1);
        
        totalSpectrum_mzvalues      = totalSpectrum.spectralChannels;
        totalSpectrum_intensities   = totalSpectrum.intensities;
        
        % Saving outputs
        
        save('totalSpectrum_mzvalues','totalSpectrum_mzvalues','-v7.3')
        save('totalSpectrum_intensities','totalSpectrum_intensities','-v7.3')
        save('pixels_num','pixels_num','-v7.3')
        
        disp('! Total spectrum saved.')
        
    end
    
end
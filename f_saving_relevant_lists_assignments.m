function f_saving_relevant_lists_assignments( filesToProcess, mask_list )

% This function searches for tentative assignments for every peak in the 
% total spectrum. All molecules beloging to at least one of the predefined
% lists of molecules of interest are considered in this search.
% Measured mass (peak centroid) is compared with theoretical mass (for 
% predefined set of adducts). If the difference between these masses is 
% below the predefined ppm error, the assigment is stored.
%
% Note: Set of adducts to be considered and maximum ppm error accepted are 
% specified in the excel file “inputs_file” (saved in the data folder).
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
% relevant_lists_assignments.mat – matrix of strings with information regarding all 
% potential assignments
% relevant_lists_assignments.txt – txt file with information regarding all potential 
% assignments

for file_index = 1:length(filesToProcess)
    
    % Read relevant information from "inputs_file.xlsx"
    
    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ]; % path to inputs_file.xlsx
    [ modality, polarity, adducts, ...
        ~, ~, ~, ~, ~, ~, ...
        mva_molecules_lists_csv_list, mva_molecules_lists_label_list, ~, ...
        pa_molecules_lists_csv_list, pa_molecules_lists_label_list, ppmTolerance, ...
        ~, ...
        outputs_path ] = f_reading_inputs(csv_inputs);
    
    % Define paths to spectral details and peak assigments folders
        
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
    peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];    mkdir(peak_assignments_path)

    for mask_type = mask_list
        
        % Load peak details
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\peakDetails.mat'])

        sample_peaks_mzvalues = peakDetails(:,2);
        
        % Load total spectrum and pixel number
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_intensities.mat'])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_mzvalues.mat'])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\pixels_num.mat'])
        
        % Find total spectrum indexes for all detected peaks
                                    
        [~, peak_mz_indexes] = ismembertol(peakDetails(:,2),totalSpectrum_mzvalues,1e-7);
        sample_peaks_intensities = totalSpectrum_intensities(peak_mz_indexes)'; 
        
        % Load the names (ids) of the lists of molecules of interest
        
        molecules_lists_csv_list = [ mva_molecules_lists_csv_list, pa_molecules_lists_csv_list ];
        molecules_lists_label_list = [ mva_molecules_lists_label_list, pa_molecules_lists_label_list ];
        
        % Load the names and monoisotopic masses of the molecules of interest
        
        [ ~, unique_lists_indexes ] = unique(molecules_lists_label_list);
        [ relevant_lists_mzvalues, relevant_lists_names, relevant_lists_listnames ] = f_molecules_list_mat(molecules_lists_csv_list(unique_lists_indexes), molecules_lists_label_list(unique_lists_indexes));

        disp(' ')
        disp('! Molecules lists being assigned:')
        disp(' ')
        disp([ repmat('. ',size(char(unique(relevant_lists_listnames)),1),1) char(unique(relevant_lists_listnames)) ])
        disp(' ')
        
        %%% Search for assigments
        
        tic
        
        [ adductMasses ] = f_makeAdductMassList( adducts, relevant_lists_mzvalues, polarity); % creates matrix of possible adduct masses
        
        relevant_lists_sample_info = string([]);
        g_index = 0;
        
        for i = 1:length(sample_peaks_mzvalues)
            
            % Compute ppm error
            
            ppmError = abs(((adductMasses - sample_peaks_mzvalues(i))./ sample_peaks_mzvalues(i)) * 1000000); % checks each peak against possible adduct list
            real_ppmError = (((adductMasses - sample_peaks_mzvalues(i))./ sample_peaks_mzvalues(i)) * 1000000);
            [matchesR, matchesC] = find(ppmError < ppmTolerance); % finds those within ppm error
                          
            % Store information regarding each potential assigment
            
            if ~isempty(matchesR)
                
                for j = 1:sum(sum(ppmError < ppmTolerance)) % adds the relevant matched peaks to the database
                    
                    g_index = g_index + 1;
                    
                    relevant_lists_sample_info(g_index,1) = relevant_lists_names(matchesR(j)); % molecule name
                    relevant_lists_sample_info(g_index,2) = num2str(adductMasses(matchesR(j), matchesC(j)),'%1.12f'); % theoretical m/z
                    
                    if strcmp(polarity, 'positive')
                        
                        if double(adducts{matchesC(j)}(1)) == 45 || double(adducts{matchesC(j)}(1)) == 43
                            relevant_lists_sample_info(g_index,3) = cell2mat(['[M' adducts(matchesC(j)) ']+']); % adduct type
                        else
                            relevant_lists_sample_info(g_index,3) = cell2mat(['[M+' adducts(matchesC(j)) ']+']); % adduct type
                        end
                        
                    elseif strcmp(polarity, 'negative')
                        
                        if double(adducts{matchesC(j)}(1)) == 45 || double(adducts{matchesC(j)}(1)) == 43
                            relevant_lists_sample_info(g_index,3) = cell2mat(['[M' adducts(matchesC(j)) ']-']); % adduct type
                        else
                            relevant_lists_sample_info(g_index,3) = cell2mat(['[M+' adducts(matchesC(j)) ']-']); % adduct type
                        end
                        
                    end
                    
                    relevant_lists_sample_info(g_index,4)   = num2str(sample_peaks_mzvalues(i),'%1.12f'); % measured m/z
                    relevant_lists_sample_info(g_index,5)   = ppmError(matchesR(j), matchesC(j)); % abs ppm error
                    relevant_lists_sample_info(g_index,6)   = sample_peaks_intensities(i); % total peak intensity
                    relevant_lists_sample_info(g_index,7)   = relevant_lists_listnames(matchesR(j)); % database (i.e. the name of the lists)
                    relevant_lists_sample_info(g_index,8)   = real_ppmError(matchesR(j), matchesC(j)); % real ppm error
                    relevant_lists_sample_info(g_index,9)   = modality;
                    relevant_lists_sample_info(g_index,10)  = polarity;
                    relevant_lists_sample_info(g_index,11)  = sample_peaks_intensities(i)./pixels_num; % mean peak intensity
                    relevant_lists_sample_info(g_index,12)  = num2str(relevant_lists_mzvalues(matchesR(j)),'%1.12f'); % monoisotopic mass
                                        
                end
            end
        end
        
        t = toc; disp(['Peak matching time elapsed: ' num2str(t)])
        
        % Create peak assigments folder
        
        mkdir([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        cd([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' ])
        
        % Save peak assigments tables
        
        save('relevant_lists_sample_info','relevant_lists_sample_info','-v7.3')
                
        table = [ 
            "molecule" "theo mz" "adduct" "meas mz" "abs ppm" "total counts" "database" "ppm" "modality" "polarity" "mean counts" "monoisotopic mass"
            relevant_lists_sample_info 
            ]; 
        
        txt_row = strcat(repmat('%s\t',1,size(table,2)-1),'%s\n');
        
        fileID = fopen('relevant_lists_assignments.txt','w');
        fprintf(fileID,txt_row, table');
        fclose(fileID);
        
    end
    
end
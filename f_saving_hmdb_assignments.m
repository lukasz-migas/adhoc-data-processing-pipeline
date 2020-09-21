
function f_saving_hmdb_assignments( filesToProcess, mask_list )

% This function searches for tentative assignments for every peak in the 
% total spectrum. All molecules in HMDB are considered in this search.
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
% hmdb_assignments.mat – matrix of strings with information regarding all 
% potential assignments
% hmdb_assignments.txt – txt file with information regarding all potential 
% assignments

% Load HMDB information (e.g.: molecules names, monoisotopic masses, kingdom, superclass, class, subclass and others)

load('\\datasvr1\MALDI_AMBIENT_DATA\2020_Scripts for Data Processing\Git Repository (March 2020)\databases-mat-files\complete_hmdb_info_strings.mat') % hmdb database information

% The file loaded above can be found in the git repository "adhoc-data-processing-pipeline", folder "databases-mat-files".

for file_index = 1:length(filesToProcess)
    
    % Read outputs path from "inputs_file.xlsx"
    
    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ]; % path to inputs_file.xlsx
    [ modality, polarity, adducts, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ppmTolerance, ~, outputs_path ] = f_reading_inputs(csv_inputs);
    
    % Define paths to spectral details and peak assigments folders
    
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
    peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
    
    for mask_type = mask_list
        
        % Load peak details
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\peakDetails.mat'])
       
        sample_peaks_mzvalues = peakDetails(:,2);

        % Load total spectrum and pixel number
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_intensities.mat'])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_mzvalues.mat'])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\pixels_num.mat'])
        
        % Find total spectrum indexes for all detected peaks
                                    
        [~, peak_mz_indexes] = ismembertol(peakDetails(:,2),totalSpectrum_mzvalues,1e-7); % a peak is the same when the diff between the two m/z is < 1e-7
        sample_peaks_intensities = totalSpectrum_intensities(peak_mz_indexes)';
        
        % Collect information from the HMDB file
        
        [~, indexes ] = unique(complete_hmdb_info_strings(:,3));
        molecules_hmdb_info_strings = complete_hmdb_info_strings(indexes,3:end);
        
        hmdb_names = molecules_hmdb_info_strings(:,1); % molecule names
        hmdb_mzvalues = double(molecules_hmdb_info_strings(:,3)); % monoisotopic masses
        hmdb_other = molecules_hmdb_info_strings(:,[ 2 4:8 ]); % HMDB id and molceular classes information
                
        %%% Search for assigments
        
        tic
        
        % Create a matrix of theoretical masses (one column per adduct, one row per molecule)
        
        [ adductMasses ] = f_makeAdductMassList( adducts, hmdb_mzvalues, polarity ); 
        
        hmdb_sample_info = string([]);
        g_index = 0;
        for i = 1:length(sample_peaks_mzvalues)
            
            % Compute ppm error
            
            ppmError = abs(((adductMasses - sample_peaks_mzvalues(i))./ sample_peaks_mzvalues(i)) * 1000000); % checks each peak against possible adduct list
            real_ppmError = (((adductMasses - sample_peaks_mzvalues(i))./ sample_peaks_mzvalues(i)) * 1000000); % checks each peak against possible adduct list
            [matchesR, matchesC] = find(ppmError < ppmTolerance); % finds those within ppm error
            
            % Store information regarding each potential assigment
            
            if ~isempty(matchesR)
                
                for j = 1:sum(sum(ppmError < ppmTolerance)) % adds the relevant matched peaks to the database
                    
                    g_index = g_index + 1;
                    
                    hmdb_sample_info(g_index,1) = hmdb_names(matchesR(j)); % molecule name
                    hmdb_sample_info(g_index,2) = num2str(adductMasses(matchesR(j), matchesC(j)),'%1.12f'); % theoretical m/z
                                        
                    if strcmp(polarity, 'positive')
                        
                        if double(adducts{matchesC(j)}(1)) == 45 || double(adducts{matchesC(j)}(1)) == 43
                            hmdb_sample_info(g_index,3) = cell2mat(['[M' adducts(matchesC(j)) ']+']); % adduct type
                        else
                            hmdb_sample_info(g_index,3) = cell2mat(['[M+' adducts(matchesC(j)) ']+']); % adduct type
                        end
                        
                    elseif strcmp(polarity, 'negative')
                        
                        if double(adducts{matchesC(j)}(1)) == 45 || double(adducts{matchesC(j)}(1)) == 43
                            hmdb_sample_info(g_index,3) = cell2mat(['[M' adducts(matchesC(j)) ']-']); % adduct type
                        else
                            hmdb_sample_info(g_index,3) = cell2mat(['[M+' adducts(matchesC(j)) ']-']); % adduct type
                        end
                        
                    end
                    
                    hmdb_sample_info(g_index,4)     = num2str(sample_peaks_mzvalues(i),'%1.12f'); % measured m/z
                    hmdb_sample_info(g_index,5)     = ppmError(matchesR(j), matchesC(j)); % abs ppm error
                    hmdb_sample_info(g_index,6)     = sample_peaks_intensities(i); % total peak intensity
                    hmdb_sample_info(g_index,7)     = 'hmdb'; % database
                    hmdb_sample_info(g_index,8)     = real_ppmError(matchesR(j), matchesC(j)); % real ppm error
                    hmdb_sample_info(g_index,9)     = modality; 
                    hmdb_sample_info(g_index,10)    = polarity;
                    hmdb_sample_info(g_index,11)    = sample_peaks_intensities(i)./pixels_num; % mean peak intensity
                    hmdb_sample_info(g_index,12)    = molecules_hmdb_info_strings(matchesR(j),3); % monoisotopic mass
                    
                    if ~ismissing(hmdb_other(matchesR(j),1))
                        hmdb_sample_info(g_index,13) = hmdb_other(matchesR(j),1);
                    else
                        hmdb_sample_info(g_index,13) = '-';
                    end
                    
                    for classi = 1:4
                        
                        if ~ismissing(hmdb_other(matchesR(j),1+classi))
                            hmdb_sample_info(g_index,13+classi) = hmdb_other(matchesR(j),1+classi); % hmdb kingdom, superclass, class and subclass
                        else
                            hmdb_sample_info(g_index,13+classi) = '-';
                        end
                        
                    end
                    
                end
            end
        end
        
        t = toc; disp(['Peak matching time elapsed: ' num2str(t)])
        
        % Create peak assigments folder
        
        mkdir([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        cd([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        
        % Save peak assigments tables
        
        save('hmdb_sample_info','hmdb_sample_info','-v7.3')
        
        table = [ 
            "molecule" "theo mz" "adduct" "meas mz" "abs ppm" "total counts" "database" "ppm" "modality" "polarity" "mean counts" "monoisotopic mass" "hmdb id" "kingdom" "super class" "class" "subclass"
            hmdb_sample_info 
            ]; 
        
        txt_row = strcat(repmat('%s\t',1,size(table,2)-1),'%s\n');
        
        fileID = fopen('hmdb_assignments.txt','w');
        fprintf(fileID,txt_row, table');
        fclose(fileID);

    end
    
end



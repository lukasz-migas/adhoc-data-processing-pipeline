function f_saving_relevant_lists_assignments( filesToProcess, mask_list )

% for each file
for file_index = 1:length(filesToProcess)
    % get the inputs file location
    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
    % and extract the relevant information
    [ modality, polarity, adducts, ...
        ~, ~, ~, ~, ~, ~, ...
        mva_molecules_lists_csv_list, mva_molecules_lists_label_list, ~, ...
        pa_molecules_lists_csv_list, pa_molecules_lists_label_list, ppmTolerance, ...
        ~, ...
        outputs_path ] = f_reading_inputs(csv_inputs);
        %get the directory of the output folder for spectra details
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
    % get the directory for the output folder of peak assignments and
    % create the associated directory
    peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];    mkdir(peak_assignments_path)
    % for each mask
    for mask_type = mask_list
        
        % Loading dataset peak details
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\peakDetails.mat'])

        sample_peaks_mzvalues = peakDetails(:,2);
        
        % Loading total spectrum information and pixel numbers
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_intensities.mat'])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_mzvalues.mat'])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\pixels_num.mat'])
        
        % Finding the total spectrum indexes for all peaks found in it
                                    
        [~, peak_mz_indexes] = ismembertol(peakDetails(:,2),totalSpectrum_mzvalues,1e-7);
                
        sample_peaks_intensities = totalSpectrum_intensities(peak_mz_indexes)'; 
        
        % Loading which molecules lists are of interest
        
        molecules_lists_csv_list = [ mva_molecules_lists_csv_list, pa_molecules_lists_csv_list ];
        molecules_lists_label_list = [ mva_molecules_lists_label_list, pa_molecules_lists_label_list ];
        
        [ ~, unique_lists_indexes ] = unique(molecules_lists_label_list);
        
        [ relevant_lists_mzvalues, relevant_lists_names, relevant_lists_listnames ] = f_molecules_list_mat(molecules_lists_csv_list(unique_lists_indexes), molecules_lists_label_list(unique_lists_indexes));

        disp(' ')
        disp('! Molecules lists being assigned:')
        disp(' ')
        disp([ repmat('. ',size(char(unique(relevant_lists_listnames)),1),1) char(unique(relevant_lists_listnames)) ])
        disp(' ')
        
        % Assignments
        
        tic
        
        [ adductMasses ] = f_makeAdductMassList( adducts, relevant_lists_mzvalues, polarity); % creates matrix of possible adduct masses
        
        relevant_lists_sample_info = string([]);
        g_index = 0;
        
        for i = 1:length(sample_peaks_mzvalues)
            
            ppmError = abs(((adductMasses - sample_peaks_mzvalues(i))./ sample_peaks_mzvalues(i)) * 1000000); % checks each peak against possible adduct list
            real_ppmError = (((adductMasses - sample_peaks_mzvalues(i))./ sample_peaks_mzvalues(i)) * 1000000);

            [matchesR, matchesC] = find(ppmError < ppmTolerance); % finds those within ppm error
                                    
            if ~isempty(matchesR)
                
                for j = 1:sum(sum(ppmError < ppmTolerance)) % adds the relevant matched peaks to the database
                    
                    g_index = g_index + 1;
                    
                    relevant_lists_sample_info(g_index,1) = relevant_lists_names(matchesR(j));
                    relevant_lists_sample_info(g_index,2) = num2str(adductMasses(matchesR(j), matchesC(j)),'%1.12f');
                    
                    if strcmp(polarity, 'positive')
                        
                        if double(adducts{matchesC(j)}(1)) == 45 || double(adducts{matchesC(j)}(1)) == 43
                            relevant_lists_sample_info(g_index,3) = cell2mat(['[M' adducts(matchesC(j)) ']+']);
                        else
                            relevant_lists_sample_info(g_index,3) = cell2mat(['[M+' adducts(matchesC(j)) ']+']);
                        end
                        
                    elseif strcmp(polarity, 'negative')
                        
                        if double(adducts{matchesC(j)}(1)) == 45 || double(adducts{matchesC(j)}(1)) == 43
                            relevant_lists_sample_info(g_index,3) = cell2mat(['[M' adducts(matchesC(j)) ']-']);
                        else
                            relevant_lists_sample_info(g_index,3) = cell2mat(['[M+' adducts(matchesC(j)) ']-']);
                        end
                        
                    end
                    
                    relevant_lists_sample_info(g_index,4)   = num2str(sample_peaks_mzvalues(i),'%1.12f');
                    relevant_lists_sample_info(g_index,5)   = ppmError(matchesR(j), matchesC(j));
                    relevant_lists_sample_info(g_index,6)   = sample_peaks_intensities(i);
                    relevant_lists_sample_info(g_index,7)   = relevant_lists_listnames(matchesR(j));
                    
                    relevant_lists_sample_info(g_index,8)   = real_ppmError(matchesR(j), matchesC(j));
                    relevant_lists_sample_info(g_index,9)   = modality;
                    relevant_lists_sample_info(g_index,10)  = polarity;
                    relevant_lists_sample_info(g_index,11)  = sample_peaks_intensities(i)./pixels_num; % mean spectra
                    
                    relevant_lists_sample_info(g_index,12)  = num2str(relevant_lists_mzvalues(matchesR(j)),'%1.12f'); % monoisotopic mass
                                        
                end
            end
        end
        
        t = toc; disp(['Peak matching time elapsed: ' num2str(t)])
        
        mkdir([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        cd([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' ])
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
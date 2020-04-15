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
        
        % Total spectrum information and pixel numbers
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_intensities.mat'])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_mzvalues.mat'])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\pixels_num.mat'])
        
        % Total spectrum indexes for all picked peaks
        
        % (when it was realised that the 6th element of peakDetails is not
        % the index of the centre of mass of the peak 4 Sept 2019)
                    
        peak_mz_indexes = [];
        for mzi = 1:size(peakDetails,1)
            [~, index] = min(abs(totalSpectrum_mzvalues-peakDetails(mzi,2)));
            peak_mz_indexes(mzi) = index;
        end
                
        sample_peaks_intensities = totalSpectrum_intensities(peak_mz_indexes); % this was incorrect - it should be based on the spectra of the dataset because that is what matches the pixel_num
        
        %%% Loading information from lists of relevant molecules
        
        molecules_lists_csv_list = [ mva_molecules_lists_csv_list, pa_molecules_lists_csv_list ];
        molecules_lists_label_list = [ mva_molecules_lists_label_list, pa_molecules_lists_label_list ];
        
        [ ~, unique_lists_indexes ] = unique(molecules_lists_label_list);
        
        [ relevant_lists_mzvalues, relevant_lists_names, relevant_lists_listnames ] = f_molecules_list_mat(molecules_lists_csv_list(unique_lists_indexes), molecules_lists_label_list(unique_lists_indexes));

        disp(' ')
        disp('!!! Lists of molecules read for assigments:')
        disp(' ')
        disp(relevant_lists_names)
        
        %%% Matching
        
        tic
        
        [ adductMasses ] = f_makeAdductMassList( adducts, relevant_lists_mzvalues, polarity); % creates matrix of possible adduct masses
        
        relevant_lists_sample_info = string([]);
        relevant_lists_sample_info_aux = [];
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
                    
                    relevant_lists_sample_info_aux(g_index,1) = num2str(sample_peaks_mzvalues(i),'%1.12f');
                    
                end
            end
        end
        
        t = toc; disp(['Peak matching time elapsed: ' num2str(t)])
        
        mkdir([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        cd([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' ])
        save('relevant_lists_sample_info','relevant_lists_sample_info','-v7.3')
        save('relevant_lists_sample_info_aux','relevant_lists_sample_info_aux','-v7.3')
                
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
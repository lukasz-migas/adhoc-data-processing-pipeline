function f_matching_data_with_hmdb( filesToProcess, mask_list )

% Loading hmdb database info

load('X:\2019_Scripts for Data Processing\complete_hmdb_info_strings.mat')

for file_index = 1:length(filesToProcess)
    
    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
    
    [ modality, polarity, adducts, ~, ~, ~, ~, ~, ~, ~, ~, ~, ppmTolerance, ~, outputs_path ] = f_reading_inputs(csv_inputs);
    
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
    peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
    
    for mask_type = mask_list
        
        % Loading dataset peak details
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\peakDetails.mat'])
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_intensities.mat'])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_mzvalues.mat'])
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\pixels_num.mat'])
                
        sample_peaks_mzvalues = peakDetails(:,2);
                
        peak_mz_indexes = []; % this was added when it was realised that the 6th element of peakDetails is not the index of the centre of mass of the peak 4 Sept 2019
        for mzi = 1:size(peakDetails,1)
            [~, index] = min(abs(totalSpectrum_mzvalues-peakDetails(mzi,2)));
            peak_mz_indexes(mzi) = index;
        end
                
        sample_peaks_intensities = totalSpectrum_intensities(peak_mz_indexes); % this was incorrect - it should be based on the spectra of the dataset because that is what matches the pixel_num
        
        [~, indexes ] = unique(complete_hmdb_info_strings(:,3));
        molecules_hmdb_info_strings = complete_hmdb_info_strings(indexes,3:end);
        
        hmdb_names = molecules_hmdb_info_strings(:,1);
        hmdb_mzvalues = double(molecules_hmdb_info_strings(:,3));
        hmdb_other = molecules_hmdb_info_strings(:,[ 2 4:8 ]);
                
        %%% Matching
        
        tic
        
        [ adductMasses ] = f_makeAdductMassList( adducts, hmdb_mzvalues, polarity); % creates matrix of possible adduct masses
        
        hmdb_sample_info = string([]);
        g_index = 0;
        
        for i = 1:length(sample_peaks_mzvalues)
            ppmError = abs(((adductMasses - sample_peaks_mzvalues(i))./ sample_peaks_mzvalues(i)) * 1000000); % checks each peak against possible adduct list
            real_ppmError = (((adductMasses - sample_peaks_mzvalues(i))./ sample_peaks_mzvalues(i)) * 1000000); % checks each peak against possible adduct list
            [matchesR, matchesC] = find(ppmError < ppmTolerance); % finds those within ppm error
            
            if ~isempty(matchesR)
                
                for j = 1:sum(sum(ppmError < ppmTolerance)) % adds the relevant matched peaks to the database
                    
                    g_index = g_index + 1;
                    
                    hmdb_sample_info(g_index,1) = hmdb_names(matchesR(j));
                    hmdb_sample_info(g_index,2) = adductMasses(matchesR(j), matchesC(j));
                    
                    if strcmp(polarity, 'positive')
                        
                        if double(adducts{matchesC(j)}(1)) == 45 || double(adducts{matchesC(j)}(1)) == 43
                            hmdb_sample_info(g_index,3) = cell2mat(['[M' adducts(matchesC(j)) ']+']);
                        else
                            hmdb_sample_info(g_index,3) = cell2mat(['[M+' adducts(matchesC(j)) ']+']);
                        end
                        
                    elseif strcmp(polarity, 'negative')
                        
                        if double(adducts{matchesC(j)}(1)) == 45 || double(adducts{matchesC(j)}(1)) == 43
                            hmdb_sample_info(g_index,3) = cell2mat(['[M' adducts(matchesC(j)) ']-']);
                        else
                            hmdb_sample_info(g_index,3) = cell2mat(['[M+' adducts(matchesC(j)) ']-']);
                        end
                        
                    end
                    
                    hmdb_sample_info(g_index,4)     = sample_peaks_mzvalues(i);
                    hmdb_sample_info(g_index,5)     = ppmError(matchesR(j), matchesC(j));
                    hmdb_sample_info(g_index,6)     = sample_peaks_intensities(i);
                    hmdb_sample_info(g_index,7)     = 'hmdb';
                    
                    hmdb_sample_info(g_index,8)     = real_ppmError(matchesR(j), matchesC(j));
                    hmdb_sample_info(g_index,9)     = modality;
                    hmdb_sample_info(g_index,10)    = polarity;
                    hmdb_sample_info(g_index,11)    = sample_peaks_intensities(i)./pixels_num;
                    
                    hmdb_sample_info(g_index,12)  = hmdb_mzvalues(matchesR(j)); % monoisotopic mass

                    
                    if ~ismissing(hmdb_other(matchesR(j),1))
                        hmdb_sample_info(g_index,13) = hmdb_other(matchesR(j),1);
                    else
                        hmdb_sample_info(g_index,13) = '-';
                    end
                    
                    for classi = 1:4
                        
                        if ~ismissing(hmdb_other(matchesR(j),1+classi))
                            hmdb_sample_info(g_index,13+classi) = hmdb_other(matchesR(j),1+classi);
                        else
                            hmdb_sample_info(g_index,13+classi) = '-';
                        end
                        
                    end
                    
                end
            end
        end
        
        t = toc; disp(['Peak matching time elapsed: ' num2str(t)])
        
        mkdir([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
        cd([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\'])
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



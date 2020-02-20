function f_saving_hmdb_assignments_ca( filesToProcess, mask_list )

% Loading hmdb database info

load('\\datasvr1\MALDI_AMBIENT_DATA\2020_Scripts for Data Processing\Git Repository\databases-mat-files\complete_hmdb_info_strings.mat')

for file_index = 1:length(filesToProcess)
    
    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
    
    [ modality, polarity, adducts, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ppmTolerance, ~, outputs_path ] = f_reading_inputs(csv_inputs);
    
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
    peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
    
    for mask_type = mask_list
        
        % Peak details (common for all files to be combined)
        
        if file_index == 1
            
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\peakDetails.mat'])
            
            sample_peaks_mzvalues = peakDetails(:,2);
            
        end
        
        % Total spectrum information and pixel numbers
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_intensities.mat'])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\totalSpectrum_mzvalues.mat'])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\pixels_num.mat'])
        
        % Total spectrum indexes for all picked peaks
        
        % (when it was realised that the 6th element of peakDetails is not
        % the index of the centre of mass of the peak 4 Sept 2019)
        
        if file_index == 1
            
            peak_mz_indexes = [];
            for mzi = 1:size(peakDetails,1)
                [~, index] = min(abs(totalSpectrum_mzvalues-peakDetails(mzi,2)));
                peak_mz_indexes(mzi) = index;
            end
            
        end
        
        % Total spectrum intensities for all picked peaks
        
        % This is done imzml file by imzml file because the ultimate goal is to compute
        % the mean spectrum (using the pixels_num variable also saved file by file.
        % This was originally incorrect! 6 Nov 2019
        
        sample_peaks_intensities = totalSpectrum_intensities(peak_mz_indexes);
        
        %
        
        if file_index == 1
            
            %%% Loading information from hmdb database
            
            [~, indexes ] = unique(complete_hmdb_info_strings(:,3));
            molecules_hmdb_info_strings = complete_hmdb_info_strings(indexes,3:end);
            
            hmdb_names = molecules_hmdb_info_strings(:,1);
            hmdb_mzvalues = double(molecules_hmdb_info_strings(:,3));
            hmdb_other = molecules_hmdb_info_strings(:,[ 2 4:8 ]);
            
            %%% Matching
            
            tic
            
            [ adductMasses ] = f_makeAdductMassList( adducts, hmdb_mzvalues, polarity ); % creates matrix of possible adduct masses
            
            hmdb_sample_info = string([]);
            g_index = 0;
            i_vector = [];
            
            for i = 1:length(sample_peaks_mzvalues)
                
                ppmError = abs(((adductMasses - sample_peaks_mzvalues(i))./ sample_peaks_mzvalues(i)) * 1000000); % checks each peak against possible adduct list
                real_ppmError = (((adductMasses - sample_peaks_mzvalues(i))./ sample_peaks_mzvalues(i)) * 1000000); % checks each peak against possible adduct list
                [matchesR, matchesC] = find(ppmError < ppmTolerance); % finds those within ppm error
                
                if ~isempty(matchesR)
                    
                    for j = 1:sum(sum(ppmError < ppmTolerance)) % adds the relevant matched peaks to the database
                        
                        g_index = g_index + 1;
                        
                        hmdb_sample_info(g_index,1) = hmdb_names(matchesR(j));
                        hmdb_sample_info(g_index,2) = num2str(adductMasses(matchesR(j), matchesC(j)),10);
                        
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
                        hmdb_sample_info(g_index,7)     = 'hmdb';
                        
                        hmdb_sample_info(g_index,8)     = real_ppmError(matchesR(j), matchesC(j));
                        hmdb_sample_info(g_index,9)     = modality;
                        hmdb_sample_info(g_index,10)    = polarity;
                        
                        hmdb_sample_info(g_index,12)    = molecules_hmdb_info_strings(matchesR(j),3); % monoisotopic mass
                        
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
                        
                        i_vector(g_index,1) = i;
                        
                    end
                end
            end
            
            t = toc; disp(['Peak matching time elapsed: ' num2str(t)])
            
        end
        
        hmdb_sample_info(:,6)     = sample_peaks_intensities(i_vector);
        hmdb_sample_info(:,11)    = sample_peaks_intensities(i_vector)./pixels_num;
        
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



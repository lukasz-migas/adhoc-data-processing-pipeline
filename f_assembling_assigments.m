function f_assembling_assigments( filesToProcess, group_name, main_mask_1, main_mask_2 )
%can you see this?
for file_index = 1:size(filesToProcess,1)
    
    csv_inputs = [ filesToProcess(file_index).folder filesep 'inputs_file' ];
    
    [ ~, ~, ~, ...
        ~, ~, ...
        ~, ~, ...
        ~, ~, ~, ...
        ~, ~, ~, ...
        ~, ...
        outputs_path ] = f_reading_inputs(csv_inputs);
    
    spectra_details_path    = [ char(outputs_path) filesep 'spectra details' filesep];
    peak_assignments_path   = [ char(outputs_path) filesep 'peak assignments' filesep ];
    rois_path               = [ char(outputs_path) filesep 'rois' filesep ];
    
    % Mask 1 (e.g.: tissue only)
    
    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask_1) filesep 'totalSpectrum_intensities.mat'])
    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask_1) filesep 'pixels_num.mat'])
    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask_1) filesep 'totalSpectrum_mzvalues.mat'])
    
    meanSpectrum_intensities_1 = totalSpectrum_intensities./pixels_num;
    
    clear totalSpectrum_intensities pixels_num 

    % Mask 2 (e.g.: background)
    
    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask_2) filesep 'totalSpectrum_intensities.mat'])
    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask_1) filesep 'pixels_num.mat'])
    
    meanSpectrum_intensities_2 = totalSpectrum_intensities./pixels_num;
    
    mz_min_bin = min(diff(totalSpectrum_mzvalues));
    
    load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) filesep char(main_mask_1) filesep 'hmdb_sample_info' ])
    load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) filesep char(main_mask_1) filesep 'relevant_lists_sample_info' ])
    
    sample_info = [ hmdb_sample_info; [ relevant_lists_sample_info, repmat("NA",size(relevant_lists_sample_info,1),size(hmdb_sample_info,2)-size(relevant_lists_sample_info,2)) ] ];
    
    assignments_and_ratio_sample_info = [];
    
    for mz = unique(double(sample_info(:,4)))'
        
        mini_sample_info = sample_info(abs(double(sample_info(:,4))-mz)<mz_min_bin,:);
        
        [ ~, meanSpectrum_mzvalues_index ] = min(abs(totalSpectrum_mzvalues-mz));
        
        new_c1 = meanSpectrum_intensities_1(meanSpectrum_mzvalues_index);
        new_c2 = meanSpectrum_intensities_2(meanSpectrum_mzvalues_index);
        if (new_c1 == 0) && (new_c2 == 0)
            new_c3 = 0;
        else
            new_c3 = new_c1./new_c2;
        end
        
        mini_sample_info = [ mini_sample_info, repmat([ string(new_c1), string(new_c2), string(new_c3) ], size(mini_sample_info,1),1) ];
        
        assignments_and_ratio_sample_info = [ assignments_and_ratio_sample_info; mini_sample_info ];
                
    end
    
    cd([peak_assignments_path filesToProcess(1).name(1,1:end-6) filesep char(main_mask_1)])
    save('assignments_and_ratio_sample_info','assignments_and_ratio_sample_info','-v7.3')
    
    table = [
        "molecule" "theo mz" "adduct" "meas mz" "abs ppm" "total counts" "database" "ppm" "modality" "polarity" "mean counts" "monoisotopic mass" "hmdb id",...
        "kingdom" "super class" "class" "subclass" "mean counts tissue" "mean counts background" "ration tissue background"
        assignments_and_ratio_sample_info
        ];
    
    txt_row = strcat(repmat('%s\t',1,size(table,2)-1),'%s\n');
    
    fileID = fopen('assignments_and_ratio.txt','w');
    fprintf(fileID,txt_row, table');
    fclose(fileID);
    
    if file_index==1
    
        global_sample_info = [
            "meas mz", "ppm", "molecule name", "mono mz", "adduct", "theo mz", "database", "kingdom", "super class", "class", "sub class", ...
            join(["mean counts tissue - " filesToProcess(1).name(1,1:end-6)]),...
            join(["mean counts background - " filesToProcess(1).name(1,1:end-6)]),...
            join(["mean counts ratio - " filesToProcess(1).name(1,1:end-6)])...
            ];
        
        global_sample_info = [
            global_sample_info
            assignments_and_ratio_sample_info(:,[ 4 8 1 12, 3, 2, 7, 14:20 ])
            ];
        
    else
                
        global_sample_info = [ 
            global_sample_info, ...
            [[ ...
            join(["mean counts tissue - " filesToProcess(file_index).name(1,1:end-6)]),...
            join(["mean counts background - " filesToProcess(file_index).name(1,1:end-6)]),...
            join(["mean counts ratio - " filesToProcess(file_index).name(1,1:end-6)])...
            ];
            assignments_and_ratio_sample_info(:, 18:20)
            ]
            ];
        
    end
                    
end

assignments_and_ratio_all_files = global_sample_info(:,[ 1:2 12:end 3:11]); % reordering the columns

[ ~, peaks_indexes ] = unique(global_sample_info(2:end,1)); 

peaks_and_ratio_all_files = [
    global_sample_info(1,[ 1 12:end ])  
    global_sample_info(peaks_indexes+1,[ 1 12:end ])
    ];

mkdir([peak_assignments_path filesep char(group_name) ])
cd([peak_assignments_path filesep char(group_name) ])

save('assignments_and_ratio_all_files','assignments_and_ratio_all_files','-v7.3')
save('peaks_and_ratio_all_files','peaks_and_ratio_all_files','-v7.3')

txt_row = strcat(repmat('%s\t',1,size(assignments_and_ratio_all_files,2)-1),'%s\n');

fileID = fopen('assignments_and_ratio_all_files.txt','w');
fprintf(fileID,txt_row, assignments_and_ratio_all_files');
fclose(fileID);

txt_row = strcat(repmat('%s\t',1,size(peaks_and_ratio_all_files,2)-1),'%s\n');

fileID = fopen('peaks_and_ratio_all_files.txt','w');
fprintf(fileID,txt_row, peaks_and_ratio_all_files');
fclose(fileID);
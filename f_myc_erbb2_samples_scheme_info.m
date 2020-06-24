function [ extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs ] = f_myc_erbb2_samples_scheme_info( dataset_name, background, check_datacubes_size )

switch dataset_name
    
    case "negative DESI"
        
        main_mask_list = "tissue only";
        
        % Datasets
        
        data_folders = { 'X:\Crick\myc_erbb2_replicates\imzml\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        clear extensive_filesToProcess
        
        extensive_filesToProcess(1:32,:) = filesToProcess(1:32,:);
        smaller_masks_list = [
            "erbb2-a1-r1"; "erbb2-a2-r1"; "erbb2-a3-r1"; "erbb2-a4-r1";
            "myc-a1-r1"; "myc-a2-r1"; "myc-a3-r1"; "myc-a4-r1";
            "erbb2-a1-r2"; "erbb2-a2-r2"; "erbb2-a3-r2"; "erbb2-a4-r2";
            "myc-a1-r2"; "myc-a2-r2"; "myc-a3-r2"; "myc-a4-r2";
            "erbb2-a1-r3"; "erbb2-a2-r3"; "erbb2-a3-r3"; "erbb2-a4-r3";
            "myc-a1-r3"; "myc-a2-r3"; "myc-a3-r3"; "myc-a4-r3";
            "myc-a1-r4"; "myc-a2-r4"; "myc-a3-r4"; "myc-a4-r4";
            "erbb2-a1-r4"; "erbb2-a2-r4"; "erbb2-a3-r4"; "erbb2-a4-r4";
            ];
        
        outputs_xy_pairs = [
            1 5; 2 5; 3 5; 4 5;
            1 1; 2 1; 3 1; 4 1;
            1 6; 2 6; 3 6; 4 6;
            1 2; 2 2; 3 2; 4 2;
            1 7; 2 7; 3 7; 4 7;
            1 3; 2 3; 3 3; 4 3;
            1 4; 2 4; 3 4; 4 4;
            1 8; 2 8; 3 8; 4 8;
            ];
        
end

filesToProcess = f_unique_extensive_filesToProcess(extensive_filesToProcess); % This function collects all files that need to have a common axis.

if check_datacubes_size==1
    
    for file_index = 1:length(filesToProcess)
        
        disp(filesToProcess(file_index).name(1,1:end-6))
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask_list) '\datacubeonly_peakDetails' ])
        
        if file_index==1
            
            old_datacubeonly_peakDetails = datacubeonly_peakDetails;
            
        elseif ~isequal(old_datacubeonly_peakDetails, datacubeonly_peakDetails)
            
            disp('!!! ISSUE !!! Datasets do NOT have a compatible mz axis. Please check and make sure that all datasets to be combined have a commom list of peaks and matches.')
            
        end
        
    end
    
end
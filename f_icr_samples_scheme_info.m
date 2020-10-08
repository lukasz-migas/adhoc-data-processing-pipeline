function [ extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs ] = f_icr_samples_scheme_info( dataset_name, background, check_datacubes_size )

switch dataset_name
    
    case "neg desi 3d pdx pilot"
        
        data_folders = { 'X:\ICR Breast PDX\Data\neg DESI\' };
        
        dataset_name = '*pdx_br*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess = filesToProcess(3:end,:);
            smaller_masks_list = [
                "t-1458-2";
                "t-1282-4";
                "t-1282-5";
                "t-1458-4";
                "t-1458-3";
                "t-1282-3";
                "t-1458-5";
                "t-1282-2"
                ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 1 3; 1 4; 2 3; 2 2; 1 2; 2 4; 1 1
            ];
    
    case "icl neg desi 1458 and 1282 pdx & primary"
        
        data_folders = { 'X:\ICR Breast PDX\Data\ICL neg DESI\' };
        
        filesToProcess = [];
        for i = 1:length(data_folders)
            dataset_name = '*pdx*';
            filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ];
            dataset_name = '*bc_35*';
            filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ];
        end

        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:10,1) = filesToProcess(1:10,1);
            smaller_masks_list = [
                "t-1282-1";
                "t-1458-1";
                "t-1458-2";
                "t-1282-4";
                "t-1282-5";
                "t-1458-4";
                "t-1458-3";
                "t-1282-3";
                "t-1458-5";
                "t-1282-2";
                ];
            
            extensive_filesToProcess(11:14,1) = filesToProcess(11,1);
            smaller_masks_list = [
                smaller_masks_list;
                "pt-35-1-18";
                "pt-35-1-20";
                "pt-35-1-28";
                "pt-35-1-33";
                ];
            
            extensive_filesToProcess(15:19,1) = filesToProcess(12,1);
            smaller_masks_list = [
                smaller_masks_list;
                "pt-35-2-25";
                "pt-35-2-32";
                "pt-35-2-55";
                "pt-35-2-80";
                "pt-35-2-81";
                ];
            extensive_filesToProcess(20:23,1) = filesToProcess(13,1);
            smaller_masks_list = [
                smaller_masks_list;
                "pt-35-3-12";
                "pt-35-3-36";
                "pt-35-3-70";
                "pt-35-3-78";
                ];
            extensive_filesToProcess(24:34,1) = filesToProcess(14,1);
            smaller_masks_list = [
                smaller_masks_list;
                "pt-35-e-4";
                "pt-35-e-6";
                "pt-35-e-7";
                "pt-35-e-8";
                "pt-35-e-9";
                "pt-35-e-11";
                "pt-35-e-12";
                "pt-35-e-17";
                "pt-35-e-18";
                "pt-35-e-19";
                "pt-35-e-21";
                ];
                        
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2; 2 2; 4 1; 5 1; 4 2; 3 2; 3 1; 5 2; 2 1;
            1 3; 2 3; 3 3; 4 3;
            1 4; 2 4; 3 4; 4 4; 5 4;
            1 5; 2 5; 3 5; 4 5;
            1 6; 2 6; 3 6; 4 6; 
            1 7; 2 7; 3 7; 4 7;
            1 8; 2 8; 3 8; 
            ];
        
    case "icl neg desi 1458 and 1282 pdx only (s245 only)"
        
        data_folders = { 'X:\ICR Breast PDX\Data\ICL neg DESI\' };
        
        dataset_name = '*pdx*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess = filesToProcess([3:6 9:10],:);
            smaller_masks_list = [
                "t-1458-2";
                "t-1282-4";
                "t-1282-5";
                "t-1458-4";
                "t-1458-5";
                "t-1282-2"
                ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 1 2; 1 3; 2 2; 2 3; 1 1
            ];
        
        
    case "icl neg desi 1458 and 1282 pdx only (s2-5 only)"
        
        data_folders = { 'X:\ICR Breast PDX\Data\ICL neg DESI\' };
        
        dataset_name = '*pdx*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess = filesToProcess(3:end,:);
            smaller_masks_list = [
                "t-1458-2";
                "t-1282-4";
                "t-1282-5";
                "t-1458-4";
                "t-1458-3";
                "t-1282-3";
                "t-1458-5";
                "t-1282-2"
                ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 1 3; 1 4; 2 3; 2 2; 1 2; 2 4; 1 1
            ];
        
    case "icl neg desi 1458 and 1282 pdx only"
        
        data_folders = { 'X:\ICR Breast PDX\Data\ICL neg DESI\' };
        
        dataset_name = '*pdx*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess = filesToProcess;
            smaller_masks_list = [
                "t-1282-1";
                "t-1458-1";
                "t-1458-2";
                "t-1282-4";
                "t-1282-5";
                "t-1458-4";
                "t-1458-3";
                "t-1282-3";
                "t-1458-5";
                "t-1282-2"
                ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 2 2; 1 4; 1 5; 2 4; 2 3; 1 3; 2 5; 1 2
            ];
        
    case "maldi pos cell pellets only"
        
        data_folders = { 'X:\ICR Breast PDX\Data\uMALDI\Neg\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1,:) = filesToProcess(3,:);
            smaller_masks_list = [ "tissue only" ];
            extensive_filesToProcess(2,:) = filesToProcess(7,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(3,:) = filesToProcess(15,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(4,:) = filesToProcess(11,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(5,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(6,:) = filesToProcess(5,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(7,:) = filesToProcess(13,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(8,:) = filesToProcess(9,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2; 1 3; 1 4;
            2 1; 2 2; 2 3; 2 4;
            ];
        
    case "maldi pos BR1282 PDX"
        
        data_folders = { 'X:\ICR Breast PDX\Data\uMALDI\Neg\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1,:) = filesToProcess(2,:);
            smaller_masks_list = [ "tissue only" ];
            extensive_filesToProcess(2,:) = filesToProcess(6,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(3,:) = filesToProcess(10,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(4,:) = filesToProcess(14,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2; 1 4; 1 3;
            
            ];
        
    case "maldi pos BR1458 PDX"
        
        data_folders = { 'X:\ICR Breast PDX\Data\uMALDI\Neg\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1,:) = filesToProcess(4,:);
            smaller_masks_list = [ "tissue only" ];
            extensive_filesToProcess(2,:) = filesToProcess(8,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(3,:) = filesToProcess(12,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(4,:) = filesToProcess(16,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2; 1 4; 1 3;
            
            ];
        
    case "maldi pos BR1458 BR1282 PDX and Cell Pellets"
        
        data_folders = { 'X:\ICR Breast PDX\Data\uMALDI\Neg\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1,:) = filesToProcess(1,:);
            smaller_masks_list = [ "tissue only" ];
            extensive_filesToProcess(2,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(3,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(4,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(5,:) = filesToProcess(5,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(6,:) = filesToProcess(6,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(7,:) = filesToProcess(7,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(8,:) = filesToProcess(8,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(9,:) = filesToProcess(9,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(10,:) = filesToProcess(10,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(11,:) = filesToProcess(11,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(12,:) = filesToProcess(12,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(13,:) = filesToProcess(13,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(14,:) = filesToProcess(14,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(15,:) = filesToProcess(15,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(16,:) = filesToProcess(16,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 4 1; 1 1; 3 1;
            2 2; 4 2; 1 2; 3 2;
            2 4; 4 4; 1 4; 3 4;
            2 3; 4 3; 1 3; 3 3;
            ];
        
    case "maldi pos BR1458 BR1282 pdx only"
        
        data_folders = { 'X:\ICR Breast PDX\Data\uMALDI\Pos\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue 2";
            
            %
            
            extensive_filesToProcess(1,:) = filesToProcess(4,:);
            smaller_masks_list = [ "BR1458 S1 PDX" ];
            
            extensive_filesToProcess(2,:) = filesToProcess(8,:);
            smaller_masks_list = [ smaller_masks_list; "BR1458 S2 PDX" ];
            
            extensive_filesToProcess(3,:) = filesToProcess(10,:);
            smaller_masks_list = [ smaller_masks_list; "BR1458 S3 PDX" ];
            
            extensive_filesToProcess(4,:) = filesToProcess(13,:);
            smaller_masks_list = [ smaller_masks_list; "BR1458 S4 PDX" ];
            
            extensive_filesToProcess(5,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "BR1282 S1 PDX" ];
            
            extensive_filesToProcess(6,:) = filesToProcess(7,:);
            smaller_masks_list = [ smaller_masks_list; "BR1282 S2 PDX" ];
            
            extensive_filesToProcess(7,:) = filesToProcess(9,:);
            smaller_masks_list = [ smaller_masks_list; "BR1282 S3 PDX" ];
            
            extensive_filesToProcess(8,:) = filesToProcess(11,:);
            smaller_masks_list = [ smaller_masks_list; "BR1282 S4 PDX" ];
            
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2; 1 3; 1 4;
            2 1; 2 2; 2 3; 2 4;
            ];
        
    case "maldi neg cell pellets only"
        
        data_folders = { 'X:\ICR Breast PDX\Data\uMALDI\Neg\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1,:) = filesToProcess(3,:);
            smaller_masks_list = [ "tissue only" ];
            extensive_filesToProcess(2,:) = filesToProcess(7,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(3,:) = filesToProcess(15,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(4,:) = filesToProcess(11,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(5,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(6,:) = filesToProcess(5,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(7,:) = filesToProcess(13,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(8,:) = filesToProcess(9,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2; 1 3; 1 4;
            2 1; 2 2; 2 3; 2 4;
            ];
        
    case "maldi neg 1282"
        
        data_folders = { 'X:\ICR Breast PDX\Data\uMALDI\Neg\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1,:) = filesToProcess(2,:);
            smaller_masks_list = [ "tissue only" ];
            extensive_filesToProcess(2,:) = filesToProcess(6,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(3,:) = filesToProcess(10,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(4,:) = filesToProcess(14,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2; 1 4; 1 3;
            
            ];
        
    case "maldi neg 1458"
        
        data_folders = { 'X:\ICR Breast PDX\Data\uMALDI\Neg\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1,:) = filesToProcess(4,:);
            smaller_masks_list = [ "tissue only" ];
            extensive_filesToProcess(2,:) = filesToProcess(8,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(3,:) = filesToProcess(12,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            extensive_filesToProcess(4,:) = filesToProcess(16,:);
            smaller_masks_list = [ smaller_masks_list; "tissue only" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2; 1 4; 1 3;
            
            ];
        
    case "maldi neg 1458 1282"
        
        data_folders = { 'X:\ICR Breast PDX\Data\uMALDI\Neg\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1,:) = filesToProcess(1,:);
            smaller_masks_list = [ "cell-pellet-1-1282" ];
            extensive_filesToProcess(2,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "pdx-1-1282" ];
            extensive_filesToProcess(3,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "cell-pellet-1-1458" ];
            extensive_filesToProcess(4,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "pdx-1-1458" ];
            extensive_filesToProcess(5,:) = filesToProcess(5,:);
            smaller_masks_list = [ smaller_masks_list; "cell-pellet-2-1282" ];
            extensive_filesToProcess(6,:) = filesToProcess(6,:);
            smaller_masks_list = [ smaller_masks_list; "pdx-2-1282" ];
            extensive_filesToProcess(7,:) = filesToProcess(7,:);
            smaller_masks_list = [ smaller_masks_list; "cell-pellet-2-1458" ];
            extensive_filesToProcess(8,:) = filesToProcess(8,:);
            smaller_masks_list = [ smaller_masks_list; "pdx-2-1458" ];
            extensive_filesToProcess(9,:) = filesToProcess(9,:);
            smaller_masks_list = [ smaller_masks_list; "cell-pellet-4-1282" ];
            extensive_filesToProcess(10,:) = filesToProcess(10,:);
            smaller_masks_list = [ smaller_masks_list; "pdx-4-1282" ];
            extensive_filesToProcess(11,:) = filesToProcess(11,:);
            smaller_masks_list = [ smaller_masks_list; "cell-pellet-4-1458" ];
            extensive_filesToProcess(12,:) = filesToProcess(12,:);
            smaller_masks_list = [ smaller_masks_list; "pdx-4-1458" ];
            extensive_filesToProcess(13,:) = filesToProcess(13,:);
            smaller_masks_list = [ smaller_masks_list; "cell-pellet-3-1282" ];
            extensive_filesToProcess(14,:) = filesToProcess(14,:);
            smaller_masks_list = [ smaller_masks_list; "pdx-3-1282" ];
            extensive_filesToProcess(15,:) = filesToProcess(15,:);
            smaller_masks_list = [ smaller_masks_list; "cell-pellet-3-1458" ];
            extensive_filesToProcess(16,:) = filesToProcess(16,:);
            smaller_masks_list = [ smaller_masks_list; "pdx-3-1458" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 4 1; 1 1; 3 1;
            2 2; 4 2; 1 2; 3 2;
            2 4; 4 4; 1 4; 3 4;
            2 3; 4 3; 1 3; 3 3;
            ];
        
    case "maldi neg 1458 1282 pdx only"
        
        data_folders = { 'X:\ICR Breast PDX\Data\uMALDI\Neg\' };
        
        dataset_name = '*pdx*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1,:) = filesToProcess(1,:);
            smaller_masks_list = [ "BR1282-1-pdx" ];
            extensive_filesToProcess(2,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "BR1458-1-pdx" ];
            extensive_filesToProcess(3,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "BR1282-2-pdx" ];
            extensive_filesToProcess(4,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "BR1458-2-pdx" ];
            extensive_filesToProcess(7,:) = filesToProcess(5,:);
            smaller_masks_list = [ smaller_masks_list; "BR1282-3-pdx" ];
            extensive_filesToProcess(8,:) = filesToProcess(6,:);
            smaller_masks_list = [ smaller_masks_list; "BR1458-3-pdx" ];
            extensive_filesToProcess(5,:) = filesToProcess(7,:);
            smaller_masks_list = [ smaller_masks_list; "BR1282-4-pdx" ];
            extensive_filesToProcess(6,:) = filesToProcess(8,:);
            smaller_masks_list = [ smaller_masks_list; "BR1458-4-pdx" ];
            
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 1 1; 2 2; 1 2;
            2 4; 1 4; 2 3; 1 3;
            ];
        
end
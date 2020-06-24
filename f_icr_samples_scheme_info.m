function [ extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs ] = f_icr_samples_scheme_info( dataset_name, background, check_datacubes_size )

switch dataset_name
    
    case "icl neg desi 1458 and 1282 pdx only"
        
        data_folders = { 'X:\ICR Breast PDX\Data\ICL neg DESI\' };
        
        dataset_name = '*';
        
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
                't-1282-1';
                't-1458-1';
                't-1458-2';
                't-1282-4';
                't-1282-5';
                't-1458-4';
                't-1458-3';
                't-1282-3';
                't-1458-5';
                't-1282-2'
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

                        
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 1 1; 2 2; 1 2;
            2 4; 1 4; 2 3; 1 3;
            ];
                
end
function [ extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs ] = f_beatson_samples_scheme_info( dataset_name, background, check_datacubes_size )

switch dataset_name
    
    case "positive AP MALDI tumour models"
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            % Intracolonic dataset
            
            data_folders = { 'X:\Beatson\Intracolonic tumour study\plasma-AP-MALDI MSI\2020_01_28 - intracolonic sicrit imaging\data\' };
            
            dataset_name = '*';
            
            filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
            
            delta = 0;
            smaller_masks_list = [];
            
            clear extensive_filesToProcess
            
            extensive_filesToProcess(1,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "IT-B-APC" ];
                                 
            extensive_filesToProcess(2,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "IT-C-APC" ];
            
            extensive_filesToProcess(3,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "IT-G-APC" ];
            
            extensive_filesToProcess(4,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "IT-A-APC-KRAS" ];
            
            extensive_filesToProcess(5,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "IT-D-APC-KRAS" ];
            
        end        
        
        outputs_xy_pairs = [1 1; 1 2; 1 3; 2 1; 2 2 ];
    
    case "negative DESI pre-tumour & tumour models"
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            % Intracolonic dataset
            
            data_folders = { 'X:\Beatson\Intracolonic tumour study\Neg DESI Data\Xevo V3 Sprayer\' };
            
            dataset_name = '*slide9*';
            
            filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
            
            delta = 0;
            
            clear extensive_filesToProcess
            
            extensive_filesToProcess(delta+(1:4),:) = filesToProcess(1,:);
            smaller_masks_list = [ "IT9-C-APC"; "IT9-G-APC"; "IT9-A-APC-KRAS"; "IT9-D-APC-KRAS" ];
            
            % Tumour
                        
            extensive_filesToProcess(delta+(5:8),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "IT9-C-APC-tumour"; "IT9-G-APC-tumour"; "IT9-A-APC-KRAS-tumour"; "IT9-D-APC-KRAS-tumour" ];
                        
            extensive_filesToProcess(delta+(9:12),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "IT9-C-APC-normal"; "IT9-G-APC-normal"; "IT9-A-APC-KRAS-normal"; "IT9-D-APC-KRAS-normal" ];

            % Small intestine datasets
            
            data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
            
            dataset_name = '*SA*';
            
            filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:3),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-1-KRAS"; "SA1-1-APC"; "SA1-1-APC-KRAS" ];
            extensive_filesToProcess(delta+(4:7),:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT"; "SA1-2-KRAS"; "SA1-2-APC"; "SA1-2-APC-KRAS" ];
            extensive_filesToProcess(delta+(8:9),:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-1-KRAS"; "SA2-1-APC-KRAS" ];
            extensive_filesToProcess(delta+(10:13),:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-2-WT"; "SA2-2-KRAS"; "SA2-2-APC"; "SA2-2-APC-KRAS" ];
            
            % Epitelium
            
            dataset_name = '*SA1-2*';
            
            filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:4),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT Epit"; "SA1-2-KRAS Epit"; "SA1-2-APC Epit"; "SA1-2-APC-KRAS Epit" ];
            extensive_filesToProcess(delta+(5:8),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT not Epit"; "SA1-2-KRAS not Epit"; "SA1-2-APC not Epit"; "SA1-2-APC-KRAS not Epit" ];
            
            % Colon datasets
            
            dataset_name = '*CB*';
            
            filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:4),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "CB1-1-WT"; "CB1-1-KRAS"; "CB1-1-APC"; "CB1-1-APC-KRAS" ];
            
            extensive_filesToProcess(delta+(5:7),:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "CB1-2-WT"; "CB1-2-APC"; "CB1-2-APC-KRAS" ];
            
            extensive_filesToProcess(delta+(8:11),:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-1-WT"; "CB2-1-KRAS"; "CB2-1-APC"; "CB2-1-APC-KRAS" ];
            
            extensive_filesToProcess(delta+(12:15),:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-2-WT"; "CB2-2-KRAS"; "CB2-2-APC"; "CB2-2-APC-KRAS" ];
            
            % Epitelium
            
            dataset_name = '*CB2-1*';
            
            filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:4),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-1-WT Epit"; "CB2-1-KRAS Epit"; "CB2-1-APC Epit"; "CB2-1-APC-KRAS Epit" ];
            
            extensive_filesToProcess(delta+(5:8),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-1-WT not Epit"; "CB2-1-KRAS not Epit"; "CB2-1-APC not Epit"; "CB2-1-APC-KRAS not Epit" ];
            
        end        
        
        outputs_xy_pairs = [];
        
    case "negative DESI small intestine SA 1-2 epit and not epit"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*SA1-2*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SA1-2-WT Epit"; "SA1-2-KRAS Epit"; "SA1-2-APC Epit"; "SA1-2-APC-KRAS Epit" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT not Epit"; "SA1-2-KRAS not Epit"; "SA1-2-APC not Epit"; "SA1-2-APC-KRAS not Epit" ];
            
        end
        
        
    case "negative DESI intracolonic tumours"
        
        data_folders = { 'X:\Beatson\Intracolonic tumour study\Neg DESI Data\Xevo V3 Sprayer\' };
        
        dataset_name = '*slide9*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            delta = 0;
            
            extensive_filesToProcess(delta+(1:4),:) = filesToProcess(1,:);
            smaller_masks_list = [
                "IT9-C-APC";
                "IT9-G-APC";
                "IT9-A-APC-KRAS";
                "IT9-D-APC-KRAS";
                ];
            
        end
        
        outputs_xy_pairs = [
            1 1;
            1 2;
            2 1;
            2 2;
            ];
        
    case "negative DESI small intestine 2019-06"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\Second Round Samples\Synapt\' };
        
        dataset_name = '*20190605*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            delta = 0;
            
            extensive_filesToProcess(delta+(1:8),:) = filesToProcess(1,:);
            smaller_masks_list = [
                "SI-B2-4-WT-1"; "SI-B2-4-KRAS-1"; "SI-B2-4-APC-1"; "SI-B2-4-APC-KRAS-1";
                "SI-B2-4-WT-2"; "SI-B2-4-APC-2"; "SI-B2-4-APC-KRAS-2";
                "SI-B2-4-WT-3";
                ];
            
        end
        
        %
        
        dataset_name = '*20190610*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:8),:) = filesToProcess(1,:);
            smaller_masks_list = [
                smaller_masks_list;
                "SI-B1-17-WT-1"; "SI-B1-17-KRAS-1"; "SI-B1-17-APC-1"; "SI-B1-17-APC-KRAS-1";
                "SI-B1-17-KRAS-2"; "SI-B1-17-APC-2"; "SI-B1-17-APC-KRAS-2";
                "SI-B1-17-KRAS-3";
                ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1; 1 2; 3 2; 4 2; 1 3; 1 4; 2 4; 3 4; 4 4; 2 2; 3 3; 4 3; 2 3;
            ];
        
    case "negative DESI SI B2 7 2019 09 04"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\Second Round Samples\Xevo\' };
        
        dataset_name = '*20190904*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SI-B2-7-WT-1"; "SI-B2-7-KRAS-1"; "SI-B2-7-APC-1"; "SI-B2-7-APC-KRAS-1" ];
            
            extensive_filesToProcess(5:7,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B2-7-WT-2"; "SI-B2-7-APC-2"; "SI-B2-7-APC-KRAS-2" ];
            
            extensive_filesToProcess(8,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B2-7-WT-3" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            1 2; 3 2; 4 2;
            1 3;
            ];
        
    case "negative DESI small intestine all ok"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*S*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:3,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SA1-1-KRAS"; "SA1-1-APC"; "SA1-1-APC-KRAS" ];
            extensive_filesToProcess(4:7,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT"; "SA1-2-KRAS"; "SA1-2-APC"; "SA1-2-APC-KRAS" ];
            extensive_filesToProcess(8:9,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-1-KRAS"; "SA2-1-APC-KRAS" ];
            extensive_filesToProcess(10:13,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-2-WT"; "SA2-2-KRAS"; "SA2-2-APC"; "SA2-2-APC-KRAS" ];
            
        end
        
        %
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\Second Round Samples\Synapt\' };
        
        dataset_name = '*20190605*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:8),:) = filesToProcess(1,:);
            smaller_masks_list = [
                smaller_masks_list;
                "SI-B2-4-WT-1"; "SI-B2-4-KRAS-1"; "SI-B2-4-APC-1"; "SI-B2-4-APC-KRAS-1";
                "SI-B2-4-WT-2"; "SI-B2-4-APC-2"; "SI-B2-4-APC-KRAS-2";
                "SI-B2-4-WT-3";
                ];
            
        end
        
        %
        
        dataset_name = '*20190610*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:8),:) = filesToProcess(1,:);
            smaller_masks_list = [
                smaller_masks_list;
                "SI-B1-17-WT-1"; "SI-B1-17-KRAS-1"; "SI-B1-17-APC-1"; "SI-B1-17-APC-KRAS-1";
                "SI-B1-17-KRAS-2"; "SI-B1-17-APC-2"; "SI-B1-17-APC-KRAS-2";
                "SI-B1-17-KRAS-3";
                ];
            
        end
        
        %
        
        dataset_name = '*2019_07_10*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:8),:) = filesToProcess(1,:);
            smaller_masks_list = [
                smaller_masks_list;
                "SI-B1-20-WT-1"; "SI-B1-20-KRAS-1"; "SI-B1-20-APC-1"; "SI-B1-20-APC-KRAS-1";
                "SI-B1-20-KRAS-2"; "SI-B1-20-APC-2"; "SI-B1-20-APC-KRAS-2";
                "SI-B1-20-KRAS-3"
                ];
            
        end
        
        %
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\Second Round Samples\Xevo\' };
        
        dataset_name = '*20190904*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:8),:) = filesToProcess(1,:);
            smaller_masks_list = [
                smaller_masks_list;
                "SI-B2-7-WT-1"; "SI-B2-7-KRAS-1"; "SI-B2-7-APC-1"; "SI-B2-7-APC-KRAS-1";
                "SI-B2-7-WT-2"; "SI-B2-7-APC-2"; "SI-B2-7-APC-KRAS-2";
                "SI-B2-7-WT-3"
                ];
            
        end
        
        %
        
        dataset_name = '*20190513*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:8),:) = filesToProcess(1,:);
            smaller_masks_list = [
                smaller_masks_list;
                "SI-B2-1-WT-1"; "SI-B2-1-KRAS-1"; "SI-B2-1-APC-1"; "SI-B2-1-APC-KRAS-1";
                "SI-B2-1-WT-2"; "SI-B2-1-APC-2"; "SI-B2-1-APC-KRAS-2";
                "SI-B2-1-WT-3"
                ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 3 1; 4 1; 1 3; 2 3; 3 3; 4 3; 2 2; 4 2; 1 4; 2 4; 3 4; 4 4;
            1 5; 2 5; 3 5; 4 5; 1 6; 3 6; 4 6; 1 7; 1 8; 2 8; 3 8; 4 8; 2 6; 3 7; 4 7; 2 7; 1 9; 2 9; 3 9; 4 9; 2 10; 3 10; 4 10; 2 11;
            1 12; 2 12; 3 12; 4 12; 1 13; 3 13; 4 13; 1 14; 1 15; 2 15; 3 15; 4 15; 1 16; 3 16; 4 16; 1 17;
            ];
        
        
        
    case "neg DESI intracolonic apc vs apc kras"
        
        data_folders = { 'X:\Beatson\Intracolonic tumour study\Neg DESI Data\Xevo V3 Sprayer\' };
        
        dataset_name = '*slide9*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "c_apc_addbackground"; "g_apc_addbackground"; "a_apckras_addbackground"; "d_apckras_addbackground" ];
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "c_apc"; "g_apc"; "a_apckras"; "d_apckras" ];
            
        end
        
        outputs_xy_pairs = [
            1 1; 1 2;
            2 1; 2 2;
            ];
        
    case "neg DESI intracolonic"
        
        data_folders = { 'X:\Beatson\Intracolonic tumour study\Neg DESI Data\Xevo V3 Sprayer\' };
        
        dataset_name = '*slide9*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [
                "intracolonic-tissue-3";  "intracolonic-tissue-4"; "intracolonic-tissue-5";  "intracolonic-tissue-6";
                "intracolonic-tissue-1"; "intracolonic-tissue-2"; "intracolonic-tissue-7" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2; 1 3; 1 4;
            2 1; 2 2; 2 3;
            ];
        
    case "neg DESI intracolonic A G C D"
        
        data_folders = { 'X:\Beatson\Intracolonic tumour study\Neg DESI Data\Xevo V3 Sprayer\' };
        
        dataset_name = '*slide9*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [  "intracolonic-tissue-3"; "intracolonic-tissue-5"; "intracolonic-tissue-2"; "intracolonic-tissue-7" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2;
            2 1; 2 2;
            ];
        
    case "neg plasma-AP-MALDI 50um intracolonic"
        
        data_folders = { 'X:\Beatson\Intracolonic tumour study\plasma-AP-MALDI MSI\2019_08_30_intracolonic\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:3,:) = filesToProcess(1,:);
            smaller_masks_list = [ "tissue only 1"; "tissue only 2"; "tissue only 3" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2; 1 3
            ];
        
        
        
    case "negative DESI 2018 sm & 2019 ic (sa 1 2 epit)"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*S*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:3,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SA1-1-KRAS"; "SA1-1-APC"; "SA1-1-APC-KRAS" ];
            
            extensive_filesToProcess(4:7,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT Epit"; "SA1-2-KRAS Epit"; "SA1-2-APC Epit"; "SA1-2-APC-KRAS Epit" ];
            extensive_filesToProcess(8:11,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT not Epit"; "SA1-2-KRAS not Epit"; "SA1-2-APC not Epit"; "SA1-2-APC-KRAS not Epit" ];
            
            extensive_filesToProcess(12:13,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-1-KRAS"; "SA2-1-APC-KRAS" ];
            
            extensive_filesToProcess(14:17,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-2-WT"; "SA2-2-KRAS"; "SA2-2-APC"; "SA2-2-APC-KRAS" ];
            
        end
        
        %
        
        data_folders = { 'X:\Beatson\Intracolonic tumour study\Neg DESI Data\Xevo V3 Sprayer\' };
        
        dataset_name = '*slide9*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:7),:) = filesToProcess(1,:);
            smaller_masks_list = [
                smaller_masks_list;
                "intracolonic-tissue-1";
                "intracolonic-tissue-2";
                "intracolonic-tissue-3";
                "intracolonic-tissue-4";
                "intracolonic-tissue-5";
                "intracolonic-tissue-6";
                "intracolonic-tissue-7"
                ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 3 1; 4 1;
            
            1 3; 2 3; 3 3; 4 3;
            1 4; 2 4; 3 4; 4 4;
            
            2 2; 4 2;
            
            1 5; 2 5; 3 5; 4 5;
            
            1 5; 2 5; 3 5; 4 5; 5 5; 6 5; 7 5;
            ];
        
    case "negative DESI 2018 sm & 2019 ic"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*S*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:3,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SA1-1-KRAS"; "SA1-1-APC"; "SA1-1-APC-KRAS" ];
            extensive_filesToProcess(4:7,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT"; "SA1-2-KRAS"; "SA1-2-APC"; "SA1-2-APC-KRAS" ];
            extensive_filesToProcess(8:9,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-1-KRAS"; "SA2-1-APC-KRAS" ];
            extensive_filesToProcess(10:13,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-2-WT"; "SA2-2-KRAS"; "SA2-2-APC"; "SA2-2-APC-KRAS" ];
            
        end
        
        %
        
        data_folders = { 'X:\Beatson\Intracolonic tumour study\Neg DESI Data\Xevo V3 Sprayer\' };
        
        dataset_name = '*slide9*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:7),:) = filesToProcess(1,:);
            smaller_masks_list = [
                smaller_masks_list;
                "intracolonic-tissue-1";
                "intracolonic-tissue-2";
                "intracolonic-tissue-3";
                "intracolonic-tissue-4";
                "intracolonic-tissue-5";
                "intracolonic-tissue-6";
                "intracolonic-tissue-7"
                ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 3 1; 4 1;
            1 3; 2 3; 3 3; 4 3;
            2 2; 4 2;
            1 4; 2 4; 3 4; 4 4;
            
            1 5; 2 5; 3 5; 4 5; 5 5; 6 5; 7 5;
            ];
        
    case "negative DESI SI 2018 03 & 2019 07"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*S*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:3,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SA1-1-KRAS"; "SA1-1-APC"; "SA1-1-APC-KRAS" ];
            extensive_filesToProcess(4:7,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT"; "SA1-2-KRAS"; "SA1-2-APC"; "SA1-2-APC-KRAS" ];
            extensive_filesToProcess(8:9,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-1-KRAS"; "SA2-1-APC-KRAS" ];
            extensive_filesToProcess(10:13,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-2-WT"; "SA2-2-KRAS"; "SA2-2-APC"; "SA2-2-APC-KRAS" ];
            
        end
        
        %
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\Second Round Samples\Synapt\' };
        
        dataset_name = '*2019_07*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-20-WT-1" ];
            
            extensive_filesToProcess(delta+(2:4),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-20-Kras-1";  "SI-B1-20-Kras-2";  "SI-B1-20-Kras-3" ];
            
            extensive_filesToProcess(delta+(5:6),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-20-APC-1"; "SI-B1-20-APC-2" ];
            
            extensive_filesToProcess(delta+(7:8),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-20-APC-KRAS-1"; "SI-B1-20-APC-KRAS-2" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 3 1; 4 1;
            1 3; 2 3; 3 3; 4 3;
            2 2; 4 2;
            1 4; 2 4; 3 4; 4 4;
            
            1 5;
            2 5; 2 6; 2 7;
            3 5; 3 6;
            4 5; 4 6;
            ];
        
    case "negative DESI 2018 03 & 2019 06 & 07"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*S*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:3,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SA1-1-KRAS"; "SA1-1-APC"; "SA1-1-APC-KRAS" ];
            extensive_filesToProcess(4:7,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT"; "SA1-2-KRAS"; "SA1-2-APC"; "SA1-2-APC-KRAS" ];
            extensive_filesToProcess(8:9,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-1-KRAS"; "SA2-1-APC-KRAS" ];
            extensive_filesToProcess(10:13,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-2-WT"; "SA2-2-KRAS"; "SA2-2-APC"; "SA2-2-APC-KRAS" ];
            
        end
        
        %
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\Second Round Samples\Synapt\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            delta = size(extensive_filesToProcess,1);
            
            extensive_filesToProcess(delta+(1:4),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B2-4-WT-1"; "SI-B2-4-KRAS-1"; "SI-B2-4-APC-1"; "SI-B2-4-APC-KRAS-1" ];
            
            extensive_filesToProcess(delta+(5:7),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B2-4-WT-2"; "SI-B2-4-APC-2"; "SI-B2-4-APC-KRAS-2" ];
            
            extensive_filesToProcess(delta+(8:11),:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-17-WT-1"; "SI-B1-17-KRAS-1"; "SI-B1-17-APC-1"; "SI-B1-17-APC-KRAS-1" ];
            
            extensive_filesToProcess(delta+(12:14),:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-17-KRAS-2"; "SI-B1-17-APC-2"; "SI-B1-17-APC-KRAS-2"; ];
            
            extensive_filesToProcess(delta+(15),:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B2-4-WT-3" ];
            
            extensive_filesToProcess(delta+(16),:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-17-KRAS-3" ];
            
            extensive_filesToProcess(delta+(17:20),:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-20-WT-1"; "SI-B1-20-KRAS-1"; "SI-B1-20-APC-1"; "SI-B1-20-APC-KRAS-1" ];
            
            extensive_filesToProcess(delta+(21:23),:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-20-KRAS-2"; "SI-B1-20-APC-2"; "SI-B1-20-APC-KRAS-2" ];
            
            extensive_filesToProcess(delta+(24),:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-20-KRAS-3" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 3 1; 4 1;
            1 3; 2 3; 3 3; 4 3;
            2 2; 4 2;
            1 4; 2 4; 3 4; 4 4;
            
            1 5; 2 5; 3 5; 4 5;
            1 6; 3 6; 4 6;
            1 7; 2 7; 3 7; 4 7;
            2 8; 3 8; 4 8;
            1 8;
            2 6;
            1 9; 2 9; 3 9; 4 9;
            2 10; 3 10; 4 10;
            2 11;
            ];
        
    case "negative DESI Synapt SLC7a5"
        
        data_folders = { 'X:\Beatson\SLC7a5 study\NPL data\negative DESI ibds and imzMLs\Synapt-old sprayer\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:3,:) = filesToProcess(1,:);
            smaller_masks_list = [ "V2C"; "V2B"; "V2I"; ];
            
            extensive_filesToProcess(4:6,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "R4J"; "R4G"; "R4H";  ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2; 1 3;
            2 1; 2 2; 2 3;
            ];
        
    case "ICL negative DESI SI - SA"
        
        data_folders = { 'X:\Beatson\data from ICL\2018_10_30_Beatson_(16-08-2018)_SA_neg_75umpixel_150um stage speed (slidelabel left)\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:7,:) = filesToProcess(1,:);
            smaller_masks_list = [ "WT-1"; "KRAS-1"; "KRAS-2";"APC-1";"APC-2";"APC-KRAS-1";"APC-KRAS-2" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1;
            2 1; 2 2
            3 1; 3 2;
            4 1; 4 2;
            ];
        
    case "negative DESI SI Second Batch Slides 4 and 17"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\Second Round Samples\Synapt\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:3,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SI-B1-4-WT-1"; "SI-B1-4-WT-2"; "SI-B1-4-WT-3" ];
            
            extensive_filesToProcess(4,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-17-WT-1"  ];
            
            extensive_filesToProcess(5,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-4-Kras-1" ];
            
            extensive_filesToProcess(6:8,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-17-Kras-1"; "SI-B1-17-Kras-2"; "SI-B1-17-Kras-3"; ];
            
            extensive_filesToProcess(9:10,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-4-APC-1"; "SI-B1-4-APC-2" ];
            
            extensive_filesToProcess(11:12,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-17-Apc-1"; "SI-B1-17-Apc-2" ];
            
            extensive_filesToProcess(13:14,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-4-ApcKras-1"; "SI-B1-4-ApcKras-2"];
            
            extensive_filesToProcess(15:16,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SI-B1-17-ApcKras-1"; "SI-B1-17-ApcKras-2"];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 1 2; 1 3; 1 4;
            2 1; 2 2; 2 3; 2 4;
            3 1; 3 2; 3 3; 3 4;
            4 1; 4 2; 4 3; 4 4;
            ];
        
    case "negative REIMS"
        
        data_folders = { 'X:\Beatson\negative REIMS ibds and imzMLs\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
            extensive_filesToProcess(1:47,:) = filesToProcess(1,:);
            
            smaller_masks_list = [
                
            "S-RZP10.1F-F-WT-WT"
            "S-RZP10.1B-M-WT-WT"
            "S-RZP10.1C-M-WT-WT"
            
            "S-RZF27.3E-F-HOM-WT"
            "S-RZF27.3F-F-HOM-WT"
            "S-RZF23.6C-F-HOM-WT"
            "S-RZF29.1G-M-HOM-WT"
            "S-RZF27.2A-M-HOM-WT"
            "S-RZF27.2B-M-HOM-WT"
            "S-RZF27.3C-M-HOM-WT"
            "S-RZF24.5A-M-HOM-WT"
            "S-RZF24.5C-M-HOM-WT"
            "S-RZF23.6A-M-HOM-WT"
            "S-RZF23.6B-M-HOM-WT"
            
            "S-RZP10.1D-F-WT-HET"
            "S-RZP10.1E-F-WT-HET"
            "S-RZP10.1A-M-WT-HET"
            "S-RZP10.2A-M-WT-HET"
            
            "S-RZF33.2E-F-HOM-HET"
            "S-RZF31.3D-F-HOM-HET"
            "S-RZF27.4E-F-HOM-HET"
            "S-RZF31.2D-M-HOM-HET"
            
            "S-RCC32.1C-M-HOM-WT-HOM"
            "S-RCC32.1D-M-HOM-WT-HOM"
            
            "S-RCC31.1A-F-HOM-HET-HOM"
            "S-RCC32.2A-F-HOM-HET-HOM"
            "S-RCC31.2D-F-HOM-HET-HOM"
            "S-RCC31.1B-F-HOM-HET-HOM"
            "S-RCC31.2B-M-HOM-HET-HOM"
            
            "C-RZF27.3E-F-HOM-WT"
            "C-RZF27.3F-F-HOM-WT"
            "C-RZF23.6C-F-HOM-WT"
            "C-RZF29.1G-M-HOM-WT"
            "C-RZF27.2A-M-HOM-WT"
            "C-RZF27.2B-M-HOM-WT"
            "C-RZF27.3C-M-HOM-WT"
            "C-RZF24.5A-M-HOM-WT"
            "C-RZF24.5C-M-HOM-WT"
            "C-RZF23.6A-M-HOM-WT"
            "C-RZF23.6B-M-HOM-WT"
            
            "C-RCC32.1C-M-HOM-WT-HOM"
            "C-RCC32.1D-M-HOM-WT-HOM"
            
            "C-RCC31.1A-F-HOM-HET-HOM"
            "C-RCC31.1B-F-HOM-HET-HOM"
            "C-RCC32.2A-F-HOM-HET-HOM"
            "C-RCC31.2D-F-HOM-HET-HOM"
            "C-RCC31.2B-M-HOM-HET-HOM"
            
            ];
        
        end
        
        %
        
        outputs_xy_pairs = [
            (1:3)'      ones(3,1)
            (8:18)'     ones(11,1)
            (23:26)'    ones(4,1);
            (31:34)'    ones(4,1);
            (39:40)'    ones(2,1);
            (45:49)'    ones(5,1);
            
            (8:18)'     repmat(2,11,1);
            (39:40)'    repmat(2,2,1);
            (45:49)'    repmat(2,5,1);
            ];
        
    case "13C Glutamine APC and APC-KRAS"
        
        data_folders = { 'X:\Beatson\SLC7a5 study\NPL data\negative DESI ibds and imzMLs\Xevo V3 Sprayer\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:8,:) = filesToProcess(1,:);
            smaller_masks_list = [ "WT_503a"; "WT_503c"; "WT_503e"; "WT_503f"; "MT_473c"; "MT_483c"; "MT_483d"; "MT_493d" ];
            
        end
        
        %
        
        outputs_xy_pairs = [ 1 1; 1 2; 1 3; 1 4; 2 1; 2 2; 2 3; 2 4 ];
        
    case "SLC7a5 negative DESI"
        
        data_folders = { 'X:\Beatson\SLC7a5 study\NPL data\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:6,:) = filesToProcess(1,:);
            smaller_masks_list = [ "WT-1"; "WT-2"; "WT-3"; "APC-KRAS-SLC7a5-1"; "APC-KRAS-SLC7a5-2"; "APC-KRAS-SLC7a5-3" ];
            
        end
        
        %
        
        outputs_xy_pairs = [ 1 1; 1 2; 1 3; 2 1; 2 2; 2 3 ];
        
    case "SLC7a5 positive DESI"
        
        data_folders = { 'X:\Beatson\SLC7a5 study\NPL data\positive DESI ibds and imzMLs\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:6,:) = filesToProcess(1,:);
            smaller_masks_list = [ "WT-1"; "WT-2"; "WT-3"; "APC-KRAS-SLC7a5-1"; "APC-KRAS-SLC7a5-2"; "APC-KRAS-SLC7a5-3" ];
            
        end
        
        %
        
        outputs_xy_pairs = [ 1 1; 1 2; 1 3; 2 1; 2 2; 2 3 ];
        
        
    case "negative DESI colon"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*C*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "CB1-1-WT"; "CB1-1-KRAS"; "CB1-1-APC"; "CB1-1-APC-KRAS" ];
            
            extensive_filesToProcess(5:7,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "CB1-2-WT"; "CB1-2-APC"; "CB1-2-APC-KRAS" ];
            
            extensive_filesToProcess(8:11,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-1-WT"; "CB2-1-KRAS"; "CB2-1-APC"; "CB2-1-APC-KRAS" ];
            
            extensive_filesToProcess(12:15,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-2-WT"; "CB2-2-KRAS"; "CB2-2-APC"; "CB2-2-APC-KRAS" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            1 3; 3 3; 4 3;
            1 2; 2 2; 3 2; 4 2;
            1 4; 2 4; 3 4; 4 4
            ];
        
    case "negative DESI colon epit musc"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*CB2-1*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "CB2-1-WT"; "CB2-1-KRAS"; "CB2-1-APC"; "CB2-1-APC-KRAS" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-1-WT Epit"; "CB2-1-KRAS Epit"; "CB2-1-APC Epit"; "CB2-1-APC-KRAS Epit" ];
            
            extensive_filesToProcess(9:12,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-1-WT Musc"; "CB2-1-KRAS Musc"; "CB2-1-APC Musc"; "CB2-1-APC-KRAS Musc" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            1 2; 2 2; 3 2; 4 2;
            1 3; 2 3; 3 3; 4 3;
            ];
        
    case "negative DESI colon epit only"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*CB2-1*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "CB2-1-WT Epit"; "CB2-1-KRAS Epit"; "CB2-1-APC Epit"; "CB2-1-APC-KRAS Epit" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            ];
        
    case "negative DESI small intestine epit musc"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*SA1-2*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SA1-2-WT"; "SA1-2-KRAS"; "SA1-2-APC"; "SA1-2-APC-KRAS" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT Epit"; "SA1-2-KRAS Epit"; "SA1-2-APC Epit"; "SA1-2-APC-KRAS Epit" ];
            
            extensive_filesToProcess(9:12,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT Musc"; "SA1-2-KRAS Musc"; "SA1-2-APC Musc"; "SA1-2-APC-KRAS Musc" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            1 2; 2 2; 3 2; 4 2;
            1 3; 2 3; 3 3; 4 3;
            ];
        
    case "negative DESI colon CB 2-1 epit and not epit"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*CB2-1*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "CB2-1-WT Epit"; "CB2-1-KRAS Epit"; "CB2-1-APC Epit"; "CB2-1-APC-KRAS Epit" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-1-WT not Epit"; "CB2-1-KRAS not Epit"; "CB2-1-APC not Epit"; "CB2-1-APC-KRAS not Epit" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            1 2; 2 2; 3 2; 4 2;
            ];
        
    case "negative DESI small intestine SA 1-2 epit and not epit"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*SA1-2*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SA1-2-WT Epit"; "SA1-2-KRAS Epit"; "SA1-2-APC Epit"; "SA1-2-APC-KRAS Epit" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT not Epit"; "SA1-2-KRAS not Epit"; "SA1-2-APC not Epit"; "SA1-2-APC-KRAS not Epit" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            1 2; 2 2; 3 2; 4 2;
            ];
        
    case "negative DESI small intestine epit only"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*SA1-2*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SA1-2-WT Epit"; "SA1-2-KRAS Epit"; "SA1-2-APC Epit"; "SA1-2-APC-KRAS Epit" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            ];
        
    case "negative DESI small intestine all"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*S*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:3,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SA1-1-KRAS"; "SA1-1-APC"; "SA1-1-APC-KRAS" ];
            extensive_filesToProcess(4:7,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT"; "SA1-2-KRAS"; "SA1-2-APC"; "SA1-2-APC-KRAS" ];
            extensive_filesToProcess(8:9,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-1-KRAS"; "SA2-1-APC-KRAS" ];
            extensive_filesToProcess(10:13,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-2-WT"; "SA2-2-KRAS"; "SA2-2-APC"; "SA2-2-APC-KRAS" ];
            extensive_filesToProcess(14:17,:) = filesToProcess(5,:);
            smaller_masks_list = [ smaller_masks_list; "SB-2-WT"; "SB-2-KRAS"; "SB-2-APC"; "SB-2-APC-KRAS" ];
            extensive_filesToProcess(18:21,:) = filesToProcess(6,:);
            smaller_masks_list = [ smaller_masks_list; "SB-1-WT"; "SB-1-KRAS"; "SB-1-APC"; "SB-1-APC-KRAS" ];
            extensive_filesToProcess(22:24,:) = filesToProcess(7,:);
            smaller_masks_list = [ smaller_masks_list; "SA-1-KRAS"; "SA-1-APC"; "SA-1-APC-KRAS" ];
            extensive_filesToProcess(25:28,:) = filesToProcess(8,:);
            smaller_masks_list = [ smaller_masks_list; "SA-2-WT"; "SA-2-KRAS"; "SA-2-APC"; "SA-2-APC-KRAS" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 3 1; 4 1;
            1 4; 2 4; 3 4; 4 4;
            2 2; 4 2;
            1 5; 2 5; 3 5; 4 5;
            1 8; 2 8; 3 8; 4 8;
            1 7; 2 7; 3 7; 4 7;
            2 3; 3 3; 4 3;
            1 6; 2 6; 3 6; 4 6
            ];
        
    case "negative DESI small intestine"
        
        data_folders = { 'X:\Beatson\pre-tumour models study\negative DESI ibds and imzMLs\' };
        
        dataset_name = '*S*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:3,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SA1-1-KRAS"; "SA1-1-APC"; "SA1-1-APC-KRAS" ];
            extensive_filesToProcess(4:7,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT"; "SA1-2-KRAS"; "SA1-2-APC"; "SA1-2-APC-KRAS" ];
            extensive_filesToProcess(8:9,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-1-KRAS"; "SA2-1-APC-KRAS" ];
            extensive_filesToProcess(10:13,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-2-WT"; "SA2-2-KRAS"; "SA2-2-APC"; "SA2-2-APC-KRAS" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            2 1; 3 1; 4 1;
            1 3; 2 3; 3 3; 4 3;
            2 2; 4 2;
            1 4; 2 4; 3 4; 4 4;
            ];
        
    case "negative MALDI colon"
        
        data_folders = { 'X:\Beatson\negative MALDI ibds and imzMLs\' };
        
        dataset_name = '*C*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "tissue only";
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "CB1-1-WT-BACKGROUND"; "CB1-1-KRAS-BACKGROUND"; "CB1-1-APC-BACKGROUND"; "CB1-1-APC-KRAS-BACKGROUND" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "CB1-2-WT-BACKGROUND"; "CB1-2-KRAS-BACKGROUND"; "CB1-2-APC-BACKGROUND"; "CB1-2-APC-KRAS-BACKGROUND" ];
            
            extensive_filesToProcess(9:12,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-1-WT-BACKGROUND"; "CB2-1-KRAS-BACKGROUND"; "CB2-1-APC-BACKGROUND"; "CB2-1-APC-KRAS-BACKGROUND" ];
            
            extensive_filesToProcess(13:16,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-2-WT-BACKGROUND"; "CB2-2-KRAS-BACKGROUND"; "CB2-2-APC-BACKGROUND"; "CB2-2-APC-KRAS-BACKGROUND" ];
            
        elseif background == 0
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "CB1-1-WT"; "CB1-1-KRAS"; "CB1-1-APC"; "CB1-1-APC-KRAS" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "CB1-2-WT"; "CB1-2-KRAS"; "CB1-2-APC"; "CB1-2-APC-KRAS" ];
            
            extensive_filesToProcess(9:12,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-1-WT"; "CB2-1-KRAS"; "CB2-1-APC"; "CB2-1-APC-KRAS" ];
            
            extensive_filesToProcess(13:16,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "CB2-2-WT"; "CB2-2-KRAS"; "CB2-2-APC"; "CB2-2-APC-KRAS" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            1 3; 2 3; 3 3; 4 3;
            1 2; 2 2; 3 2; 4 2;
            1 4; 2 4; 3 4; 4 4
            ];
        
    case "negative MALDI small intestine"
        
        data_folders = { 'X:\Beatson\negative MALDI ibds and imzMLs\' };
        
        dataset_name = '*S*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SB1-2-WT"; "SB1-2-KRAS"; "SB1-2-APC"; "SB1-2-APC-KRAS" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SB2-1-WT"; "SB2-1-KRAS"; "SB2-1-APC"; "SB2-1-APC-KRAS" ];
            
            extensive_filesToProcess(9:12,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SB2-2-WT"; "SB2-2-KRAS"; "SB2-2-APC"; "SB2-2-APC-KRAS" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 2; 2 2; 3 2; 4 2;
            1 1; 2 1; 3 1; 4 1;
            1 3; 2 3; 3 3; 4 3;
            ];
        
    case "positive DESI colon"
        
        data_folders = { 'X:\Beatson\positive DESI ibds and imzMLs\' };
        
        dataset_name = '*20180213*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "CA2-1-WT"; "CA2-1-KRAS"; "CA2-1-APC"; "CA2-1-APC-KRAS" ];
            
            extensive_filesToProcess(5:7,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "CA2-2-WT"; "CA2-2-APC"; "CA2-2-APC-KRAS" ];
            
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            1 2; 3 2; 4 2;
            ];
        
    case "positive DESI small intestine v1"
        
        data_folders = { 'X:\Beatson\positive DESI ibds and imzMLs\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ "SB1-1-WT"; "SB1-1-KRAS"; "SB1-1-APC"; "SB1-1-APC-KRAS" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(6,:);
            smaller_masks_list = [ smaller_masks_list; "SB2-1-WT"; "SB2-1-KRAS"; "SB2-1-APC"; "SB2-1-APC-KRAS" ];
            
            extensive_filesToProcess(9:12,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SB1-2-WT"; "SB1-2-KRAS"; "SB1-2-APC"; "SB1-2-APC-KRAS" ];
            
            extensive_filesToProcess(13:16,:) = filesToProcess(5,:);
            smaller_masks_list = [ smaller_masks_list; "SB2-2-WT"; "SB2-2-KRAS"; "SB2-2-APC"; "SB2-2-APC-KRAS" ];
            
            extensive_filesToProcess(17:19,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-1-WT"; "SA1-1-KRAS"; "SA1-1-APC" ];
            
            extensive_filesToProcess(20:23,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT"; "SA1-2-KRAS"; "SA1-2-APC"; "SA1-2-APC-KRAS" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            1 2; 2 2; 3 2; 4 2;
            1 3; 2 3; 3 3; 4 3;
            1 4; 2 4; 3 4; 4 4;
            1 5; 2 5; 3 5;
            1 6; 2 6; 3 6; 4 6;
            ];
        
    case "positive DESI small intestine v2"
        
        data_folders = { 'X:\Beatson\positive DESI ibds and imzMLs\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(2,:);
            smaller_masks_list = [ "SB1-2-WT"; "SB1-2-KRAS"; "SB1-2-APC"; "SB1-2-APC-KRAS" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(5,:);
            smaller_masks_list = [ smaller_masks_list; "SB2-2-WT"; "SB2-2-KRAS"; "SB2-2-APC"; "SB2-2-APC-KRAS" ];
            
            extensive_filesToProcess(9:12,:) = filesToProcess(6,:);
            smaller_masks_list = [ smaller_masks_list; "SB2-1-WT"; "SB2-1-KRAS"; "SB2-1-APC"; "SB2-1-APC-KRAS" ];
            
            extensive_filesToProcess(13:15,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-1-WT"; "SA1-1-KRAS"; "SA1-1-APC" ];
            
            extensive_filesToProcess(16:19,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT"; "SA1-2-KRAS"; "SA1-2-APC"; "SA1-2-APC-KRAS" ];
            
        end
        
    case "positive DESI small intestine"
        
        data_folders = { 'X:\Beatson\positive DESI ibds and imzMLs\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1:4,:) = filesToProcess(6,:);
            smaller_masks_list = [ "SB2-1-WT"; "SB2-1-KRAS"; "SB2-1-APC"; "SB2-1-APC-KRAS" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(5,:);
            smaller_masks_list = [ smaller_masks_list; "SB2-2-WT"; "SB2-2-KRAS"; "SB2-2-APC"; "SB2-2-APC-KRAS" ];
            
            extensive_filesToProcess(9:12 ,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT"; "SA1-2-KRAS"; "SA1-2-APC"; "SA1-2-APC-KRAS" ];
            
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            1 2; 2 2; 3 2; 4 2;
            1 3; 2 3; 3 3; 4 3;
            ];
        
    case "positive MALDI colon"
        
        data_folders = { 'X:\Beatson\positive MALDI ibds and imzMLs\' };
        
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
            smaller_masks_list = "CA1-1-WT";
            
            extensive_filesToProcess(2:4,:) = filesToProcess(5,:);
            smaller_masks_list = [ smaller_masks_list; "CA1-1-KRAS"; "CA1-1-APC"; "CA1-1-APC-KRAS" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(7,:);
            smaller_masks_list = [ smaller_masks_list; "CA2-1-WT"; "CA2-1-KRAS"; "CA2-1-APC"; "CA2-1-APC-KRAS" ];
            
            extensive_filesToProcess(9:11,:) = filesToProcess(6,:);
            smaller_masks_list = [ smaller_masks_list; "CA1-2-KRAS"; "CA1-2-APC"; "CA1-2-APC-KRAS" ];
            
            extensive_filesToProcess(12:15,:) = filesToProcess(8,:);
            smaller_masks_list = [ smaller_masks_list; "CA2-2-WT"; "CA2-2-KRAS"; "CA2-2-APC"; "CA2-2-APC-KRAS" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            1 2; 2 2; 3 2; 4 2;
            2 3; 3 3; 4 3;
            1 4; 2 4; 3 4; 4 4;
            ];
        
    case "positive MALDI small intestine"
        
        data_folders = { 'X:\Beatson\positive MALDI ibds and imzMLs\' };
        
        dataset_name = '*';
        
        filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
        
        if background == 1
            
            % with background
            
            main_mask_list = "no mask";
            
        else
            
            % tissue only
            
            main_mask_list = "tissue only";
            
            %
            
            extensive_filesToProcess(1,:) = filesToProcess(5,:);
            smaller_masks_list = "SA1-1-WT";
            
            extensive_filesToProcess(2:4,:) = filesToProcess(1,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-1-KRAS"; "SA1-1-APC"; "SA1-1-APC-KRAS" ];
            
            extensive_filesToProcess(5:8,:) = filesToProcess(3,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-1-WT"; "SA2-1-KRAS"; "SA2-1-APC"; "SA2-1-APC-KRAS" ];
            
            extensive_filesToProcess(9:11,:) = filesToProcess(2,:);
            smaller_masks_list = [ smaller_masks_list; "SA1-2-WT"; "SA1-2-KRAS"; "SA1-2-APC-KRAS" ];
            
            extensive_filesToProcess(12:15,:) = filesToProcess(4,:);
            smaller_masks_list = [ smaller_masks_list; "SA2-2-WT"; "SA2-2-KRAS"; "SA2-2-APC"; "SA2-2-APC-KRAS" ];
            
        end
        
        %
        
        outputs_xy_pairs = [
            1 1; 2 1; 3 1; 4 1;
            1 2; 2 2; 3 2; 4 2;
            1 3; 2 3; 4 3;
            1 4; 2 4; 3 4; 4 4;
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
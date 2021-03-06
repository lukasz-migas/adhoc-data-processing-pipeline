function [ extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs ] = f_pdac_samples_scheme_info( dataset_name, background, check_datacubes_size )

if strcmpi(dataset_name,'negative DESI all') || strcmpi(dataset_name,'negative DESI all bulk tissue') || strcmpi(dataset_name,'negative DESI all tumour')
    
    data_folders = { 'X:\PDAC Combo\negative DESI ibds and imzMLs\Individual\' };
    
    dataset_name = '*';
    
    filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end

    
    % * Positive & Negative * DESI data treated as 1 dataset
    
    extensive_filesToProcess((1:6)+0*6,:)   = filesToProcess(1,:);
    extensive_filesToProcess((1:6)+1*6,:)   = filesToProcess(2,:);
    extensive_filesToProcess((1:6)+2*6,:)   = filesToProcess(3,:);
    extensive_filesToProcess((1:6)+3*6,:)   = filesToProcess(4,:);
    extensive_filesToProcess((1:6)+4*6,:)   = filesToProcess(5,:);
    extensive_filesToProcess((1:5)+5*6,:)   = filesToProcess(6,:);
    extensive_filesToProcess((1:6)+6*6-1,:) = filesToProcess(7,:);
    extensive_filesToProcess((1:6)+7*6-1,:) = filesToProcess(8,:);
    
    if background == 1 % with background
        
        main_mask_list = "no mask";
        
        smaller_masks_list = [ "A1_BG"; "B1_BG"; "C1_BG"; "D1_BG"; "E1_BG"; "F1_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A2_BG"; "B2_BG"; "C2_BG"; "D2_BG"; "E2_BG"; "F2_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A3_BG"; "B3_BG"; "C3_BG"; "D3_BG"; "E3_BG"; "F3_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A4_BG"; "B4_BG"; "C4_BG"; "D4_BG"; "E4_BG"; "F4_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A1r_BG"; "B1r_BG"; "C1r_BG"; "D1r_BG"; "E1r_BG"; "F1r_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A2r_BG"; "C2r_BG"; "D2r_BG"; "E2r_BG"; "F2r_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A3r_BG"; "B3r_BG"; "C3r_BG"; "D3r_BG"; "E3r_BG"; "F3r_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A4r_BG"; "B4r_BG"; "C4r_BG"; "D4r_BG"; "E4r_BG"; "F4r_BG" ];
        
    else
        
        main_mask_list = "tissue only";
        
        if strcmpi(dataset_name,"negative DESI all bulk tissue"); main_mask_list = "bulk tissue"; end
        
        smaller_masks_list = [ "A1"; "B1"; "C1"; "D1"; "E1"; "F1" ];
        smaller_masks_list = [ smaller_masks_list; "A2"; "B2"; "C2"; "D2"; "E2"; "F2" ];
        smaller_masks_list = [ smaller_masks_list; "A3"; "B3"; "C3"; "D3"; "E3"; "F3" ];
        smaller_masks_list = [ smaller_masks_list; "A4"; "B4"; "C4"; "D4"; "E4"; "F4" ];
        smaller_masks_list = [ smaller_masks_list; "A1r"; "B1r"; "C1r"; "D1r"; "E1r"; "F1r" ];
        smaller_masks_list = [ smaller_masks_list; "A2r"; "C2r"; "D2r"; "E2r"; "F2r" ];
        smaller_masks_list = [ smaller_masks_list; "A3r"; "B3r"; "C3r"; "D3r"; "E3r"; "F3r" ];
        smaller_masks_list = [ smaller_masks_list; "A4r"; "B4r"; "C4r"; "D4r"; "E4r"; "F4r" ];
        
        if strcmpi(dataset_name,"negative DESI all tumour")
            
            smaller_masks_list = [ "A1 tumour"; "B1 tumour"; "C1 tumour"; "D1 tumour"; "E1 tumour"; "F1 tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A2 tumour"; "B2 tumour"; "C2 tumour"; "D2 tumour"; "E2 tumour"; "F2 tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A3 tumour"; "B3 tumour"; "C3 tumour"; "D3 tumour"; "E3 tumour"; "F3 tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A4 tumour"; "B4 tumour"; "C4 tumour"; "D4 tumour"; "E4 tumour"; "F4 tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A1r tumour"; "B1r tumour"; "C1r tumour"; "D1r tumour"; "E1r tumour"; "F1r tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A2r tumour"; "C2r tumour"; "D2r tumour"; "E2r tumour"; "F2r tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A3r tumour"; "B3r tumour"; "C3r tumour"; "D3r tumour"; "E3r tumour"; "F3r tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A4r tumour"; "B4r tumour"; "C4r tumour"; "D4r tumour"; "E4r tumour"; "F4r tumour" ];
            
        end
        
    end
    
    %
    
    outputs_xy_pairs = [
        1 1; 2 1; 3 1; 4 1; 5 1; 6 1;
        1 3; 2 3; 3 3; 4 3; 5 3; 6 3;
        1 5; 2 5; 3 5; 4 5; 5 5; 6 5;
        1 7; 2 7; 3 7; 4 7; 5 7; 6 7;
        1 2; 2 2; 3 2; 4 2; 5 2; 6 2;
        1 4; 3 4; 4 4; 5 4; 6 4;
        1 6; 2 6; 3 6; 4 6; 5 6; 6 6;
        1 8; 2 8; 3 8; 4 8; 5 8; 6 8;
        ];
    
elseif strcmpi(dataset_name,'positive DESI all') || strcmpi(dataset_name,'positive DESI all bulk tissue') || strcmpi(dataset_name,'positive DESI all tumour')
    
    data_folders = { 'X:\PDAC Combo\positive DESI ibds and imzMLs\Individual\' };
    
    dataset_name = '*';
    
    filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end

    
    % * Positive & Negative * DESI data treated as 1 dataset
    
    extensive_filesToProcess((1:6)+0*6,:)   = filesToProcess(1,:);
    extensive_filesToProcess((1:6)+1*6,:)   = filesToProcess(2,:);
    extensive_filesToProcess((1:6)+2*6,:)   = filesToProcess(3,:);
    extensive_filesToProcess((1:6)+3*6,:)   = filesToProcess(4,:);
    extensive_filesToProcess((1:6)+4*6,:)   = filesToProcess(5,:);
    extensive_filesToProcess((1:5)+5*6,:)   = filesToProcess(6,:);
    extensive_filesToProcess((1:6)+6*6-1,:) = filesToProcess(7,:);
    extensive_filesToProcess((1:6)+7*6-1,:) = filesToProcess(8,:);
    
    if background == 1 % with background
        
        main_mask_list = "no mask";
        
        smaller_masks_list = [ "A1_BG"; "B1_BG"; "C1_BG"; "D1_BG"; "E1_BG"; "F1_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A2_BG"; "B2_BG"; "C2_BG"; "D2_BG"; "E2_BG"; "F2_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A3_BG"; "B3_BG"; "C3_BG"; "D3_BG"; "E3_BG"; "F3_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A4_BG"; "B4_BG"; "C4_BG"; "D4_BG"; "E4_BG"; "F4_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A1r_BG"; "B1r_BG"; "C1r_BG"; "D1r_BG"; "E1r_BG"; "F1r_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A2r_BG"; "C2r_BG"; "D2r_BG"; "E2r_BG"; "F2r_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A3r_BG"; "B3r_BG"; "C3r_BG"; "D3r_BG"; "E3r_BG"; "F3r_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A4r_BG"; "B4r_BG"; "C4r_BG"; "D4r_BG"; "E4r_BG"; "F4r_BG" ];
        
    else
        
        main_mask_list = "tissue only";
        
        if strcmpi(dataset_name,"positive DESI all bulk tissue"); main_mask_list = "bulk tissue"; end
        
        smaller_masks_list = [ "A1"; "B1"; "C1"; "D1"; "E1"; "F1" ];
        smaller_masks_list = [ smaller_masks_list; "A2"; "B2"; "C2"; "D2"; "E2"; "F2" ];
        smaller_masks_list = [ smaller_masks_list; "A3"; "B3"; "C3"; "D3"; "E3"; "F3" ];
        smaller_masks_list = [ smaller_masks_list; "A4"; "B4"; "C4"; "D4"; "E4"; "F4" ];
        smaller_masks_list = [ smaller_masks_list; "A1r"; "B1r"; "C1r"; "D1r"; "E1r"; "F1r" ];
        smaller_masks_list = [ smaller_masks_list; "A2r"; "C2r"; "D2r"; "E2r"; "F2r" ];
        smaller_masks_list = [ smaller_masks_list; "A3r"; "B3r"; "C3r"; "D3r"; "E3r"; "F3r" ];
        smaller_masks_list = [ smaller_masks_list; "A4r"; "B4r"; "C4r"; "D4r"; "E4r"; "F4r" ];
        
        if strcmpi(dataset_name,"positive DESI all tumour")
            
            smaller_masks_list = [ "A1 tumour"; "B1 tumour"; "C1 tumour"; "D1 tumour"; "E1 tumour"; "F1 tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A2 tumour"; "B2 tumour"; "C2 tumour"; "D2 tumour"; "E2 tumour"; "F2 tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A3 tumour"; "B3 tumour"; "C3 tumour"; "D3 tumour"; "E3 tumour"; "F3 tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A4 tumour"; "B4 tumour"; "C4 tumour"; "D4 tumour"; "E4 tumour"; "F4 tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A1r tumour"; "B1r tumour"; "C1r tumour"; "D1r tumour"; "E1r tumour"; "F1r tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A2r tumour"; "C2r tumour"; "D2r tumour"; "E2r tumour"; "F2r tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A3r tumour"; "B3r tumour"; "C3r tumour"; "D3r tumour"; "E3r tumour"; "F3r tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A4r tumour"; "B4r tumour"; "C4r tumour"; "D4r tumour"; "E4r tumour"; "F4r tumour" ];
            
        end
        
    end
    
    %
    
    outputs_xy_pairs = [
        1 1; 2 1; 3 1; 4 1; 5 1; 6 1;
        1 3; 2 3; 3 3; 4 3; 5 3; 6 3;
        1 5; 2 5; 3 5; 4 5; 5 5; 6 5;
        1 7; 2 7; 3 7; 4 7; 5 7; 6 7;
        1 2; 2 2; 3 2; 4 2; 5 2; 6 2;
        1 4; 3 4; 4 4; 5 4; 6 4;
        1 6; 2 6; 3 6; 4 6; 5 6; 6 6;
        1 8; 2 8; 3 8; 4 8; 5 8; 6 8;
        ];
    
elseif strcmpi(dataset_name,'positive MALDI')
    
    % * Positive & Negative * MALDI data treated as 1 dataset
    
    data_folders = { 'X:\PDAC Combo\positive MALDI ibds and imzMLs\Individual\' };
    
    dataset_name = '*';
    
    filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
    
    extensive_filesToProcess(1:48,:)  = filesToProcess([ 11 11 13 15 16 18 1 3 5 6 7 9 10 12 14 19 17 19 2 4 2 2 8 2 20:2:42 21:2:43 ],:);
    
    
    if background == 1 % with background
        
        main_mask_list = "no mask";
        
        smaller_masks_list = [ "A1_BG"; "B1_BG"; "C1_BG"; "D1_BG"; "E1_BG"; "F1_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A2_BG"; "B2_BG"; "C2_BG"; "D2_BG"; "E2_BG"; "F2_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A3_BG"; "B3_BG"; "C3_BG"; "D3_BG"; "E3_BG"; "F3_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A4_BG"; "B4_BG"; "C4_BG"; "D4_BG"; "E4_BG"; "F4_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A1r_BG"; "B1r_BG"; "C1r_BG"; "D1r_BG"; "E1r_BG"; "F1r_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A2r_BG"; "C2r_BG"; "D2r_BG"; "E2r_BG"; "F2r_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A3r_BG"; "B3r_BG"; "C3r_BG"; "D3r_BG"; "E3r_BG"; "F3r_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A4r_BG"; "B4r_BG"; "C4r_BG"; "D4r_BG"; "E4r_BG"; "F4r_BG" ];
        
    else
        
        main_mask_list = "tissue only";
        
        smaller_masks_list = [ "A1"; "B1"; "C1"; "D1"; "E1"; "F1" ];
        smaller_masks_list = [ smaller_masks_list; "A1r"; "B1r"; "C1r"; "D1r"; "E1r"; "F1r" ];
        smaller_masks_list = [ smaller_masks_list; "A2"; "B2"; "C2"; "D2"; "E2"; "F2" ];
        smaller_masks_list = [ smaller_masks_list; "A2r"; "B2r"; "C2r"; "D2r"; "E2r"; "F2r" ];
        smaller_masks_list = [ smaller_masks_list; "A3"; "B3"; "C3"; "D3"; "E3"; "F3" ];
        smaller_masks_list = [ smaller_masks_list; "A3r"; "B3r"; "C3r"; "D3r"; "E3r"; "F3r" ];
        smaller_masks_list = [ smaller_masks_list; "A4"; "B4"; "C4"; "D4"; "E4"; "F4" ];
        smaller_masks_list = [ smaller_masks_list; "A4r"; "B4r"; "C4r"; "D4r"; "E4r"; "F4r" ];
        
        if strcmpi(dataset_name,"positive MALDI all tumour")
            
            smaller_masks_list = [ "A1 tumour"; "B1 tumour"; "C1 tumour"; "D1 tumour"; "E1 tumour"; "F1 tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A2 tumour"; "B2 tumour"; "C2 tumour"; "D2 tumour"; "E2 tumour"; "F2 tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A3 tumour"; "B3 tumour"; "C3 tumour"; "D3 tumour"; "E3 tumour"; "F3 tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A4 tumour"; "B4 tumour"; "C4 tumour"; "D4 tumour"; "E4 tumour"; "F4 tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A1r tumour"; "B1r tumour"; "C1r tumour"; "D1r tumour"; "E1r tumour"; "F1r tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A2r tumour"; "C2r tumour"; "D2r tumour"; "E2r tumour"; "F2r tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A3r tumour"; "B3r tumour"; "C3r tumour"; "D3r tumour"; "E3r tumour"; "F3r tumour" ];
            smaller_masks_list = [ smaller_masks_list; "A4r tumour"; "B4r tumour"; "C4r tumour"; "D4r tumour"; "E4r tumour"; "F4r tumour" ];
            
        end
        
    end
    
    %
    
    outputs_xy_pairs = [
        1 1; 2 1; 3 1; 4 1; 5 1; 6 1;
        1 2; 2 2; 3 2; 4 2; 5 2; 6 2;
        1 3; 2 3; 3 3; 4 3; 5 3; 6 3;
        1 4; 2 2; 3 4; 4 4; 5 4; 6 4;
        1 5; 2 5; 3 5; 4 5; 5 5; 6 5;
        1 6; 2 6; 3 6; 4 6; 5 6; 6 6;
        1 7; 2 7; 3 7; 4 7; 5 7; 6 7;
        1 8; 2 8; 3 8; 4 8; 5 8; 6 8;
        ];
    
elseif strcmpi(dataset_name,'negative DESI B & F') || strcmpi(dataset_name,'negative DESI B & F bulk tissue')
    
    data_folders = { 'X:\PDAC Combo\negative DESI ibds and imzMLs\Individual\' };
    
    dataset_name = '*';
    
    filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
    
    clear extensive_filesToProcess
    
    extensive_filesToProcess(1:2,:)     = filesToProcess(1,:);
    extensive_filesToProcess(3:4,:)     = filesToProcess(5,:);
    extensive_filesToProcess(5:6,:)     = filesToProcess(2,:);
    extensive_filesToProcess(7,:)       = filesToProcess(6,:);
    extensive_filesToProcess(8:9,:)     = filesToProcess(3,:);
    extensive_filesToProcess(10:11,:)   = filesToProcess(7,:);
    extensive_filesToProcess(12:13,:)   = filesToProcess(4,:);
    extensive_filesToProcess(14:15,:)   = filesToProcess(8,:);
    
    if background == 1 % with background
        
        main_mask_list = "no mask";
        
        smaller_masks_list = [ "B1_BG"; "F1_BG" ];
        smaller_masks_list = [ smaller_masks_list; "B1r_BG";    "F1r_BG"	];
        smaller_masks_list = [ smaller_masks_list; "B2_BG";     "F2_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "F2r_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "B3_BG";     "F3_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "B3r_BG";    "F3r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "B4_BG";     "F4_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "B4r_BG";    "F4r_BG"    ];
        
    elseif background == -1
        
        main_mask_list = "bulk tissue";
        
        smaller_masks_list = [ "B1 tumour"; "F1 tumour" ];
        smaller_masks_list = [ smaller_masks_list; "B1r tumour";    "F1r tumour"	];
        smaller_masks_list = [ smaller_masks_list; "B2 tumour";     "F2 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "F2r tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "B3 tumour";     "F3 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "B3r tumour";    "F3r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "B4 tumour";     "F4 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "B4r tumour";    "F4r tumour"    ];
        
    end
    
    %
    
    outputs_xy_pairs = [
        1 1; 3 1;
        2 1; 4 1;
        1 2; 3 2;
        4 2;
        1 3; 3 3;
        2 3; 4 3;
        1 4; 3 4;
        2 4; 4 4;
        ];
    
elseif strcmpi(dataset_name,'negative DESI D & F') || strcmpi(dataset_name,'negative DESI D & F bulk tissue')
    
    data_folders = { 'X:\PDAC Combo\negative DESI ibds and imzMLs\Individual\' };
    
    dataset_name = '*';
    
    filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
    
    clear extensive_filesToProcess
    
    extensive_filesToProcess(1:2,:)     = filesToProcess(1,:);
    extensive_filesToProcess(3:4,:)     = filesToProcess(5,:);
    extensive_filesToProcess(5:6,:)     = filesToProcess(2,:);
    extensive_filesToProcess(7:8,:)     = filesToProcess(6,:);
    extensive_filesToProcess(9:10,:)    = filesToProcess(3,:);
    extensive_filesToProcess(11:12,:)   = filesToProcess(7,:);
    extensive_filesToProcess(13:14,:)   = filesToProcess(4,:);
    extensive_filesToProcess(15:16,:)   = filesToProcess(8,:);
    
    if background == 1 % with background
        
        main_mask_list = "no mask";
        
        smaller_masks_list = [ "D1_BG"; "F1_BG" ];
        smaller_masks_list = [ smaller_masks_list; "D1r_BG";    "F1r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "D2_BG";     "F2_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "D2r_BG";    "F2r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "D3_BG";     "F3_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "D3r_BG";    "F3r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "D4_BG";     "F4_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "D4r_BG";    "F4r_BG"    ];
        
    elseif background == -1
        
        main_mask_list = "bulk tissue";
        
        smaller_masks_list = [ "D1 tumour"; "F1 tumour" ];
        smaller_masks_list = [ smaller_masks_list; "D1r tumour";    "F1r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "D2 tumour";     "F2 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "D2r tumour";    "F2r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "D3 tumour";     "F3 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "D3r tumour";    "F3r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "D4 tumour";     "F4 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "D4r tumour";    "F4r tumour"    ];
        
    end
    
    %
    
    outputs_xy_pairs = [
        1 1; 3 1;
        2 1; 4 1;
        1 2; 3 2;
        2 2; 4 2;
        1 3; 3 3;
        2 3; 4 3;
        1 4; 3 4;
        2 4; 4 4;
        ];
    
elseif strcmpi(dataset_name,'negative DESI A & F') || strcmpi(dataset_name,'negative DESI A & F bulk tissue')
    
    data_folders = { 'X:\PDAC Combo\negative DESI ibds and imzMLs\Individual\' };
    
    dataset_name = '*';
    
    filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
    
    clear extensive_filesToProcess
    
    extensive_filesToProcess(1:2,:)     = filesToProcess(1,:);
    extensive_filesToProcess(3:4,:)     = filesToProcess(5,:);
    extensive_filesToProcess(5:6,:)     = filesToProcess(2,:);
    extensive_filesToProcess(7:8,:)     = filesToProcess(6,:);
    extensive_filesToProcess(9:10,:)    = filesToProcess(3,:);
    extensive_filesToProcess(11:12,:)   = filesToProcess(7,:);
    extensive_filesToProcess(13:14,:)   = filesToProcess(4,:);
    extensive_filesToProcess(15:16,:)   = filesToProcess(8,:);
    
    if background == 1 % with background
        
        main_mask_list = "no mask";
        
        smaller_masks_list = [ "A1_BG"; "F1_BG" ];
        smaller_masks_list = [ smaller_masks_list; "A1r_BG";    "F1r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "A2_BG";     "F2_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "A2r_BG";    "F2r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "A3_BG";     "F3_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "A3r_BG";    "F3r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "A4_BG";     "F4_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "A4r_BG";    "F4r_BG"    ];
        
    elseif background == -1
        
        main_mask_list = "bulk tissue";
        
        smaller_masks_list = [ "A1 tumour"; "F1 tumour" ];
        smaller_masks_list = [ smaller_masks_list; "A1r tumour";    "F1r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "A2 tumour";     "F2 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "A2r tumour";    "F2r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "A3 tumour";     "F3 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "A3r tumour";    "F3r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "A4 tumour";     "F4 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "A4r tumour";    "F4r tumour"    ];
        
    end
    
    %
    
    outputs_xy_pairs = [
        1 1; 3 1;
        2 1; 4 1;
        1 2; 3 2;
        2 2; 4 2;
        1 3; 3 3;
        2 3; 4 3;
        1 4; 3 4;
        2 4; 4 4;
        ];
    
elseif strcmpi(dataset_name,'negative DESI C & F') || strcmpi(dataset_name,'negative DESI C & F bulk tissue')
    
    data_folders = { 'X:\PDAC Combo\negative DESI ibds and imzMLs\Individual\' };
    
    dataset_name = '*';
    
    filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
    
    clear extensive_filesToProcess
    
    extensive_filesToProcess(1:2,:)     = filesToProcess(1,:);
    extensive_filesToProcess(3:4,:)     = filesToProcess(5,:);
    extensive_filesToProcess(5:6,:)     = filesToProcess(2,:);
    extensive_filesToProcess(7:8,:)     = filesToProcess(6,:);
    extensive_filesToProcess(9:10,:)    = filesToProcess(3,:);
    extensive_filesToProcess(11:12,:)   = filesToProcess(7,:);
    extensive_filesToProcess(13:14,:)   = filesToProcess(4,:);
    extensive_filesToProcess(15:16,:)   = filesToProcess(8,:);
    
    if background == 1 % with background
        
        main_mask_list = "no mask";
        
        smaller_masks_list = [ "C1_BG"; "F1_BG" ];
        smaller_masks_list = [ smaller_masks_list; "C1r_BG";    "F1r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "C2_BG";     "F2_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "C2r_BG";    "F2r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "C3_BG";     "F3_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "C3r_BG";    "F3r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "C4_BG";     "F4_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "C4r_BG";    "F4r_BG"    ];
        
    elseif background == -1
        
        main_mask_list = "bulk tissue";
        
        smaller_masks_list = [ "C1 tumour"; "F1 tumour" ];
        smaller_masks_list = [ smaller_masks_list; "C1r tumour";    "F1r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "C2 tumour";     "F2 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "C2r tumour";    "F2r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "C3 tumour";     "F3 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "C3r tumour";    "F3r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "C4 tumour";     "F4 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "C4r tumour";    "F4r tumour"    ];
        
    end
    
    %
    
    outputs_xy_pairs = [
        1 1; 3 1;
        2 1; 4 1;
        1 2; 3 2;
        2 2; 4 2;
        1 3; 3 3;
        2 3; 4 3;
        1 4; 3 4;
        2 4; 4 4;
        ];
    
elseif strcmpi(dataset_name,'negative DESI E & F') || strcmpi(dataset_name,'negative DESI E & F bulk tissue')
    
    data_folders = { 'X:\PDAC Combo\negative DESI ibds and imzMLs\Individual\' };
    
    dataset_name = '*';
    
    filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
    
    clear extensive_filesToProcess
    
    extensive_filesToProcess(1:2,:)     = filesToProcess(1,:);
    extensive_filesToProcess(3:4,:)     = filesToProcess(5,:);
    extensive_filesToProcess(5:6,:)     = filesToProcess(2,:);
    extensive_filesToProcess(7:8,:)     = filesToProcess(6,:);
    extensive_filesToProcess(9:10,:)    = filesToProcess(3,:);
    extensive_filesToProcess(11:12,:)   = filesToProcess(7,:);
    extensive_filesToProcess(13:14,:)   = filesToProcess(4,:);
    extensive_filesToProcess(15:16,:)   = filesToProcess(8,:);
    
    if background == 1 % with background
        
        main_mask_list = "no mask";
        
        smaller_masks_list = [ "E1_BG"; "F1_BG" ];
        smaller_masks_list = [ smaller_masks_list; "E1r_BG";    "F1r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "E2_BG";     "F2_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "E2r_BG";    "F2r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "E3_BG";     "F3_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "E3r_BG";    "F3r_BG"    ];
        smaller_masks_list = [ smaller_masks_list; "E4_BG";     "F4_BG"     ];
        smaller_masks_list = [ smaller_masks_list; "E4r_BG";    "F4r_BG"    ];
        
    elseif background == -1
        
        main_mask_list = "bulk tissue";
        
        smaller_masks_list = [ "E1 tumour"; "F1 tumour" ];
        smaller_masks_list = [ smaller_masks_list; "E1r tumour";    "F1r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "E2 tumour";     "F2 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "E2r tumour";    "F2r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "E3 tumour";     "F3 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "E3r tumour";    "F3r tumour"    ];
        smaller_masks_list = [ smaller_masks_list; "E4 tumour";     "F4 tumour"     ];
        smaller_masks_list = [ smaller_masks_list; "E4r tumour";    "F4r tumour"    ];
        
    end
    
    %
    
    outputs_xy_pairs = [
        1 1; 3 1;
        2 1; 4 1;
        1 2; 3 2;
        2 2; 4 2;
        1 3; 3 3;
        2 3; 4 3;
        1 4; 3 4;
        2 4; 4 4;
        ];

elseif strcmpi(dataset_name,'az neg desi E & F')
    
    data_folders = { 'X:\PDAC Combo\az neg desi\imzmls and ibds\' };
    
    dataset_name = '*';
    
    filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
    
    clear extensive_filesToProcess
    
    extensive_filesToProcess(1:2,:)     = filesToProcess(1,:);
    extensive_filesToProcess(3:4,:)     = filesToProcess(2,:);
    extensive_filesToProcess(5:6,:)     = filesToProcess(3,:);
    extensive_filesToProcess(7:8,:)     = filesToProcess(4,:);
    extensive_filesToProcess(9:10,:)    = filesToProcess(5,:);
    extensive_filesToProcess(11:12,:)   = filesToProcess(6,:);
    extensive_filesToProcess(13:14,:)   = filesToProcess(7,:);
    extensive_filesToProcess(15:16,:)   = filesToProcess(8,:);
    
    if background == 0 % with background
        
        main_mask_list = "tissue only";
        
        smaller_masks_list = [ "10-E1-annotated-tissue"; "10-E1-annotated-tumor" ];
        smaller_masks_list = [ smaller_masks_list;  "10-E2-annotated-tissue"; "10-E2-annotated-tumor" ];
        smaller_masks_list = [ smaller_masks_list; "10-F1-annotated-tissue"; "10-F1-annotated-tumor" ];
        smaller_masks_list = [ smaller_masks_list; "10-F2-annotated-tissue"; "10-F2-annotated-tumor" ];
        smaller_masks_list = [ smaller_masks_list; "66-E3-annotated-tissue"; "66-E3-annotated-tumor" ];
        smaller_masks_list = [ smaller_masks_list; "66-E4-annotated-tissue"; "66-E4-annotated-tumor" ];
        smaller_masks_list = [ smaller_masks_list; "66-F3-annotated-tissue"; "66-F3-annotated-tumor"    ];
        smaller_masks_list = [ smaller_masks_list; "66-F4-annotated-tissue"; "66-F4-annotated-tumor"    ];
        
    end
    
    outputs_xy_pairs = [
        1 1; 1 3; 
        2 1; 2 3;
        1 2; 1 4;
        2 2; 2 4;
        3 1; 3 3;
        4 1; 4 3;
        3 2; 3 4;
        4 2; 4 4;
        ];
    
elseif strcmpi(dataset_name,"az neg desi E & F all annotations")
    
    data_folders = { 'X:\PDAC Combo\az neg desi\imzmls and ibds\' };
    
    dataset_name = '*';
    
    filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name '.imzML']) ]; end
    
    clear extensive_filesToProcess
    
    extensive_filesToProcess(1:4,:)     = filesToProcess(1,:);
    extensive_filesToProcess(4:8,:)     = filesToProcess(2,:);
    extensive_filesToProcess(9:12,:)    = filesToProcess(3,:);
    extensive_filesToProcess(13:16,:)   = filesToProcess(4,:);
    extensive_filesToProcess(17:20,:)   = filesToProcess(5,:);
    extensive_filesToProcess(21:24,:)   = filesToProcess(6,:);
    extensive_filesToProcess(25:28,:)   = filesToProcess(7,:);
    extensive_filesToProcess(29:32,:)   = filesToProcess(8,:);
    
    if background == 0 % with background
        
        main_mask_list = "tissue only";
        
        smaller_masks_list = [ "10-E1-annotated-tissue"; "10-E1-annotated-tumor"; "10-E1-annotated-connective-tissue"; "10-E1-annotated-acinar-tissue" ];
        smaller_masks_list = [ smaller_masks_list; "10-E2-annotated-tissue"; "10-E2-annotated-tumor"; "10-E2-annotated-connective-tissue"; "10-E2-annotated-acinar-tissue" ];
        smaller_masks_list = [ smaller_masks_list; "10-F1-annotated-tissue"; "10-F1-annotated-tumor"; "10-F1-annotated-connective-tissue"; "10-F1-annotated-acinar-tissue" ];
        smaller_masks_list = [ smaller_masks_list; "10-F2-annotated-tissue"; "10-F2-annotated-tumor"; "10-F2-annotated-connective-tissue"; "10-F2-annotated-acinar-tissue" ];
        smaller_masks_list = [ smaller_masks_list; "66-E3-annotated-tissue"; "66-E3-annotated-tumor"; "66-E3-annotated-connective-tissue"; "66-E3-annotated-acinar-tissue" ];
        smaller_masks_list = [ smaller_masks_list; "66-E4-annotated-tissue"; "66-E4-annotated-tumor"; "66-E4-annotated-connective-tissue"; "66-E4-annotated-acinar-tissue" ];
        smaller_masks_list = [ smaller_masks_list; "66-F3-annotated-tissue"; "66-F3-annotated-tumor"; "66-F3-annotated-connective-tissue"; "66-F3-annotated-acinar-tissue" ];
        smaller_masks_list = [ smaller_masks_list; "66-F4-annotated-tissue"; "66-F4-annotated-tumor"; "66-F4-annotated-connective-tissue"; "66-F4-annotated-acinar-tissue" ];
        
    end
    
    outputs_xy_pairs = [
       
        ];

    
end

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
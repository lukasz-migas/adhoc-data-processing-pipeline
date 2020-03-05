
%% Data processing - 06 Nov 2019 - Teresa Murta

%% Adding functions folder (currently on the X drive) to the path

addpath(genpath('X:\2019_Scripts for Data Processing\adhoc-data-processing-pipeline\')) % Teresa's functions
addpath(genpath('X:\SpectralAnalysis\')) % SpectralAnalysis

%% Initialisation

% Please save a copy of this script in your personal T drive folder or computer and change your copy according to your study.

% Please note that the folder containing the data needs to included:

% .. the .ibd file
% .. the .imzML file
% .. the inputs_file.xlsx

% Each data file included in particular folder will be analysed according
% to the instructions defined in the inputs file. If you, for example, have 
% data from 2 polarities, you will need to have a folder with the data of
% each polarity. You will have two folders and two input files. Note that 
% you will need two different input files because you will want to request
% different adducts, for example.

% Please list the paths to all of the folders containing data you will like
% to process below.

data_folders = { ...
    ''
    };

dataset_name_portion = '*'; % Any string that matches the name of the files to be analised. If all need be analised, please use '*'.

filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name_portion '.imzML']) ]; end % Files and adducts information gathering

% Normalisation

norm_list = [
    "no norm"
    "pqn median"
    "RMS"
    ]';

% Pre-processing (location of spectralAnalysis preprocessing file)

preprocessing_file = 'X:\ICR Breast PDX\preprocessingWorkflow.sap';

%% Treating each dataset individually to create the tissue only ROI

% Pre-processing data and saving total spectra

f_saving_spectra_details( filesToProcess, preprocessing_file, "no mask" )

% Peak picking and saving peak details 

f_saving_peaks_details( filesToProcess, "no mask" )

% Peak Assignments (lists of relevant molecules & HMDB)

f_saving_relevant_lists_assignments( filesToProcess, "no mask" )

f_saving_hmdb_assignments( filesToProcess, "no mask" )

% Saving mz values that have to be included in each datacube

f_saving_datacube_peaks_details( filesToProcess, "no mask" )

% Data cube (creation and saving)

f_saving_data_cube( filesToProcess, "no mask" )

%% !!! Multivariate analysis

% running

f_running_mva( filesToProcess, "no mask", norm_list, string([]), string([]) ) % running MVAs

% saving outputs

mask_on = 0; % 1 or 0 depending on either the sii are to be masked with the main mask or not

f_saving_mva_outputs( filesToProcess, "no mask", mask_on, norm_list, string([]), string([]) ); % saving MVAs outputs

%% Saving single ion images

mask_on = 0; % 1 or 0 depending on either the sii are to be masked with the main mask or not.
sii_peak_list = "Shorter Beatson metabolomics & CRUK list"; % "all" for all lists, or the name of a short list of molecules

f_saving_sii_relevant_molecules( filesToProcess, "no mask", mask_on, norm_list, sii_peak_list );

%% Manual mask creation (e.g.: tissue only and sample specific)

%%% Please change the variable bellow.

file_index = 1; disp(filesToProcess(file_index).name); % Index of which one of the files in filesToProcess would you like to work on?                      

output_mask = "apc-kras-100-roi"; % Name for the new mask.

% Details regarding the MVA results that you would like to use to create the mask.

mva_reference   = "100 highest peaks";
input_mask      = "tissue only"; 
numComponents   = NaN;   
mva_type        = "tsne";
norm_type       = "pqn median";
vector_set      = [ 3 13 ]; % IDs of the clusters that will be added to create the mask.

regionsNum2keep = 0;
regionsNum2fill = 0;

%%%

f_mask_creation( filesToProcess(file_index), input_mask, [], mva_type, mva_reference, numComponents, norm_type, vector_set, regionsNum2keep, regionsNum2fill, output_mask )

%% Saving masks for each one of the MVA results

mva_list = "tsne"; % example
numComponents_list = NaN; % example
norm_list = "pqn median";
mva_specifics = "Shorter Beatson metabolomics & CRUK list"; % "all" for all lists, or the name of a short list of molecules

f_saving_mva_rois_ca( extensive_filesToProcess, main_mask_list, dataset_name, mva_list, numComponents_list, norm_list, mva_specifics )
 
%% Treating all datasets together (note: you need to update the samples_scheme_info function below so that it has the image grid you would like to look at)

dataset_name = "maldi neg 1458 1282"; background = 0; check_datacubes_size = 1;

[ extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs ] = f_icr_samples_scheme_info( dataset_name, background, check_datacubes_size );

% Pre-processing data and saving spectral details (total spectrum and peakDetails structs) with background

filesToProcess = f_unique_extensive_filesToProcess(extensive_filesToProcess); % This function collects all files that need to have a common axis.

%%

% Pre-processing data and saving total spectra

f_saving_spectra_details( filesToProcess, preprocessing_file, "tissue only" )

% Peak picking and saving peak details

f_saving_peaks_details_ca( filesToProcess, "tissue only" )

% Peak Assignments (lists of relevant molecules & HMDB)

f_saving_relevant_lists_assignments_ca( filesToProcess, "tissue only" )

f_saving_hmdb_assignments_ca( filesToProcess, "tissue only" )

% Saving mz values that have to be included in each datacube

f_saving_datacube_peaks_details_ca( filesToProcess, "tissue only" )

% Data cube (creation and saving)

f_saving_data_cube( filesToProcess, "tissue only" )

%% Saving single ion images of relevant molecules

sii_peak_list = "Shorter Beatson metabolomics & CRUK list";

f_saving_sii_relevant_molecules_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, sii_peak_list )

f_saving_sii_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, sii_peak_list ) % New function - it can accept hmdb classes, relevant molecules lists names or a vector of meas masses.

%% Multivariate analysis (running and saving outputs)

mva_classes_list = string([]);

mva_molecules_list = [ "CRUK metabolites", "Immunometabolites", "Structural Lipids", "Fatty acid metabolism" ];

f_running_mva_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, dataset_name, norm_list, mva_molecules_list, mva_classes_list ) % Running MVAs

f_saving_mva_outputs_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, mva_molecules_list, mva_classes_list ) % Saving MVAs outputs

mva_molecules_list = string([]);

f_running_mva_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, dataset_name, norm_list, mva_molecules_list, mva_classes_list ) % Running MVAs

f_saving_mva_outputs_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, mva_molecules_list, mva_classes_list ) % Saving MVAs outputs

%% Multivariate analysis (saving outputs barplots)

norm_list = "zscore"; mva_peak_list = "Shorter Beatson metabolomics & CRUK list";

f_saving_mva_outputs_barplot_summary_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, "pca", 16, 8, mva_peak_list )
f_saving_mva_outputs_barplot_summary_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, [ "nnmf", "kmeans"], 16, 4, mva_peak_list )

%% ROC analysis

norm_list = "pqn median";

% Note: As it is, the ROC analysis is done for the entire list of m/z
% values saved in the datacube. However, the name of the database is assig

% neg DESI small intestine

% WT_group =          [ "SA1-1-short-list-wt-9", "SA1-2-short-list-wt-9", "SA2-1-short-list-wt-9", "SA2-2-short-list-wt-9" ];
% APC_group =         [ "SA1-1-short-list-apc-1","SA1-1-short-list-apc-13", "SA1-2-short-list-apc-1","SA1-2-short-list-apc-13", "SA2-1-short-list-apc-1","SA2-1-short-list-apc-13", "SA2-2-short-list-apc-1","SA2-2-short-list-apc-13" ];
% APC_KRAS_group =    [ "SA1-1-short-list-apc-kras-8","SA1-1-short-list-apc-kras-14", "SA1-2-short-list-apc-kras-8","SA1-2-short-list-apc-kras-14", "SA2-1-short-list-apc-kras-8","SA2-1-short-list-apc-kras-14", "SA2-2-short-list-apc-kras-8","SA2-2-short-list-apc-kras-14" ];
APC_group =         [ "SA1-1-short-list-apc-1", "SA1-2-short-list-apc-1", "SA2-1-short-list-apc-1", "SA2-2-short-list-apc-1" ];
APC_KRAS_group =    [ "SA1-1-short-list-apc-kras-14", "SA1-2-short-list-apc-kras-14", "SA2-1-short-list-apc-kras-14", "SA2-2-short-list-apc-kras-14" ];


group0 = APC_group;
group0_name = "short-list-1-14-apc";

group1 = APC_KRAS_group;
group1_name = "short-list-1-14-apc-kras";

% % single imzml
% 
% f_saving_roc_analysis( extensive_filesToProcess, main_mask_list, mask_on, group0, group0_name, group1, group1_name, norm_list, [], [], [] )

% combined imzmls

mask_on = 1; % 1 or 0 depending on either the sii are to be masked with the main mask or not.
f_saving_roc_analysis( extensive_filesToProcess, main_mask_list, mask_on, group0, group0_name, group1, group1_name, norm_list, dataset_name, smaller_masks_list, outputs_xy_pairs )

%

% WT_group =          [ "SA1-1-100-wt-15", "SA1-2-100-wt-15", "SA2-1-100-wt-15", "SA2-2-100-wt-15" ];
% APC_group =         [ "SA1-1-100-apc-2","SA1-1-100-apc-8", "SA1-2-100-apc-2","SA1-2-100-apc-8", "SA2-1-100-apc-2","SA2-1-100-apc-8", "SA2-2-100-apc-2","SA2-2-100-apc-8" ];
% APC_KRAS_group =    [ "SA1-1-100-apc-kras-3","SA1-1-100-apc-kras-13", "SA1-2-100-apc-kras-3","SA1-2-100-apc-kras-13", "SA2-1-100-apc-kras-3","SA2-1-100-apc-kras-13", "SA2-2-100-apc-kras-3","SA2-2-100-apc-kras-13" ];
APC_group =         [ "SA1-1-100-apc-8", "SA1-2-100-apc-8", "SA2-1-100-apc-8", "SA2-2-100-apc-8" ];
APC_KRAS_group =    [ "SA1-1-100-apc-kras-3", "SA1-2-100-apc-kras-3", "SA2-1-100-apc-kras-3", "SA2-2-100-apc-kras-3" ];

group0 = APC_group;
group0_name = "100-3-8-apc";

group1 = APC_KRAS_group;
group1_name = "100-3-8-apc-kras";

% % single imzml
% 
% f_saving_roc_analysis( extensive_filesToProcess, main_mask_list, mask_on, group0, group0_name, group1, group1_name, norm_list, [], [], [] )

% combined imzmls

mask_on = 1; % 1 or 0 depending on either the sii are to be masked with the main mask or not.
f_saving_roc_analysis( extensive_filesToProcess, main_mask_list, mask_on, group0, group0_name, group1, group1_name, norm_list, dataset_name, smaller_masks_list, outputs_xy_pairs )

%% T-test

WT_group =          [ "SB1-2-WT","SB2-1-WT","SB2-2-WT" ];
KRAS_group =        [ "SB1-2-KRAS","SB2-1-KRAS","SB2-2-KRAS", ];
APC_group =         [ "SB1-2-APC","SB2-1-APC","SB2-2-APC" ];
APC_KRAS_group =    [ "SB1-2-APC-KRAS","SB2-1-APC-KRAS","SB2-2-APC-KRAS" ];

group0 = WT_group;
group0_name = "small I WT";

group1 = APC_KRAS_group;
group1_name = "small I APC-KRAS";

f_saving_t_tests( extensive_filesToProcess, main_mask_list, group0, group0_name, group1, group1_name, norm_list )

%% Saving data for supervised classification in Python

project_id = "icr";

f_data_4_sup_class_ca( filesToProcess, main_mask_list, smaller_masks_list, project_id, dataset_name, "mat" )



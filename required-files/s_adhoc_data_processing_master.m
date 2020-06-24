
%% Data processing - 24 June 2020 - Teresa Murta

addpath(genpath('')) % Scripts path
addpath(genpath('')) % Spectral Analysis path


%% Initialisation

% Please save a copy of this script in your personal T drive folder or computer and change your copy according to your study.

% Please note that the folder containing the data needs to included:

% .. the .ibd file
% .. the .imzML file
% .. the inputs_file.xlsx

% Each file saved in the folder swill be analysed according to the instructions defined in the inputs file.
% Data from 2 polarities have to be saved in 2 different folders, one folder for each polarity.

data_folders = { ...
    ... % Please list the paths to all folders containing data.
    };

dataset_name_portion = { 
    ... % Please list the strings that matches the names of the files to be analised. Each row should match each folder specified above. If all files need to be analised, please use '*'.
    };

filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name_portion{i} '.imzML']) ]; end % Files and adducts information gathering

preprocessing_file = ''; % Pre-processing file path (location of spectralAnalysis preprocessing file)

%% Data Pre-Processing (for each dataset individually)

mask = "no mask"; % "no mask" to start with, "tissue only" to follow

% Pre-processing data and saving total spectra

f_saving_spectra_details( filesToProcess, preprocessing_file, mask )

% Peak picking and saving peak details

f_saving_peaks_details( filesToProcess, mask )

% Peak Assignments (lists of relevant molecules & HMDB)

f_saving_relevant_lists_assignments( filesToProcess, mask )

f_saving_hmdb_assignments( filesToProcess, mask )

% Saving mz values that have to be included in each datacube

f_saving_datacube_peaks_details( filesToProcess, mask )

% Data cube (creation and saving)

f_saving_data_cube( filesToProcess, mask )

%% Multivariate Analysis (for each dataset individually)

mask_on = 0; % Please use 1 or 0 depending on whether the sii (of mva drivers) are to be masked with the main mask (usually "tissue only") or not.

norm_list = [ "no norm", "pqn median" ]; % Please list the normalisations. For a list of those available, check the function called "f_norm_datacube".

f_running_mva( filesToProcess, mask, norm_list, string([]), string([]) ) % running MVAs

f_saving_mva_outputs( filesToProcess, mask, mask_on, norm_list, string([]), string([]) ); % saving MVAs outputs

%% Single Ion Images (for each dataset individually)

mask_on = 0; % Please use 1 or 0 depending on whether the sii (of mva drivers) are to be masked with the main mask (usually "tissue only") or not.

norm_list = [ "no norm", "pqn median" ]; % Please list the normalisations. For a list of those available, check the function called "f_norm_datacube".

sii_peak_list = "Shorter Beatson metabolomics & CRUK list"; % Please list all the lists you would like to save the sii for, or simply "all" if you would like to the sii for all lists considered.

f_saving_sii_relevant_molecules( filesToProcess, "no mask", mask_on, norm_list, sii_peak_list ); % saving SIIs

%% Manual Mask Creation (e.g.: tissue only, sample A)

% Step 1 - Please update the variable "file_index" to match the file you need to work from.

file_index = 2; disp(filesToProcess(file_index).name);

% Step 2 - Please define the name of the new mask.

output_mask = "tissue only"; % Name for the new mask.

% Step 3 - Please update all variables bellow to match the MVA results you want to use to define the new masks.

mva_reference   = "100 highest peaks";
input_mask      = "no mask";
numComponents   = 4;
mva_type        = "kmeans";
norm_type       = "no norm";
vector_set      = [ 1 ]; % Please list here the ids of the clusters that you want to "add" to create the new mask. For example, for "tissue only", list all clusters that overlap with the tissue.

% Step 4 - Please update the number of times you would like to have to define particular regions/areas to keep, and/or to fill.

regionsNum2keep = 1; % to keep
regionsNum2fill = 1; % to fill

f_mask_creation( filesToProcess(file_index), input_mask, [], mva_type, mva_reference, numComponents, norm_type, vector_set, regionsNum2keep, regionsNum2fill, output_mask ) % new mask creation

%% Grouping datasets to be processed together (using a common m/z axis)

% Step 1 - Please update the f_X_samples_scheme_info function.

% Step 2 - Please run this cell.

dataset_name = "negative DESI combined"; background = 0; check_datacubes_size = 1;

[ extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs ] = ...
    f_beatson_samples_scheme_info( dataset_name, background, check_datacubes_size ); 

filesToProcess = f_unique_extensive_filesToProcess(extensive_filesToProcess); % collects all files that need to have a common m/z axis

%% Data Pre-Processing (all datasets in filesToProcess are processed together)

mask = "no mask"; % can be "no mask" to start with (making the whole process quicker because both assigments steps are run only once), "tissue only" to follow

% Pre-processing data and saving total spectra

f_saving_spectra_details( filesToProcess, preprocessing_file, mask )

% Peak picking and saving peak details

f_saving_peaks_details_ca( filesToProcess, mask )

% Peak Assignments (lists of relevant molecules & HMDB)

f_saving_relevant_lists_assignments_ca( filesToProcess, mask )

f_saving_hmdb_assignments_ca( filesToProcess, mask )

% Saving mz values that have to be included in each datacube

f_saving_datacube_peaks_details_ca( filesToProcess, mask )

% Data cube (creation and saving)

f_saving_data_cube( filesToProcess, mask )

%% Use MVA results to create new masks (each clustered will be saved as a mask i.e. SA roi struct)

% Please specify the details of the MVAs you want to save the clustering maps for.

mva_list = "tsne"; % kmeans or tsne
numComponents_list = NaN; % a particular number or NaN (if you want to use the elbow method result)
norm_list = "pqn median"; % normalisation used

% Please list all the lists you would like to save the clustering maps for, or "all" if you would like to them for all lists considered.    

mva_specifics_list = [ "Fatty Acyls", "Glycerolipids", "Glycerophospholipids" ];

for mva_specifics = mva_specifics_list 
    f_saving_mva_rois_ca( extensive_filesToProcess, main_mask_list, dataset_name, mva_list, numComponents_list, norm_list, mva_specifics ) % saving masks / rois   
end

%% Single Ion Images (all datasets are processed together)

norm_list = [ "no norm", "pqn median" ]; % Please list the normalisations. For a list of those available, check the function called "f_norm_datacube".

sii_peak_list = "Shorter Beatson metabolomics & CRUK list"; % Please list all the lists you would like to save the sii for, or simply "all" if you would like to the sii for all lists considered.

f_saving_sii_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, sii_peak_list ) % New function - it can accept hmdb classes, relevant molecules lists names or a vector of meas masses.

%% Multivariate Analysis (all datasets are processed together)

norm_list = [ "no norm", "pqn median" ]; % Please list the normalisations. For a list of those available, check the function called "f_norm_datacube".

mva_classes_list = string([]);

% Using specific lists of peaks (listed below in the variable "mva_molecules_list").

mva_molecules_list = [ "CRUK metabolites", "Immunometabolites", "Structural Lipids", "Fatty acid metabolism" ];

f_running_mva_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, dataset_name, norm_list, mva_molecules_list, mva_classes_list ) % Running MVAs

f_saving_mva_outputs_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, mva_molecules_list, mva_classes_list ) % Saving MVAs outputs

% Using the top peaks specific in the "inputs_file".

mva_molecules_list = string([]);

f_running_mva_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, dataset_name, norm_list, mva_molecules_list, mva_classes_list ) % Running MVAs

f_saving_mva_outputs_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, mva_molecules_list, mva_classes_list ) % Saving MVAs outputs

%% Multivariate analysis (saving outputs barplots)
% 
% norm_list = "zscore"; mva_peak_list = "Shorter Beatson metabolomics & CRUK list";
% 
% f_saving_mva_outputs_barplot_summary_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, "pca", 16, 8, mva_peak_list )
% f_saving_mva_outputs_barplot_summary_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, [ "nnmf", "kmeans"], 16, 4, mva_peak_list )

%% ROC analysis

norm_list = "pqn median";

% Note: The ROC analysis is done for the entire list of m/z values saved in the datacube.

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
save_sii = 0;  % 1 or 0 depending on either the sii are to be saved.

f_saving_roc_analysis( filesToProcess, main_mask_list, mask_on, save_sii, group0, group0_name, group1, group1_name, norm_list, dataset_name, smaller_masks_list, outputs_xy_pairs )

%%

norm_list = "no norm";

group0 = [ "G-APC-normal", "B-APC-normal", "D-APC-KRAS-normal", "A-APC-KRAS-normal", "C-APC-normal"];
group0_name = "normal";

group1 = [ "G-APC-tumour", "B-APC-tumour", "D-APC-KRAS-tumour", "A-APC-KRAS-tumour", "C-APC-tumour" ];
group1_name = "tumour";

% % single imzml
%
% f_saving_roc_analysis( extensive_filesToProcess, main_mask_list, mask_on, group0, group0_name, group1, group1_name, norm_list, [], [], [] )

% combined imzmls

mask_on = 1; % 1 or 0 depending on either the sii are to be masked with the main mask or not.
save_sii = 0;  % 1 or 0 depending on either the sii are to be saved.

f_saving_roc_analysis( filesToProcess, main_mask_list, mask_on, save_sii, group0, group0_name, group1, group1_name, norm_list, dataset_name, smaller_masks_list, outputs_xy_pairs )

%% T-test

WT_group =          [ "SB1-2-WT","SB2-1-WT","SB2-2-WT" ];
KRAS_group =        [ "SB1-2-KRAS","SB2-1-KRAS","SB2-2-KRAS", ];
APC_group =         [ "SB1-2-APC","SB2-1-APC","SB2-2-APC" ];
APC_KRAS_group =    [ "SB1-2-APC-KRAS","SB2-1-APC-KRAS","SB2-2-APC-KRAS" ];

group0 = WT_group;
group0_name = "small I WT";

group1 = APC_KRAS_group;
group1_name = "small I APC-KRAS";

f_saving_t_tests( filesToProcess, main_mask_list, group0, group0_name, group1, group1_name, norm_list )

%% Plot 2D and 3D PCs plots

% RGB codes for the colours of the masks defined in smaller_masks_list

norm_list = [ "no norm", "pqn median", "zscore" ];

mva_list = [ "pca" ]; % only runnng for pca at the moment
numComponents_array = [ 16 ]; % needs to match the size of mva_list
% component_x = ;
% component_y = ;
% component_z = ;

% % small intestine neg desi
%
% smaller_masks_colours = [
%     1 .8 0 % yellow - KRAS
%     1 0.3 0.3 % red - APC
%     .2 .2 .8 % blue - APC-KRAS
%     0 0 0 % black - WT
%     1 .8 0
%     1 0.3 0.3
%     .2 .2 .8
%     1 .8 0
%     .2 .2 .8
%     0 0 0
%     1 .8 0
%     1 .3 .3
%     .2 .2 .8
%     ];

% small intestine neg desi

smaller_masks_colours = [
    0 0 0 % black - WT
    1 .8 0 % yellow - KRAS
    1 0.3 0.3 % red - APC
    .2 .2 .8 % blue - APC-KRAS
    0 0 0 % black - WT
    1 .8 0 % yellow - KRAS
    1 0.3 0.3 % red - APC
    .2 .2 .8 % blue - APC-KRAS
    0 0 0 % black - WT
    1 .8 0 % yellow - KRAS
    1 0.3 0.3 % red - APC
    .2 .2 .8 % blue - APC-KRAS
    0 0 0 % black - WT
    1 .8 0 % yellow - KRAS
    1 0.3 0.3 % red - APC
    .2 .2 .8 % blue - APC-KRAS
    ];

f_saving_pca_nmf_scatter_plots_ca( extensive_filesToProcess, mva_list, numComponents_array, component_x, component_y, component_z, main_mask_list, smaller_masks_list, smaller_masks_colours, dataset_name, norm_list, string([]), string([]) )

%% Saving data for supervised classification in Python

% project_id = "icr"; f_data_4_sup_class_ca( filesToProcess, main_mask_list, smaller_masks_list, project_id, dataset_name, "txt" ) % old

f_data_4_cnn_ca( filesToProcess, main_mask_list, smaller_masks_list, dataset_name, 'txt' )
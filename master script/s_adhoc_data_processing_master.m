
%% Data processing - 15 July 2019 - Teresa Murta

%% Initialisation

% Please save a copy of this script in your personal T drive folder or computer and change your copy according to your study.

% Please note that the folder containing the data needs to includeL:

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
    'X:\Beatson\Intracolonic tumour study\Neg DESI Data\Xevo V3 Sprayer\'
    };

% Any string that matches the name of the files to be analised. If all need be analised, please use '*'.

dataset_name_portion = '*slide9*';

% Files and adducts information gathering

filesToProcess = []; for i = 1:length(data_folders); filesToProcess = [ filesToProcess; dir([data_folders{i} dataset_name_portion '.imzML']) ]; end

% Location of spectralAnalysis file comprising the information regarding the preprocessing

preprocessing_file = '\\encephalon\D\AutomatedProcessing\preprocessingWorkflowForAll.sap';

% Masks

norm_list = [
    "no norm"
    "pqn median"    
    "zscore"
    ]';

%% Adding functions folder (currently on the T drive) to the path

% Add the folder with the scripts! % e.g.: addpath(genpath('T:\DATA\NiCEMSI\People\Teresa\Analyses\'))
addpath(genpath('T:\DATA\NiCEMSI\People\Teresa\Analyses\'))
% addpath(genpath('T:\DATA\NiCEMSI\People\Teresa\SpectralAnalysis\SpectralAnalysis-1.1.0\')) % Uncomment only if you don't have SpectralAnalysis in the computer being used.

%% Treating each dataset individually to create the tissue only ROI

% Pre-processing data and saving spectral details (total spectrum and peakDetails structs) with background

f_saving_spectra_details( filesToProcess, preprocessing_file, "no mask" )

% Peak Assignment (lists of relevant molecules)

f_matching_data_with_molecules_lists( filesToProcess, "no mask" )

% Data cube (creation and saving)

f_saving_data_cube( filesToProcess, "no mask" )

% Multivariate analysis (running and saving outputs)

f_running_mva( filesToProcess, norm_list, "no mask" ) % Running MVAs

f_saving_mva_outputs( filesToProcess, norm_list, "no mask" ); % Saving MVAs outputs

% Saving single ion images of relevant molecules with background

f_saving_sii_relevant_molecules( filesToProcess, "no mask", norm_list, "all" ); % if you would like to save them just for one of the lists, replace all by the name of that list

%% Manual mask creation (e.g.: tissue only and sample specific) 

% Please change the variable bellow.

file_index = 1; % Index of which one of the files in filesToProcess would you like to work on?                      

disp(filesToProcess(file_index).name);


output_mask = "intracolonic-tissue-7";    % Name for the new mask.

% Details regarding the MVA results that you would like to use to create the mask.

input_mask      = "tissue only"; 
numComponents   = 4;   
mva_type        = "kmeans";
norm_type       = "zscore";
vector_set      = [ 1:4 ];     % IDs of the clusters that will be added to create the mask.

regionregionsNum2keep = 1;
regionregionsNum2fill = 0;

%

f_mask_creation( filesToProcess(file_index), input_mask, [], mva_type, numComponents, norm_type, vector_set, regionregionsNum2keep, regionregionsNum2fill, output_mask )
 
%% Treating all datasets together (note: you need to update the samples_scheme_info function below so that it has the image grid you would like to look at)

study = "Beatson"; 
dataset_name = "neg DESI intracolonic apc vs apc kras";
background = 0;
check_datacubes_size = 1; % If you have saved datacubes in the past and want to check their mz content.

[ extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs ] = f_beatson_samples_scheme_info( dataset_name, background, check_datacubes_size );

% Pre-processing data and saving spectral details (total spectrum and peakDetails structs) with background

filesToProcess = f_unique_extensive_filesToProcess(extensive_filesToProcess); % This function collects all files that need to have a common axis.

%%

% Pre-processing data and saving spectral details (total spectrum and peakDetails structs) without the background   

f_saving_spectra_details_ca( filesToProcess, preprocessing_file, "tissue only" ) % tissue only & common axis

f_saving_peaks_details_ca( filesToProcess, "tissue only" )

% Peak Assignment (lists of relevant molecules & HMDB)

f_matching_data_with_molecules_lists( filesToProcess, "tissue only" )

f_matching_data_with_hmdb( filesToProcess, "tissue only" )

% Data cube (creation and saving)

f_saving_data_cube( filesToProcess, "tissue only" )  

%% Multivariate analysis (running and saving outputs)

mva_peak_list = string([]); % string([]) to use the highest 4000 peaks, or the name of a short list of molecules to reduce the peak list to the latter

f_running_mva_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, dataset_name, norm_list, mva_peak_list ) % Running MVAs

f_saving_mva_outputs_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, mva_peak_list ) % Saving MVAs outputs

%% Saving single ion images of relevant molecules

sii_peak_list = "all"; % "all" for all lists, or the name of a short list of molecules

f_saving_sii_relevant_molecules_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, sii_peak_list )

%% ROC analysis - whole tissue

% Note: As it is, the ROC analysis is done for the entire list of m/z
% values saved in the datacube. However, the name of the database is assig

WT_group =          [ "SA1-2-WT","SA2-2-WT","SI-B2-4-WT-1","SI-B2-4-WT-2","SI-B1-17-WT-1","SI-B2-4-WT-3","SI-B1-20-WT-1" ];
KRAS_group =        [ "SA1-1-KRAS","SA1-2-KRAS","SA2-1-KRAS","SA2-2-KRAS""SI-B2-4-KRAS-1""SI-B2-4-APC-KRAS-2""SI-B1-17-KRAS-1""SI-B1-17-KRAS-2","SI-B1-17-KRAS-3","SI-B1-20-KRAS-1","SI-B1-20-KRAS-3" ];
APC_group =         [ "SA1-1-APC","SA1-2-APC","SA2-2-APC","SI-B2-4-APC-1","SI-B2-4-APC-2","SI-B1-17-APC-1","SI-B1-17-APC-2","SI-B1-20-APC-1","SI-B1-20-APC-2" ];
APC_KRAS_group =    [ "SA1-1-APC-KRAS","SA1-2-APC-KRAS","SA2-1-APC-KRAS","SA2-2-APC-KRAS","SI-B2-4-APC-KRAS-1","SI-B1-17-APC-KRAS-1","SI-B1-17-APC-KRAS-2","SI-B1-20-APC-KRAS-1","SI-B1-20-KRAS-2","SI-B1-20-APC-KRAS-2" ];

group0 = WT_group;
group0_name = "WT";

group1 = APC_KRAS_group;
group1_name = "APC-KRAS";

f_saving_analysis_ca( filesToProcess, main_mask_list, group0, group0_name, group1, group1_name, norm_list)

%% Saving data for supervised classification in Python

f_data_4_sup_class_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, dataset_name )

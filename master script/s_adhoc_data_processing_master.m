
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
    'X:\ICR Breast PDX\Data\ICL neg DESI\'... % Please list the paths to all folders containing data.
    };

dataset_name_portion = { 
    '*'... % Please list the strings that matches the names of the files to be analised. Each row should match each folder specified above. If all files need to be analised, please use '*'.
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

% Data normalisation (saving a normalised version of the data which is required to later plot normalised SIIs or run MVAs with normalised data)

f_saving_normalised_data( filesToProcess, mask, norm_list )

%% Multivariate Analysis (for each dataset individually)

mask_on = 0; % Please use 1 or 0 depending on whether the sii (of mva drivers) are to be masked with the main mask (usually "tissue only") or not.

norm_list = [ "no norm", "pqn median" ]; % Please list the normalisations. For a list of those available, check the function called "f_norm_datacube".

f_running_mva( filesToProcess, mask, norm_list, string([]), string([]) ) % running MVAs

f_saving_mva_outputs( filesToProcess, mask, mask_on, norm_list, string([]), string([]) ); % saving MVAs outputs

%% Saving single ion images

mask_on = 0; % 1 or 0 depending on either the sii are to be masked with the main mask or not.
sii_peak_list = "all"; % "all" (to save all lists); an array of lists; an array of hmdb classes or subclasses; an array of m/z values (less then 1e-10 apart from those saved in the datacube).
norm_list = "no norm";

f_saving_sii( filesToProcess, "no mask", mask_on, norm_list, sii_peak_list );

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

dataset_name = "icl neg desi 1458 and 1282 pdx only"; background = 0; check_datacubes_size = 1;

[ extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs ] = ...
    f_icr_samples_scheme_info( dataset_name, background, check_datacubes_size ); 

filesToProcess = f_unique_extensive_filesToProcess(extensive_filesToProcess); % collects all files that need to have a common m/z axis

%% Data Pre-Processing (all datasets in filesToProcess are processed together)

mask = "tissue only"; % can be "no mask" to start with (making the whole process quicker because both assigments steps are run only once), "tissue only" to follow

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

% Data normalisation (saving a normalised version of the data which is required to later plot normalised SIIs or run MVAs with normalised data)

f_saving_normalised_data( filesToProcess, mask, norm_list )

%% Use MVA results to create new masks (each clustered will be saved as a mask i.e. SA roi struct)

% Important note!!! This function needs to be updated because the MVA results are now a short array of
% pixels (small masks only pixels). 07 Aug 2020 Teresa

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

%% Saving ion intensities per small mask table

norm_list = [ "no norm", "RMS" ];

f_ion_intensities_table( filesToProcess, main_mask_list, smaller_masks_list, norm_list )

%% Univariate analyses (ROC, t-test)

norm_list = [ "no norm", "RMS" ];

% Groups of pixels  (arrays of small masks names)

vehicle =           [ "b1s24_vehicle","b2s22_vehicle","b3s24_vehicle","b1s19_vehicle","b2s21_vehicle","b3s25_vehicle","b4s24_vehicle","b4s23_vehicle","b3s26_vehicle" ];
AZD2014 =           [ "b1s24_2014","b2s22_2014","b3s24_2014","b1s19_2014","b2s21_2014","b3s25_2014","b4s23_2014","b3s26_2014" ];
AZD8186 =           [ "b1s24_8186","b2s22_8186","b3s24_8186","b4s20_8186","b1s19_8186","b2s21_8186","b3s25_8186","b4s24_8186","b4s23_8186","b3s26_8186" ];
AZD6244 =           [ "b1s24_6244","b2s22_6244","b3s24_6244","b4s20_6244","b1s19_6244","b2s21_6244","b3s25_6244","b4s24_6244","b4s23_6244","b3s26_6244" ];
AZD6244_AZD8186 =   [ "b1s24_6244_8186","b2s22_6244_8186","b3s24_6244_8186","b1s19_6244_8186","b2s21_6244_8186","b3s25_6244_8186","b4s23_6244_8186","b3s26_6244_8186" ];
AZD6244_AZD2014 =   [ "b1s24_6244_2014","b2s22_6244_2014","b3s24_6244_2014","b1s19_6244_2014","b2s21_6244_2014","b3s25_6244_2014","b3s26_6244_2014" ];
AZD2014_AZD8186 =   [ "b1s24_2014_8186","b3s24_2014_8186","b1s19_2014_8186","b3s25_2014_8186","b4s23_2014_8186","b3s26_2014_8186" ];

% Pairs of groups of pixels to compare with the univariate analysis

groups.name = "all vs veh and sing vs combi";

groups.masks = { vehicle, AZD2014, AZD8186, AZD6244, AZD6244_AZD8186, AZD6244_AZD2014, AZD2014_AZD8186 };
groups.names = { "vehicle", "AZD2014", "AZD8186", "AZD6244", "AZD6244_AZD8186", "AZD6244_AZD2014", "AZD2014_AZD8186" };
groups.pairs = { [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [2, 6], [2, 7], [3, 5], [3, 7], [4, 5], [4, 6] }; % [1, 2] will combine vehicle (1st position in the lists above) with AZD2014 (2nd position in the lists above)

% Univariate analysis to perform

univtests.roc = 1;
univtests.ttest = 1;

% Save single ion images?

sii.plot = 1; % 1 or 0 depending on wether siis are to be plotted or not.
sii.mask = 1; % 1 or 0 depending on wether siis are to be masked with the main mask or not.
sii.roc_th = 0.3; % Peacks with AUC below roc_th2plotsii and above 1-roc_th2plotsii will be plotted. e.g.: use 0.3 to plot AUC<0.3 and AUC>0.7
sii.ttest_th = 0.05; % Peaks with p values below ttest_th2plotsii will be plotted. e.g.: use 0.05 to plot p<0.05

sii.dataset_name = dataset_name; % Name of the dataset, which is the name given to the particular combination of small masks to plot.
sii.extensive_filesToProcess = extensive_filesToProcess; % Extensive lists of files.
sii.smaller_masks_list = smaller_masks_list; % Extensive list of small masks.
sii.outputs_xy_pairs = outputs_xy_pairs; % Extensive lists of coordenates (one pair for each small mask).

f_univariate_analyses( filesToProcess, main_mask_list, groups, norm_list, univtests, sii )

%% ANOVA (N-way)

norm_list = [ "no norm", "RMS" ];

% Effects

% same b, different s = tecni repl
% diff b, different s = biol repl

anova.masks = [ 
    "b1s19_vehicle",    "b1s24_vehicle", 	"b2s21_vehicle",    "b2s22_vehicle",    "b3s24_vehicle",  	"b3s25_vehicle",    "b3s26_vehicle",                    "b4s23_vehicle",    "b4s24_vehicle", ...
    "b1s19_2014",       "b1s24_2014",       "b2s21_2014",       "b2s22_2014",       "b3s24_2014",      	"b3s25_2014",       "b3s26_2014",                       "b4s23_2014", ...
    "b1s19_8186",       "b1s24_8186",       "b2s21_8186",       "b2s22_8186",       "b3s24_8186",       "b3s25_8186",       "b3s26_8186",       "b4s20_8186",   "b4s23_8186",       "b4s24_8186", ...
    "b1s19_6244",       "b1s24_6244",       "b2s21_6244",       "b2s22_6244",       "b3s24_6244",       "b3s25_6244",       "b3s26_6244",       "b4s20_6244",   "b4s23_6244",       "b4s24_6244", ...
    "b1s19_6244_8186",  "b1s24_6244_8186",  "b2s21_6244_8186",  "b2s22_6244_8186",  "b3s24_6244_8186",  "b3s25_6244_8186",  "b3s26_6244_8186",                  "b4s23_6244_8186", ...
    "b1s19_6244_2014",  "b1s24_6244_2014",  "b2s21_6244_2014",  "b2s22_6244_2014",  "b3s24_6244_2014",  "b3s25_6244_2014",  "b3s26_6244_2014", ...
    "b1s19_2014_8186",  "b1s24_2014_8186",                                          "b3s24_2014_8186",  "b3s25_2014_8186",  "b3s26_2014_8186",                  "b4s23_2014_8186"
    ];

eday = { 
    '5';    '1';    '5';    '1';  	'3';  	'8'; 	'11';           '10';       '8'; ...
    '5';    '1';    '5';    '1';	'3';  	'8'; 	'11';         	'10'; ...
    '5';    '1';    '5';    '1'; 	'3';  	'8';   	'11';	'3';    '10';       '8'; ...
    '5';    '1';    '5';    '1'; 	'3';  	'8';  	'11';	'3';    '10';       '8'; ...
    '5';    '1';    '5';    '1';	'3';    '8';    '11';         	'10'; ...
    '5';    '1';    '5';    '1';    '3';    '8';    '11'; ...
    '5';    '1';                    '3';    '8';    '11';           '10'
    };

eblock = { 
    '1';    '1';    '2';    '2';  	'3';  	'3'; 	'3';            '4';       '4'; ...
    '1';    '1';    '2';    '2';	'3';  	'3'; 	'3';         	'4'; ...
    '1';    '1';    '2';    '2'; 	'3';  	'3';   	'3';	'4';    '4';       '4'; ...
    '1';    '1';    '2';    '2'; 	'3';  	'3';  	'3';	'4';    '4';       '4'; ...
    '1';    '1';    '2';    '2';	'3';    '3';    '3';         	'4'; ...
    '1';    '1';    '2';    '2';    '3';    '3';    '3'; ...
    '1';    '1';                    '3';    '3';    '3';            '4'
    };

evehicle = { 
    '1';    '1';    '1';    '1';  	'1';  	'1'; 	'1';            '1';       '1'; ...
    '0';    '0';    '0';    '0';	'0';  	'0'; 	'0';            '0'; ...
    '0';    '0';    '0';    '0'; 	'0';  	'0';	'0';	'0';    '0';       '0'; ...
    '0';    '0';    '0';    '0'; 	'0';  	'0';  	'0';	'0';    '0';       '0'; ...
    '0';    '0';    '0';    '0';	'0';    '0';    '0';         	'0'; ...
    '0';    '0';    '0';    '0';    '0';    '0';    '0'; ...
    '0';    '0';                    '0';    '0';    '0';            '0'
    };

e2014 = { 
    '0';    '0';    '0';    '0';  	'0';  	'0'; 	'0';            '0';       '0'; ...
    '1';    '1';    '1';    '1';	'1';  	'1'; 	'1';            '1'; ...
    '0';    '0';    '0';    '0'; 	'0';  	'0';	'0';	'0';    '0';       '0'; ...
    '0';    '0';    '0';    '0'; 	'0';  	'0';  	'0';	'0';    '0';       '0'; ...
    '0';    '0';    '0';    '0';	'0';    '0';    '0';         	'0'; ...
    '1';    '1';    '1';    '1';    '1';    '1';    '1'; ...
    '1';    '1';                    '1';    '1';    '1';            '1'
    };

e8186 = { 
    '0';    '0';    '0';    '0';  	'0';  	'0'; 	'0';            '0';       '1'; ...
    '0';    '0';    '0';    '0';	'0';  	'0'; 	'0';            '0'; ...
    '1';    '1';    '1';    '1'; 	'1';  	'1';	'1';	'1';    '1';       '1'; ...
    '0';    '0';    '0';    '0'; 	'0';  	'0';  	'0';	'0';    '0';       '0'; ...
    '1';    '1';    '1';    '1';	'1';    '1';    '1';         	'1'; ...
    '0';    '0';    '0';    '0';    '0';    '0';    '0'; ...
    '1';    '1';                    '1';    '1';    '1';            '1'
    };

e6244 = { 
    '0';    '0';    '0';    '0';  	'0';  	'0'; 	'0';            '0';       '1'; ...
    '0';    '0';    '0';    '0';	'0';  	'0'; 	'0';            '0'; ...
    '0';    '0';    '0';    '0'; 	'0';  	'0';	'0';	'0';    '0';       '0'; ...
    '1';    '1';    '1';    '1'; 	'1';  	'1';  	'1';	'1';    '1';       '1'; ...
    '1';    '1';    '1';    '1';	'1';    '1';    '1';         	'1'; ...
    '1';    '1';    '1';    '1';    '1';    '1';    '1'; ...
    '0';    '0';                    '0';    '0';    '0';            '0'
    };

anova.labels = {'day', 'block', 'vehicle', '2014', '8186', '6244'};
anova.effects = { eday, eblock, evehicle, e2014, e8186, e6244 };

f_anova( filesToProcess, main_mask_list, norm_list, anova ) % saving the anova results table

%% Create a new set of meas m/zs to discard by filtering the ANOVA results

criteria.file = "anova day block vehicle 2014 8186 6244";
criteria.column = { "p value for day effect (mean)", "p value for block effect (mean)" }; % select from the anova results file
criteria.ths_type = { "below", "below" }; % "equal_below", "below", "equal_above", "above"
criteria.ths_value = { 0.05, 0.05 };  % between 0 and 1
criteria.combination = "or"; % "and", "or"

mzvalues2discard = f_anova_based_unwanted_mzs( filesToProcess, main_mask_list, norm_list, criteria);

%% Run MVAs after discarding the m/zs selected above

disp(['# peaks discarded: ', num2str(size(mzvalues2discard,1))])
    
% MVAs

mva_peak_list = "Amino Acids";

f_running_mva_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, dataset_name, norm_list, mva_peak_list, string([]), mzvalues2discard ) % Running MVAs

f_saving_mva_outputs_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, mva_peak_list, string([]), mzvalues2discard ) % Saving MVAs outputs

mva_peak_list = string([]); % Top peaks

f_running_mva_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, dataset_name, norm_list, mva_peak_list, string([]), mzvalues2discard ) % Running MVAs

f_saving_mva_outputs_ca( extensive_filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, mva_peak_list, string([]), mzvalues2discard ) % Saving MVAs outputs

%% Plot 2D and 3D PCs plots

% Important note!!! This function needs to be updated because the MVA results are now a short array of
% pixels (small masks only pixels). 07 Aug 2020 Teresa

norm_list = [ "no norm", "pqn median", "zscore" ];

mva_list = "pca"; % only running for pca at the moment
numComponents_array = 16; % needs to match the size of mva_list
% component_x = ;
% component_y = ;
% component_z = ;

% RGB codes for the colours of the masks defined in smaller_masks_list

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
# adhoc data processing pipeline

Semi-automated data processing pipeline developped by Teresa

## File structure

Bellow is detailed the file structure of the repository, with basic descripttion
of the content of each folder / file.
One should notice in particular the folder `documentation` which contains
`workflow_outline.pptx`, a flowchart style description of the workflow;
master script which contains `s_adhoc_data_processing_master.m`, the script to
follow in order to run the pipeline and which articulates all the other
functions together; the folder `required-files` contains the excel documents
`inputs_file.xlsx` where the master script reads the parameters to use for the
pipeline and `molecules_classes_specification.xlsx`
 * `databases mat files`
   - `complete_hmdb_info_strings.mat`
 * `documentation`
   - `workflow_outline.pptx`
 * `master script`
   - `Ontologies`
      + `imagingMS.obo`
      + `pato.obo`
      + `psi-ms.obo`
      + `uo.obo`
   - `s_adhoc_data_processing_master.m` this is the master script which you need to run. You need to modify the first inputs so that your dataset is processed. In particular, think about filling the fields `data_folders`, `dataset_name_portion`, `norm_list`, and `preprocessing_file` accordingly.  
     This is not a function properly speaking but you still have to set some "parameters" by changing bits of the code here and there and after running the script some outputs are written in indicated folders.
     __Inputs__: line 29 list of the folders containing the data to analyse along with the input files; line 33 if only a subset of the contained data files has to be analysed, give here a substring which is only contained in the names of the files to analyse; line 39 list of the types of normalisations to operate (possible values: ); line46 file describing the preprocessing to operate
     __Outputs__:
 * `molecule-lists`
   - `matrix-coating`
      + `30k_B_ratio th1.xlsx`
      + `30k_B_ratio th3.xlsx`
      + `30k_B_ratio th10.xlsx`
      + `30k_S&B_ratio th1.xlsx`
      + `30k_S&B_ratio th3.xlsx`
      + `30k_S&B_ratio th10.xlsx`
      + `30k_S&T&B_ratio th1.xlsx`
      + `30k_S&T&B_ratio th3.xlsx`
      + `30k_S&T&B_ratio th10.xlsx`
      + `30k_S&T_ratio th1.xlsx`
      + `30k_S&T_ratio th3.xlsx`
      + `30k_S&T_ratio th10.xlsx`
      + `30k_S_ratio th1.xlsx`
      + `30k_S_ratio th3.xlsx`
      + `30k_S_ratio th10.xlsx`
      + `30k_T&B_ratio th1.xlsx`
      + `30k_T&B_ratio th3.xlsx`
      + `30k_T&B_ratio th10.xlsx`
      + `30k_T_ratio th1.xlsx`
      + `30k_T_ratio th3.xlsx`
      + `30k_T_ratio th10.xlsx`
      + `60k_dhap_B_&_no_matrix_ratio th1.xlsx`
      + `60k_dhap_B_&_no_matrix_ratio th3.xlsx`
      + `60k_dhap_B_&_no_matrix_ratio th10.xlsx`
      + `60k_dhap_B_ratio th1.xlsx`
      + `60k_dhap_B_ratio th3.xlsx`
      + `60k_dhap_B_ratio th10.xlsx`
      + `60k_dhap_T_&_dhap_B_&_no_matrix_ratio th1.xlsx`
      + `60k_dhap_T_&_dhap_B_&_no_matrix_ratio th3.xlsx`
      + `60k_dhap_T_&_dhap_B_&_no_matrix_ratio th10.xlsx`
      + `60k_dhap_T_&_dhap_B_ratio th1.xlsx`
      + `60k_dhap_T_&_dhap_B_ratio th3.xlsx`
      + `60k_dhap_T_&_dhap_B_ratio th10.xlsx`
      + `60k_dhap_T_&_no_matrix_ratio th1.xlsx`
      + `60k_dhap_T_&_no_matrix_ratio th3.xlsx`
      + `60k_dhap_T_&_no_matrix_ratio th10.xlsx`
      + `60k_dhap_T_ratio th1.xlsx`
      + `60k_dhap_T_ratio th3.xlsx`
      + `60k_dhap_T_ratio th10.xlsx`
      + `60k_dhb_B_ratio th1.xlsx`
      + `60k_dhb_B_ratio th3.xlsx`
      + `60k_dhb_B_ratio th10.xlsx`
      + `60k_dhb_S&B_ratio th1.xlsx`
      + `60k_dhb_S&B_ratio th3.xlsx`
      + `60k_dhb_S&B_ratio th10.xlsx`
      + `60k_dhb_S&T&B_ratio th1.xlsx`
      + `60k_dhb_S&T&B_ratio th3.xlsx`
      + `60k_dhb_S&T&B_ratio th10.xlsx`
      + `60k_dhb_S&T_ratio th1.xlsx`
      + `60k_dhb_S&T_ratio th3.xlsx`
      + `60k_dhb_S&T_ratio th10.xlsx`
      + `60k_dhb_S_ratio th1.xlsx`
      + `60k_dhb_S_ratio th3.xlsx`
      + `60k_dhb_S_ratio th10.xlsx`
      + `60k_dhb_T&B_ratio th1.xlsx`
      + `60k_dhb_T&B_ratio th3.xlsx`
      + `60k_dhb_T&B_ratio th10.xlsx`
      + `60k_dhb_T_ratio th1.xlsx`
      + `60k_dhb_T_ratio th3.xlsx`
      + `60k_dhb_T_ratio th10.xlsx`
      + `60k_no_matrix_ratio th1.xlsx`
      + `60k_no_matrix_ratio th3.xlsx`
      + `60k_no_matrix_ratio th10.xlsx`
      + `120k_dhap_B_&_dhap_S_ratio th1.xlsx`
      + `120k_dhap_B_&_dhap_S_ratio th3.xlsx`
      + `120k_dhap_B_&_dhap_S_ratio th10.xlsx`
      + `120k_dhap_B_ratio th1.xlsx`
      + `120k_dhap_B_ratio th3.xlsx`
      + `120k_dhap_B_ratio th10.xlsx`
      + `120k_dhap_S_ratio th1.xlsx`
      + `120k_dhap_S_ratio th3.xlsx`
      + `120k_dhap_S_ratio th10.xlsx`
      + `120k_dhap_T_&_dhap_B_&_dhap_S_ratio th1.xlsx`
      + `120k_dhap_T_&_dhap_B_&_dhap_S_ratio th3.xlsx`
      + `120k_dhap_T_&_dhap_B_&_dhap_S_ratio th10.xlsx`
      + `120k_dhap_T_&_dhap_B_ratio th1.xlsx`
      + `120k_dhap_T_&_dhap_B_ratio th3.xlsx`
      + `120k_dhap_T_&_dhap_B_ratio th10.xlsx`
      + `120k_dhap_T_&_dhap_S_ratio th1.xlsx`
      + `120k_dhap_T_&_dhap_S_ratio th3.xlsx`
      + `120k_dhap_T_&_dhap_S_ratio th10.xlsx`
      + `120k_dhap_T_ratio th1.xlsx`
      + `120k_dhap_T_ratio th3.xlsx`
      + `120k_dhap_T_ratio th10.xlsx`
      + `study2_dhap_B_&_dhap_S_ratio th1.xlsx`
      + `study2_dhap_B_&_dhap_S_ratio th3.xlsx`
      + `study2_dhap_B_&_dhap_S_ratio th10.xlsx`
      + `study2_dhap_B_ratio th1.xlsx`
      + `study2_dhap_B_ratio th3.xlsx`
      + `study2_dhap_B_ratio th10.xlsx`
      + `study2_dhap_S_ratio th1.xlsx`
      + `study2_dhap_S_ratio th3.xlsx`
      + `study2_dhap_S_ratio th10.xlsx`
      + `study2_dhap_T_&_dhap_B_&_dhap_S_ratio th1.xlsx`
      + `study2_dhap_T_&_dhap_B_&_dhap_S_ratio th3.xlsx`
      + `study2_dhap_T_&_dhap_B_&_dhap_S_ratio th10.xlsx`
      + `study2_dhap_T_&_dhap_B_ratio th1.xlsx`
      + `study2_dhap_T_&_dhap_B_ratio th3.xlsx`
      + `study2_dhap_T_&_dhap_B_ratio th10.xlsx`
      + `study2_dhap_T_&_dhap_S_ratio th1.xlsx`
      + `study2_dhap_T_&_dhap_S_ratio th3.xlsx`
      + `study2_dhap_T_&_dhap_S_ratio th10.xlsx`
      + `study2_dhap_T_ratio th1.xlsx`
      + `study2_dhap_T_ratio th3.xlsx`
      + `study2_dhap_T_ratio th10.xlsx`
   - `1_GdDota.xlsx`
   - `3_slc7a5_ratios.xlsx`
   - `4_pdac_drugs.xlsx`
   - `4_Reference_List.xlsx`
   - `8_Coenzymes.xlsx`
   - `8_Sphingolipids.xlsx`
   - `17_Glycolysis.xlsx`
   - `17_U13C_glutamine_infusion.xlsx`
   - `22_nucleotide_pathways.xlsx`
   - `22_Pentose Phosphate Pathway.xlsx`
   - `22_U13C-glutamine infusion.xlsx`
   - `25_Citric Acid Cycle.xlsx`
   - `27_previous_AZ_KRAS_study.xlsx`
   - `27_Pyruvate Metabolism.xlsx`
   - `33_Glutaminolysis.xlsx`
   - `34_Slc7a5_list.xlsx`
   - `39_Fatty acid Metabolism.xlsx`
   - `40_Steroid Biosynthesis.xlsx`
   - `43_Mevalonic aciduria.xlsx`
   - `64_U13C-glutamine infusion all.xlsx`
   - `81_Beatson_LCMS.xlsx`
   - `90_Immunometabolites.xlsx`
   - `114_Metabolite_List.xlsx`
   - `125_Shorter Beatson metabolomics & CRUK list.xlsx`
   - `131_Beatson metabolomics & CRUK list.xlsx`
   - `816_Lipid_List.xlsx`
   - `AZ_Glycolysis.xlsx`
   - `AZ_TCA.xlsx`
   - `extensive_immunometabolites_ratios.xlsx`
   - `ICR_BR1282_ROC.xlsx`
   - `lipids_first_pass.csv`
   - `lipids_first_pass.xlsx`
   - `sig_compoundids_ms.xlsx`
   - `Slc7a5_Rafa_metabolite list_210319_draft.xlsx`
   - `slc7a5_ROC_hydroxybutyrate.xlsx`
   - `Small intestine DESI neg APC-KRAS vs WT.xlsx`
   - `U13C_glucose_cambridge.xlsx`
   - `U13C_Glutamine.xlsx`
 * `other functions`
   - `crukNormalise.m`  
   __Inputs__:  
   __Outputs__:
   - `f_full_colourscheme.m`  
   __Inputs__:  
   __Outputs__:
   - `f_makeAdductMassList.m`  
   __Inputs__:  
   __Outputs__:
   - `f_stringToFormula.m`  
   __Inputs__:  
   __Outputs__:
   - `kmeans_elbow.m`  
   __Inputs__:  
   __Outputs__:
   - `makePCAcolormap_tm.m`  
   __Inputs__:  
   __Outputs__:
   - `makePCAcolorscheme.m`  
   __Inputs__:  
   __Outputs__:
   - `nnTsneFull.m`  
   __Inputs__:  
   __Outputs__:
   - `reverseTsneNeuralNetwork.m`  
   __Inputs__:  
   __Outputs__:
   - `scaleColorMap.m`  
   __Inputs__:  
   __Outputs__:
   - `twilight.m`  
   __Inputs__:  
   __Outputs__:
   - `viridis.m`  
   __Inputs__:  
   __Outputs__:
 * `required-files`
   - `inputs_file.xlsx` an example of inputs file as the one you should put in your data folder.
   - `molecules_classes_specification.xlsx`
 * `toolboxes` you can put additional libraries to use in here
   - `umap 1.3.3` the UMAP library for UMAP dimension reduction
 * `f_assembling_assignments.m`  
   __Inputs__:  
   __Outputs__:
 * `f_beatson_sample_scheme_info.m`  
   __Inputs__:  
   __Outputs__:
 * `f_classes4sup_class.m`  
   __Inputs__:  
   __Outputs__:
 * `f_data_4_sup_class_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_datacube_mzvalues_ampl_ratio_highest_peaks.m`  
   __Inputs__:  
   __Outputs__:
 * `f_datacube_mzvalues_ampl_ratio_highest_peaks_percentile.m`  
   __Inputs__:  
   __Outputs__:
 * `f_datacube_mzvalues_classes.m`  
   __Inputs__:  
   __Outputs__:
 * `f_datacube_mzvalues_highest_peaks.m`  
   __Inputs__:  
   __Outputs__:
 * `f_datacube_mzvalues_highest_peaks_percentile.m`  
   __Inputs__:  
   __Outputs__:
 * `f_datacube_mzvalues_lists.m`  
   __Inputs__:  
   __Outputs__:
 * `f_datacube_mzvalues_percentile.m`  
   __Inputs__:  
   __Outputs__:
 * `f_kmeans.m`  
   __Inputs__:  
   __Outputs__:
 * `f_mask_creation.m`  
   __Inputs__:  
   __Outputs__:
 * `f_matrix_coating_studies_scheme_info.m`  
   __Inputs__:  
   __Outputs__:
 * `f_molecules_list_mat.m`  
   __Inputs__:  
   __Outputs__:
 * `f_msi_autoscaling_norm.m`  
   __Inputs__:  
   __Outputs__:
 * `f_mva_barplots.m`  
   __Inputs__:  
   __Outputs__:
 * `f_mva_output_collage.m`  
   __Inputs__:  
   __Outputs__:
 * `f_norm_datacube.m`  
   __Inputs__:  
   __Outputs__:
 * `f_pdac_samples_scheme_info.m`  
   __Inputs__:  
   __Outputs__:
 * `f_peakdetails4datacube.m`  
   __Inputs__:  
   __Outputs__:
 * `f_reading_inputs.m`  
   - __Inputs__:
     + `csv_inputs`: the absolute address of the csv giving inputs for the master script
   - __Outputs__:
     + `modality`: `str` instrument used for aquisition (DESI, MALDI, REIMS, or SIMS)
     + `polarity`: `str` polarity of aquisition, (positive of negative)
     + `adducts_list`: 
     + `mva_list`: 
     + `amplratio4mva_array`: `num OR NULL` signal to noise ratio threshold for peak picking
     + `numPeaks4mva_array`: `num OR NULL` number of peaks to keep (by order of decreasing intensity)
     + `perc4mva_array`: `num OR NULL` percentage of peaks to keep (by order of decreasing intensity)
     + `numComponents_array`: 
     + `numLoadings_array`: 
     + `mva_molecules_lists_csv_list`: 
     + `mva_molecules_lists_label_list`: 
     + `mva_max_ppm`: 
     + `pa_molecules_lists_csv_list`: 
     + `pa_molecules_lists_label_list`: 
     + `pa_max_ppm`: 
     + `fig_ppm`: 
     + `outputs_path`: `str` the path to the folder where to write the output
 * `f_RMS_norm.m`  
   __Inputs__:  
   __Outputs__:
 * `f_running_mva.m`  
   __Inputs__:  
   __Outputs__:
 * `f_running_mva_auxiliar.m`  
   __Inputs__:  
   __Outputs__:
 * `f_running_mva_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_curated_hmdb_info.m`  
   __Inputs__:  
     + `hmdb_sample_info`: table of strings with the peak matching information for all peaks
     + `relevant_lists_sample_info`: table of strings with the peak matching information for peaks in the lists of interest
   __Outputs__:
     + `new_hmdb_sample_info`
 * `f_saving_curated_top_loadings_info.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_data_cube.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_datacube_peaks_details.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_datacube_peaks_details_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_hmdb_assignments.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_hmdb_assignments_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_mva_auxiliar.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_mva_auxiliar_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_mva_outputs.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_mva_outputs_barplot_summary_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_mva_outputs_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_mva_rois_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_peaks_details.m`  
   - __Inputs__:
     + `filesToProcess`: is the list of all the files to be processed, represented by their full name and location;
     + `mask_list`: is the list of masks to use;
   - __Outputs__:
     + `peakDetails` a peakDetails matrix saved per dataset and per mask, in the output folder specified in the inputs_file, subfolder spectra details subfolder, in the subfolder of the relevent dataset, in the subfolder of the relevent mask
 * `f_saving_peaks_details_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_relevant_lists_assignments.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_relevant_lists_assignments_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_roc_analysis.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_sii_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_sii_files.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_sii_files_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_sii_ratio_files_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_sii_ratio_relevant_molecules_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_sii_ratio_sample_info_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_sii_relevant_molecules.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_sii_relevant_molecules_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_sii_sample_info.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_sii_sample_info_ca.m`  
   __Inputs__:  
   __Outputs__:
 * `f_saving_spectra_details.m`  
   - __Inputs__:
     + `filesToProcess` is the list of all the files to be processed, represented by their full name and location;
     + `preprocessing_file` is the location and name of the file describing the preprocessing to use;
     + `mask_list` is the list of masks to use;  
   - __Outputs__: all outputs are located in the output folder indicated in the `inputs_file`;
     + `rois` folder contains a subfolder per file to process, each containing a subfolder per mask type, each containing an roi file
     + `spectra details` folder: one folder per file to process, each containing one folder per mask type, each of which contains the number of pixels; the values on the m/z axis for the total spectrum; the matrix of intensities of the total spectrum.
 * `f_saving_t_tests.m`  
   __Inputs__:  
   __Outputs__:
 * `f_tic_norm.m`  
   __Inputs__:  
   __Outputs__:
 * `f_tsne.m`  
   __Inputs__:  
   __Outputs__:
 * `f_unique_extensive_filesToProcess.m`  
   __Inputs__:  
   __Outputs__:
 * `f_zscore_norm.m`  
   __Inputs__:  
   __Outputs__:

## Output structure

After running the master script, the output folder you have indicated will contain the information you asked for, organised in nested folders.
* `mva N highest peaks + A ampls ratio` where `N` and `A` are integers
  - `dataset1`
    + `mask1`
      * `mva1`
        - `normalisation1`
        - ...
        - `normalisationO`
      * ...
      * `mvaV`
    + ...
    + `maskM`
  - ...
  - `datasetD`
* `mva molecules_list` where `molecules_list`
  - `dataset1`
    + `mask1`
      * `mva1`
        - `normalisation1`
        - ...
        - `normalisationO`
      * ...
      * `mvaV`
    + ...
    + `maskM`
  - ...
  - `datasetD`
* `mva percentile P peaks` where `P` is an integer
  - `dataset1`
    + `mask1`
      * `mva1`
        - `normalisation1`
        - ...
        - `normalisationO`
      * ...
      * `mvaV`
    + ...
    + `maskM`
  - ...
  - `datasetD`
* `peak assignments`
  - `dataset1`
    + `mask1`
      * `database1_assignment.txt` csv file with the following columns
        - `molecule`: name of the matched molecule
        - `theo mz`: theoretical mass to charge ratio of the ion assuming all atoms are present under their most stable isotopic form
        - `adduct`: adduct for of the ion
        - `meas mz`: measured mass to charge ratio (location of the peak)
        - `abs ppm`: absolute (unsigned) measurement error in particule per million (assuming the assignment is right)
        - `total counts`: total intensity of this peak accross the dataset
        - `database`: database where the molecule was referenced
        - `ppm`: signed measurement error in particule per million (assuming the assignment is right)
        - `modality`: instrument used for the experiment
        - `polarity`: polarity of the analyser used for the experiment
        - `mean counts`: mean count of the peak accross the dataset
        - `monoisotopic mass`: theoretical mass of the molecule assuming all atoms are present under their most stable isotopic form
      * `database1_sample_info.mat`
      * ...
      * ...
      * `databaseD_assignment.txt`
      * `databaseD_sample_info.mat`
    + ...
    + `maskM`
  - ...
  - `datasetD`
* `roc`
  - `mask1`
    + `normalisation1`
      * `roc analysis group1 vs group2.txt`: a csv file containing the following columns for each peak
        -`AUC`: area under the roc curve, is meant to be an indicator of the quality of the classifier (WARNING: has been criticised during the past few years)
        -`meas mz`: measured mass to charge ratio of the considered peak
        -`molecule`: name of the matched molecule
        -`mono mz`: theoretical mass to charge ratio of the matched ion
        -`adduct`: adduct form of the ion
        -`ppm`: measurement error in ppm, assuming the match is right
        -`database (by mono mz)`: databases where the ion appears
      * ...
      * `roc analysis groupG-1 vs groupG.txt`
    + ...
    + `normalisationO`
  - ...
  - `maskM`
* `rois`
  - `dataset1`
  - ...
  - `datasetD`
* `single ion images`
  - `dataset1`
    + `mask1`
      * `normalisation1`
        - `list1`
          + `mz1_name1Adduct1.png`: png representing the single ion image next to the neighbourhood of the peak in the spectral domain
          + `mz1_name1Adduct1.fig`
          + ...
          + ...
          + `mzZ_nameZAdductZ.png`
          + `mzZ_nameZAdductZ.fig`
          + `boxplots_mz1_name1Adduct1.png`: figure representing the intensity distribution of this ion depending on the dataset
        - ...
        - `listL`
      * ...
      * `normalisationO`
    + ...
    + `maskM`
  - ...
  - `datasetD`
* `spectra details`
  - `dataset1`
    + `mask1`
      * `Ontologies`
        - `something.obo`:
      * `datacube.mat`
      * `datacubeonly_peakDetails.mat`
      * `height.mat`
      * `peakDetails.mat`
      * `pixels_num.mat`
      * `totalSpectrum_intensities.mat`
      * `totalSpectrum_mzvalues.mat`
      * `width.mat`
    + ...
    + `maskM`
  - ...
  - `datasetD`
* `ttest`

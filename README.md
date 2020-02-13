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
   - `s_adhoc_data_processing_master.m`
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
   - `f_full_colourscheme.m`
   - `f_makeAdductMassList.m`
   - `f_stringToFormula.m`
   - `kmeans_elbow.m`
   - `makePCAcolormap_tm.m`
   - `makePCAcolorscheme.m`
   - `nnTsneFull.m`
   - `reverseTsneNeuralNetwork.m`
   - `scaleColorMap.m`
   - `twilight.m`
   - `viridis.m`
 * `required-files`
   - `inputs_file.xlsx`
   - `molecules_classes_specification.xlsx`
 * `toolboxes`
   - `umap 1.3.3`
 * `f_assembling_assignments.m`
 * `f_beatson_sample_scheme_info.m`
 * `f_classes4sup_class.m`
 * `f_data_4_sup_class_ca.m`
 * `f_datacube_mzvalues_ampl_ratio_highest_peaks.m`
 * `f_datacube_mzvalues_ampl_ratio_highest_peaks_percentile.m`
 * `f_datacube_mzvalues_classes.m`
 * `f_datacube_mzvalues_highest_peaks.m`
 * `f_datacube_mzvalues_highest_peaks_percentile.m`
 * `f_datacube_mzvalues_lists.m`
 * `f_datacube_mzvalues_percentile.m`
 * `f_kmeans.m`
 * `f_mask_creation.m`
 * `f_matrix_coating_studies_scheme_info.m`
 * `f_molecules_list_mat.m`
 * `f_msi_autoscaling_norm.m`
 * `f_mva_barplots.m`
 * `f_mva_output_collage.m`
 * `f_norm_datacube.m`
 * `f_pdac_samples_scheme_info.m`
 * `f_peakdetails4datacube.m`
 * `f_reading_inputs.m`
 * `f_RMS_norm.m`
 * `f_running_mva.m`
 * `f_running_mva_auxiliar.m`
 * `f_running_mva_ca.m`
 * `f_saving_curated_hmdb_info.m`
 * `f_saving_curated_top_loadings_info.m`
 * `f_saving_data_cube.m`
 * `f_saving_datacube_peaks_details.m`
 * `f_saving_datacube_peaks_details_ca.m`
 * `f_saving_hmdb_assignments.m`
 * `f_saving_hmdb_assignments_ca.m`
 * `f_saving_mva_auxiliar.m`
 * `f_saving_mva_auxiliar_ca.m`
 * `f_saving_mva_outputs.m`
 * `f_saving_mva_outputs_barplot_summary_ca.m`
 * `f_saving_mva_outputs_ca.m`
 * `f_saving_mva_rois_ca.m`
 * `f_saving_peaks_details.m`
 * `f_saving_peaks_details_ca.m`
 * `f_saving_relevant_lists_assignments.m`
 * `f_saving_relevant_lists_assignments_ca.m`
 * `f_saving_roc_analysis.m`
 * `f_saving_sii_ca.m`
 * `f_saving_sii_files.m`
 * `f_saving_sii_files_ca.m`
 * `f_saving_sii_ratio_files_ca.m`
 * `f_saving_sii_ratio_relevant_molecules_ca.m`
 * `f_saving_sii_ratio_sample_info_ca.m`
 * `f_saving_sii_relevant_molecules.m`
 * `f_saving_sii_relevant_molecules_ca.m`
 * `f_saving_sii_sample_info.m`
 * `f_saving_sii_sample_info_ca.m`
 * `f_saving_spectra_details.m`
 * `f_saving_t_tests.m`
 * `f_tic_norm.m`
 * `f_tsne.m`
 * `f_unique_extensive_filesToProcess.m`
 * `f_zscore_norm.m`
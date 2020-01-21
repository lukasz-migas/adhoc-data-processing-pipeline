function [ ...
    modality, ...
    polarity, ...
    adducts_list, ...
    mva_list, ...
    amplratio4mva_array, ...
    numPeaks4mva_array, ...
    perc4mva_array, ...
    numComponents_array, ...
    numLoadings_array, ...
    mva_molecules_lists_csv_list, ...
    mva_molecules_lists_label_list, ...
    mva_max_ppm, ...
    pa_molecules_lists_csv_list, ...
    pa_molecules_lists_label_list, ...
    pa_max_ppm, ...
    fig_ppm, ...
    outputs_path ...
    ] = f_reading_inputs(csv_inputs)
%%

% Hello!

%%

[ ~, ~, inputs_info ] = xlsread(csv_inputs);

inputs_info_reshaped = string(reshape(inputs_info',[],1));
inputs_info_reshaped(ismissing(inputs_info_reshaped)) = [];

gen_info = 0;
mva_info = 0;
peak_assign_info = 0;
adducts_info = 0;

adducts_list = {};
adducts_i = 0;

mva_list = string([]);
amplratio4mva_array = [];
numPeaks4mva_array = [];
perc4mva_array = [];

numComponents_array = [];
numLoadings_array = [];

mva_molecules_lists_csv_list    = string([]);
mva_molecules_lists_label_list  = string([]);
mva_max_ppm = [];

pa_molecules_lists_csv_list   	= string([]);
pa_molecules_lists_label_list   = string([]);
pa_max_ppm = [];
fig_ppm = [];

numPeaks4mva = NaN;
perc4mva = NaN;

metabolite_lists_path = "D:\git-hub-repositories\adhoc-data-processing-pipeline\molecules-lists\";
logical_list_path = 0;

pa_molecules_lists_csv_list(1,1)    = strcat(metabolite_lists_path,"4_Reference_List.xlsx");
pa_molecules_lists_label_list(1,1)  = "reference";

for i = 1:length(inputs_info_reshaped)
    
    if peak_assign_info
        if strcmpi(inputs_info_reshaped(i),"positive") || strcmpi(inputs_info_reshaped(i),"pos")
            pos_aux_2 = 1;
        elseif strcmpi(inputs_info_reshaped(i),"negative") || strcmpi(inputs_info_reshaped(i),"neg")
            pos_aux_2 = 0;
        end
    end
    
    if adducts_info
        if strcmpi(inputs_info_reshaped(i),"yes") || strcmpi(inputs_info_reshaped(i),"y")
            if pos_aux && pos_aux_2
                adducts_i = adducts_i + 1;
                adducts_list{1,adducts_i} = char(inputs_info_reshaped(i-1));
            elseif ~pos_aux && ~pos_aux_2
                adducts_i = adducts_i + 1;
                adducts_list{1,adducts_i} = char(inputs_info_reshaped(i-1));
            end
        end
    end
    
    switch inputs_info_reshaped(i)
        case "General Information"
            gen_info = 1;
        case "Multivariate Analyses"
            mva_info = 1;
        case "Peak Assignments"
            peak_assign_info = 1;
            logical_list_path = 1;
        case "Adducts"
            logical_list_path = 0;
            adducts_info = 1;
        case "Modality"
            if peak_assign_info == 0
                if strcmpi(inputs_info_reshaped(i+1),"desi")
                    modality = "desi";
                elseif strcmpi(inputs_info_reshaped(i+1),"maldi") || strcmpi(inputs_info_reshaped(i+1),"ap-tm-maldi")
                    modality = "maldi";
                elseif strcmpi(inputs_info_reshaped(i+1),"reims")
                    modality = "reims";
                elseif strcmpi(inputs_info_reshaped(i+1),"sims")
                    modality = "sims";
                else
                    disp("Unknow modality! Please specify either MALDI or DESI in the inputs file.")
                    break
                end
            end
        case "Polarity"
            if peak_assign_info == 0
                if strcmpi(inputs_info_reshaped(i+1),"positive") || strcmpi(inputs_info_reshaped(i+1),"pos")
                    polarity = "positive";
                    pos_aux = 1;
                elseif strcmpi(inputs_info_reshaped(i+1),"negative") || strcmpi(inputs_info_reshaped(i+1),"neg")
                    polarity = "negative";
                    pos_aux = 0;
                else
                    disp("Unknow polarity!")
                    break
                end
            end
        case "Outputs path"
            outputs_path = char(inputs_info_reshaped(i+1));
        case "Highest Intensity"
            if strcmpi(inputs_info_reshaped(i+2),"yes")
                % Number
                aux_vector = str2num(char(inputs_info_reshaped(i+4)));
                numPeaks4mva_array = [ numPeaks4mva_array, aux_vector ];
                numPeaks4mva = aux_vector(1);
                if isnan(numPeaks4mva); numPeaks4mva_array = []; disp("Undefined number of highest intensity peaks!"); end
                % Percentile
                aux_vector = str2num(char(inputs_info_reshaped(i+6)));
                perc4mva_array = [ perc4mva_array, aux_vector ];
                perc4mva = aux_vector(1);
                if isnan(perc4mva); perc4mva_array = []; disp("Undefined percentile of highest intensity peaks!"); end
            end
        case "Ratio of Amplitudes Threshold"
            if strcmpi(inputs_info_reshaped(i+2),"yes")
                % Amplitudes ratio
                aux_vector = str2num(char(inputs_info_reshaped(i+4)));
                amplratio4mva_array = [ amplratio4mva_array, aux_vector ];
                amplratio4mva = aux_vector(1);
                if isnan(amplratio4mva); amplratio4mva_array = []; disp("Undefined amplitudes ration threshold!"); end
            end
            
        case "CRUK metabolites"
            list_path = strcat( metabolite_lists_path, "114_Metabolite_List.xlsx" );
        case "Beatson lipids"
            list_path = strcat( metabolite_lists_path, "816_Lipid_List.xlsx" );
        case "AZ Glycolysis"
            list_path = strcat( metabolite_lists_path, "AZ_Glycolysis.xlsx" );
        case "AZ TCA"
            list_path = strcat( metabolite_lists_path, "AZ_TCA.xlsx" );
        case "Glycolysis"
            list_path = strcat( metabolite_lists_path, "17_Glycolysis.xlsx" );
        case "Glutaminolysis"
            list_path = strcat( metabolite_lists_path, "33_Glutaminolysis.xlsx" );
        case "Pentose phosphate pathway"
            list_path = strcat( metabolite_lists_path, "22_Pentose Phosphate Pathway.xlsx" );
        case "Citric acid cycle"
            list_path = strcat( metabolite_lists_path, "25_Citric Acid Cycle.xlsx" );
        case "Pyruvate metabolism"
            list_path = strcat( metabolite_lists_path, "27_Pyruvate Metabolism.xlsx" );
        case "Fatty acid metabolism"
            list_path = strcat( metabolite_lists_path, "39_Fatty acid Metabolism.xlsx" );
        case "Steroid biosynthesis"
            list_path = strcat( metabolite_lists_path, "40_Steroid Biosynthesis.xlsx" );
        case "Mevalonic aciduria"
            list_path = strcat( metabolite_lists_path, "43_Mevalonic aciduria.xlsx" );
        case "8 Sphingolipids"
            list_path = strcat( metabolite_lists_path, "8_Sphingolipids.xlsx" );
        case "previous AZ KRAS study"
            list_path = strcat( metabolite_lists_path, "27_previous_AZ_KRAS_study.xlsx" );
        case "Gd-dota"
            list_path = strcat( metabolite_lists_path, "1_GdDota.xlsx" );
        case "Beatson LCMS"
            list_path = strcat( metabolite_lists_path, "81_Beatson_LCMS.xlsx" );
        case "U13C-glutamine infusion"
            list_path = strcat( metabolite_lists_path, "22_U13C-glutamine infusion.xlsx" );
        case "U13C-glutamine infusion all"
            list_path = strcat( metabolite_lists_path, "64_U13C-glutamine infusion all.xlsx" );
        case "Beatson metabolomics & CRUK list"
            list_path = strcat( metabolite_lists_path, "131_Beatson metabolomics & CRUK list.xlsx" );
        case "Shorter Beatson metabolomics & CRUK list"
            list_path = strcat( metabolite_lists_path, "125_Shorter Beatson metabolomics & CRUK list.xlsx" );
        case "Sig Compounds"
            list_path = strcat( metabolite_lists_path, "sig_compoundids_ms.xlsx" );
        case "HMDB Lipids and lipid-like molecules"
            list_path = strcat( metabolite_lists_path, "90360_hmdb_Lipids_and_lipid_like_molecules.xlsx" );
        case "Slc7a5 list"
            list_path = strcat( metabolite_lists_path, "34_Slc7a5_list.xlsx" );
        case "Nucleotide pathways"
            list_path = strcat( metabolite_lists_path, "22_nucleotide_pathways.xlsx" );
        case "slc7a5 ROC hydroxybutyrate"
            list_path = strcat( metabolite_lists_path, "slc7a5_ROC_hydroxybutyrate.xlsx" );
        case "Immunometabolites"
            list_path = strcat( metabolite_lists_path, "90_Immunometabolites.xlsx" );
        case "PDAC drugs"
            list_path = strcat( metabolite_lists_path, "4_pdac_drugs.xlsx" );
        case "U13C Glutamine"
            list_path = strcat( metabolite_lists_path, "U13C_Glutamine.xlsx" );
        case "Structural Lipids"
            list_path = strcat( metabolite_lists_path, "lipids_first_pass.xlsx" );
        case "Coenzymes"
            list_path = strcat( metabolite_lists_path, "8_Coenzymes.xlsx" );
        case "Small intestine DESI neg APC-KRAS vs WT"
            list_path = strcat( metabolite_lists_path, "Small intestine DESI neg APC-KRAS vs WT.xlsx" ); 

        case "maximum ppm error"
            if peak_assign_info == 0
                mva_max_ppm = double(inputs_info_reshaped(i+1));
                if isnan(mva_max_ppm) && ~isempty(mva_molecules_lists_csv_list)
                    disp("Undefined mz tolerance for MVA analysis!")
                end
            else
                pa_max_ppm = double(inputs_info_reshaped(i+1));
                if isnan(pa_max_ppm)
                    disp("Undefined mz tolerance for Peak Assignment analysis!")
                end
                if ~isempty(mva_max_ppm)
                    pa_max_ppm = max(pa_max_ppm,mva_max_ppm);
                end
            end
        case "plotting ppm error"
            fig_ppm = double(inputs_info_reshaped(i+1));
        case "PCA"
            if strcmpi(inputs_info_reshaped(i+2),"yes")
                aux_vector = str2num(char(inputs_info_reshaped(i+4)));
                mva_list = [ mva_list, "pca" ];
                numComponents_array = [ numComponents_array, aux_vector ];
                numLoadings_array = [ numLoadings_array, repmat(10,1,size(aux_vector,2)) ];
                if isnan(double(inputs_info_reshaped(i+4)))
                    disp("Undefined number of componenets to save for PCA!")
                    break
                end
            end
        case "NNMF"
            if strcmpi(inputs_info_reshaped(i+2),"yes")
                aux_vector = str2num(char(inputs_info_reshaped(i+4)));
                mva_list = [ mva_list, repmat("nnmf",1,size(aux_vector,2)) ];
                numComponents_array = [ numComponents_array, aux_vector ];
                numLoadings_array = [ numLoadings_array, repmat(10,1,size(aux_vector,2)) ];
                if isnan(aux_vector)
                    disp("Undefined number of componenets for NNMF!")
                    break
                end
            end
        case "k-means"
            if strcmpi(inputs_info_reshaped(i+2),"yes")
                aux_vector = [ NaN str2num(char(inputs_info_reshaped(i+4))) ];
                mva_list = [ mva_list, repmat("kmeans",1,size(aux_vector,2)) ];
                numComponents_array = [ numComponents_array, aux_vector ];
                numLoadings_array = [ numLoadings_array, repmat(10,1,size(aux_vector,2)) ];
                if isnan(str2num(char(inputs_info_reshaped(i+4))))
                    disp("Undefined number of componenets for k-means!")
                    break
                end
            end
        case "NN t-sne"
            if strcmpi(inputs_info_reshaped(i+2),"yes")
                aux_vector = [ NaN str2num(char(inputs_info_reshaped(i+4))) ];
                mva_list = [ mva_list, repmat("nntsne",1,size(aux_vector,2)) ];
                numComponents_array = [ numComponents_array, aux_vector ];
                numLoadings_array = [ numLoadings_array, repmat(10,1,size(aux_vector,2)) ];
            end
        case "t-sne"
            if strcmpi(inputs_info_reshaped(i+2),"yes")
                aux_vector = [ NaN str2num(char(inputs_info_reshaped(i+4))) ];
                mva_list = [ mva_list, repmat("tsne",1,size(aux_vector,2)) ];
                numComponents_array = [ numComponents_array, aux_vector ];
                numLoadings_array = [ numLoadings_array, repmat(10,1,size(aux_vector,2)) ];
            end
            
    end
    
    if logical_list_path && strcmpi(inputs_info_reshaped(i+2),"yes")
        if peak_assign_info == 0 
            mva_molecules_lists_csv_list    = [ mva_molecules_lists_csv_list, list_path ];
            mva_molecules_lists_label_list  = [ mva_molecules_lists_label_list, inputs_info_reshaped(i) ];
        elseif peak_assign_info == 1
            pa_molecules_lists_csv_list    = [ pa_molecules_lists_csv_list, list_path ];
            pa_molecules_lists_label_list  = [ pa_molecules_lists_label_list, inputs_info_reshaped(i) ];
        end
    end
    
end

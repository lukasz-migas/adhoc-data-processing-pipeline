function meas_mz_array = f_anova_based_meas_mz_array( filesToProcess, main_mask_list, norm_list, anova_effect_1_name, anova_effect_2_name, column_name, equal_above_or_below, threshold)

filesToProcess = f_unique_extensive_filesToProcess(filesToProcess); % This function collects all files that need to have a common axis.

csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

anova_path = [ char(outputs_path) '\anova\' ]; if ~exist(anova_path, 'dir'); mkdir(anova_path); end

for main_mask = main_mask_list
    
    for norm_type = norm_list
        
        cd([ anova_path char(main_mask) '\' char(norm_type) ])
        
        load([ 'anova ' char(anova_effect_1_name), ' & ', char(anova_effect_2_name), '.mat' ],'anova_analysis_table' )
        
        columns = anova_analysis_table(1,:);
                
        pvalues = double(anova_analysis_table(2:end,ismember(columns, column_name)));
        measmz = double(anova_analysis_table(2:end,ismember(columns, "meas mz")));
        
%         monomz = anova_analysis_table(2:end,ismember(columns, "mono mz"));
%         molecule = anova_analysis_table(2:end,ismember(columns, "molecule"));
        
        if strcmpi(equal_above_or_below,'equal_below')
            
            bol = (pvalues <= threshold);
            
        elseif strcmpi(equal_above_or_below,'below')
            
            bol = (pvalues < threshold);
            
        elseif strcmpi(equal_above_or_below,'equal_above')
            
            bol = (pvalues >= threshold);
            
        elseif  strcmpi(equal_above_or_below,'above')
            
            bol = (pvalues > threshold);
            
        end
        
        meas_mz_array = unique(double(measmz(bol,1)));
        
    end
    
end

function mzvalues2discard = f_anova_based_unwanted_mzs( filesToProcess, main_mask_list, norm_type, criteria)

filesToProcess = f_unique_extensive_filesToProcess(filesToProcess); % This function collects all files that need to have a common axis.

csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

anova_path = [ char(outputs_path) '\anova\' ]; if ~exist(anova_path, 'dir'); mkdir(anova_path); end

for main_mask = main_mask_list
    
    cd([ anova_path char(main_mask) '\' char(norm_type) ])
    
    load(char(criteria.file), 'anova_analysis_table')
    
    columns = anova_analysis_table(1,:);
    measmz = double(anova_analysis_table(2:end,ismember(columns, "meas mz")));
    
    pvalues = NaN*ones(size(anova_analysis_table,1)-1,length(criteria.column));
    logical_pvalues = pvalues;
    for i = 1:length(criteria.column)
        pvalues(:,i) = double(anova_analysis_table(2:end,ismember(columns, criteria.column{i})));
        if strcmpi(criteria.ths_type{i},'equal_below')
            logical_pvalues(:,i) = double(anova_analysis_table(2:end,ismember(columns, criteria.column{i}))) <= criteria.ths_value{i};
        elseif strcmpi(criteria.ths_type{i},'below')
            logical_pvalues(:,i) = double(anova_analysis_table(2:end,ismember(columns, criteria.column{i}))) < criteria.ths_value{i};
        elseif strcmpi(criteria.ths_type{i},'equal_above')
            logical_pvalues(:,i) = double(anova_analysis_table(2:end,ismember(columns, criteria.column{i}))) >= criteria.ths_value{i};
        elseif  strcmpi(criteria.ths_type{i},'above')
            logical_pvalues(:,i) = double(anova_analysis_table(2:end,ismember(columns, criteria.column{i}))) > criteria.ths_value{i};
        end
    end
    
    if strcmpi(criteria.combination,'or')
        mzvalues2discard = unique(double(measmz(logical(sum(logical_pvalues,2)),1)));
    else
        mzvalues2discard = unique(double(measmz(logical(prod(logical_pvalues,2)),1)));
    end
    
end

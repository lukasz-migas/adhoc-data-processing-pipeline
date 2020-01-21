function f_saving_sii_ca( filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, sii_peak_list )

file_index = 1;

csv_inputs = [ filesToProcess(file_index).folder filesep 'inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

peak_assignments_path   = [ char(outputs_path) filesep 'peak assignments' filesep ];

database_col = 7;
superclass_col = 15;
class_col = 16;
subclass_col = 17;
measmz_col = 4;
abs_ppm_col = 5;

for main_mask = main_mask_list
    
    load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) filesep char(main_mask) filesep 'relevant_lists_sample_info' ])
    load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) filesep char(main_mask) filesep 'hmdb_sample_info' ])
    
    if isstring(sii_peak_list)
        
        disp('! Saving sii for one or more lists of relevant molecules or hmdb classes.')
        
        sample_info = [];
        
        for listi = sii_peak_list
            
            if strcmpi(listi,"all relevant molecules")
                sample_info = [
                    sample_info
                    relevant_lists_sample_info
                    ];
            else
                
                sample_info = [
                    sample_info
                    relevant_lists_sample_info(strcmpi(listi,relevant_lists_sample_info(:,database_col)),:)
                    ];
                
                if size(hmdb_sample_info) > 14
                    
                    hmdb_sample_info(strcmpi(listi,hmdb_sample_info(:,superclass_col)),database_col) = hmdb_sample_info(strcmpi(listi,hmdb_sample_info(:,superclass_col)),superclass_col);
                    hmdb_sample_info(strcmpi(listi,hmdb_sample_info(:,class_col)),database_col) = hmdb_sample_info(strcmpi(listi,hmdb_sample_info(:,class_col)),class_col);
                    hmdb_sample_info(strcmpi(listi,hmdb_sample_info(:,subclass_col)),database_col) = hmdb_sample_info(strcmpi(listi,hmdb_sample_info(:,subclass_col)),subclass_col);
                    
                    hmdb_indexes = logical( strcmpi(listi,hmdb_sample_info(:,superclass_col)) + strcmpi(listi,hmdb_sample_info(:,class_col)) + strcmpi(listi,hmdb_sample_info(:,subclass_col)) );
                    hmdb_sample_info_curated = hmdb_sample_info(hmdb_indexes,:);
                    
                    [~, sorted_by_ppm_indexes] = sort(double(hmdb_sample_info_curated(:, abs_ppm_col)),'ascend');
                    hmdb_sample_info_sorted_by_ppm = hmdb_sample_info_curated(sorted_by_ppm_indexes,:);
                    
                    [~, unique_measmz_indexes] = unique(double(hmdb_sample_info_sorted_by_ppm(:, measmz_col)));
                    
                    sample_info = [
                        sample_info
                        hmdb_sample_info_sorted_by_ppm(unique_measmz_indexes,1:12)
                        ];
                    
                end
                
            end
            
        end
        
    elseif ~isempty(sii_peak_list)
        
        disp('! Saving sii for one or more lists of handpicked m over z values.')
        
        sample_info = [];
        
        for listi = reshape(lists,1,[])
            
            hmdb_mzvalues = double(hmdb_sample_info(:,measmz_col));
            
            [~, index] = min(abs(hmdb_mzvalues-listi));
            
            hmdb_sample_info(index,database_col) = "handpicked m over z values";
            
            sample_info = [
                sample_info
                hmdb_sample_info(index,1:12)
                ];
            
        end
        
    end
    
    f_saving_sii_sample_info_ca( filesToProcess, main_mask, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, sample_info )
    
end
function f_univariate_analyses( filesToProcess, main_mask_list, groups, norm_list, univtests, sii )

disp(' ')
disp('! Please make sure that every small mask has a unique name.')
disp(' ')
disp('This script works by searching for each individual small mask, within the rois folder of each individual imzml.')
disp('Masks with the same name (even if for different imzmls) will be combined.')
disp(' ')

filesToProcess = f_unique_extensive_filesToProcess(filesToProcess); % This function collects all files that need to have a common axis.

csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
results_path           	= [ char(outputs_path) '\uva\' ]; if ~exist(results_path, 'dir'); mkdir(results_path); end
rois_path               = [ char(outputs_path) '\rois\' ];

if univtests.roc || univtests.ttest
    
    for main_mask = main_mask_list
        
        for norm_type = norm_list
            
            col_mean = string([]);
            col_median = string([]);
            small_mask_1 = 0;
            data4stats = [];
            pixels_per_model = [];
            
            for file_index = 1:length(filesToProcess)
                
                % Loading data
                
                disp(['! Loading ' filesToProcess(file_index).name(1,1:end-6) ' data...'])
                
                load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\' char(norm_type) '\data.mat' ])
                
                if file_index == 1
                    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacubeonly_peakDetails.mat' ])
                end
                
                % Masks compilation
                
                all_folders = dir([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep '*']);
                all_folders_names = string([]); for fi = 3:size(all_folders,1); all_folders_names(fi-2) = all_folders(fi).name; end
                
                pixels_per_model0 = zeros(size(data,1),length(groups.masks));
                
                for groupi = 1:length(groups.masks)
                    
                    [ common1, all_folders_names_i1, ~ ] = intersect(all_folders_names, groups.masks{groupi});
                    
                    if ~isempty(common1)
                        
                        for aux_i = all_folders_names_i1'
                            small_mask_1 = small_mask_1 + 1;
                            disp([' . ' char(all_folders_names(aux_i)) ])
                            
                            col_mean(1,small_mask_1) = string([ char(all_folders_names(aux_i)), ' mean']);
                            col_median(1,small_mask_1) = string([ char(all_folders_names(aux_i)), ' median']);
                            
                            load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(all_folders_names(aux_i)) filesep 'roi' ])
                            
                            model_mask = reshape(roi.pixelSelection',[],1);
                            pixels_per_model0(:,groupi) = pixels_per_model0(:,groupi) + small_mask_1*model_mask.*~pixels_per_model0(:,groupi);
                        end
                        
                    end
                    
                end
                
                % Data compilation
                
                rows = logical(sum(pixels_per_model0,2)>0);
                data4stats = [ data4stats; data(rows,:) ];
                pixels_per_model = [ pixels_per_model; pixels_per_model0(rows,:) ];
                
                disp(join(['# pixels (per group): ' num2str(sum(pixels_per_model0>0))]))
                
            end
            
            disp(join(['! total # pixels (per group): ' num2str(sum(pixels_per_model>0))]))
            
            load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\hmdb_sample_info' ])
            load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
            
            extended_hmdb_sample_info = [
                hmdb_sample_info
                [ relevant_lists_sample_info, repmat("",size( relevant_lists_sample_info,1),size(hmdb_sample_info,2)-size(relevant_lists_sample_info,2))]
                ];
            
            new_hmdb_sample_info = f_saving_curated_hmdb_info( extended_hmdb_sample_info, relevant_lists_sample_info );
            
            % Univariate Analyses
            
            disp('! Running univarite analysis...')
            
            table = string([]);
            table_row1 = string([]);
            sii_sample_info = [];
            
            for mzi = 1:size(data4stats,2)
                                
                table_moving_row = [];
                
                mean4ttest1 = NaN*ones(max(pixels_per_model(:)),length(groups.pairs));
                median4ttest1 = NaN*ones(max(pixels_per_model(:)),length(groups.pairs));
                mean4ttest2 = NaN*ones(max(pixels_per_model(:)),length(groups.pairs));
                median4ttest2 = NaN*ones(max(pixels_per_model(:)),length(groups.pairs));
                
                for groupi = 1:length(groups.pairs)
                    
                    if univtests.roc==1
                        
                        % ROC analysis
                        
                        if mzi == 1
                            table_row1 = [ table_row1, ['AUC (' char(groups.names{groups.pairs{groupi}(2)}) ' vs ' char(groups.names{groups.pairs{groupi}(1)}) ')'] ];
                        end
                        
                        labels = [
                            repmat(groups.names{groups.pairs{groupi}(1)},  size(data4stats(pixels_per_model(:,groups.pairs{groupi}(1))>0,mzi),1), 1) % group A
                            repmat(groups.names{groups.pairs{groupi}(2)},  size(data4stats(pixels_per_model(:,groups.pairs{groupi}(2))>0,mzi),1), 1) % group B
                            ];
                        
                        scores = [
                            data4stats(pixels_per_model(:,groups.pairs{groupi}(1))>0,mzi) % group A
                            data4stats(pixels_per_model(:,groups.pairs{groupi}(2))>0,mzi) % group B
                            ];
                        
                        posclass = groups.names{groups.pairs{groupi}(2)};
                        
                        [~,~,~,AUC] = perfcurve(labels,scores,posclass);
                        
                        table_moving_row = [ table_moving_row, string(AUC) ];
                        
                    end
                    
                    if univtests.ttest==1
                        
                        % t-test
                        
                        if mzi == 1
                            table_row1 = [ ...
                                table_row1, ...
                                ['p-value (' char(groups.names{groups.pairs{groupi}(2)}) ' vs ' char(groups.names{groups.pairs{groupi}(1)}) ') (ttest2, mean)'], ...
                                ['p-value (' char(groups.names{groups.pairs{groupi}(2)}) ' vs ' char(groups.names{groups.pairs{groupi}(1)}) ') (ranksum, mean)'], ...
                                ['p-value (' char(groups.names{groups.pairs{groupi}(2)}) ' vs ' char(groups.names{groups.pairs{groupi}(1)}) ') (ttest2, median)'], ...
                                ['p-value (' char(groups.names{groups.pairs{groupi}(2)}) ' vs ' char(groups.names{groups.pairs{groupi}(1)}) ') (ranksum, median)'], ...
                                ];
                        end
                        
                        masks1 = unique(pixels_per_model(:,groups.pairs{groupi}(1)))';
                        
                        for maski = masks1(masks1>0)
                            
                            data4ttest1 = data4stats(pixels_per_model(:,groups.pairs{groupi}(1))==maski,mzi);
                            data4ttest1(data4ttest1==0)=[];
                            mean4ttest1(maski,groupi) = mean(data4ttest1,1,'omitnan');
                            median4ttest1(maski,groupi) = median(data4ttest1,1,'omitnan');
                            
                        end
                        
                        masks2 = unique(pixels_per_model(:,groups.pairs{groupi}(2)))';
                        
                        for maski = masks2(masks2>0)
                            
                            data4ttest2 = data4stats(pixels_per_model(:,groups.pairs{groupi}(2))==maski,mzi);
                            data4ttest2(data4ttest2==0)=[];
                            mean4ttest2(maski,groupi) = mean(data4ttest2,1,'omitnan');
                            median4ttest2(maski,groupi) = median(data4ttest2,1,'omitnan');
                            
                        end
                        
                        if sum(~isnan(mean4ttest1(masks1(masks1>0),groupi)))>0 && sum(~isnan(mean4ttest2(masks2(masks2>0),groupi)))>0
                            
                            [ ~, p_ttest2_mean, ~, ~ ] = ttest2( mean4ttest1(masks1(masks1>0),groupi), mean4ttest2(masks2(masks2>0),groupi), 'Alpha', 0.05, 'Vartype', 'unequal' );
                            [ p_ranksum_mean, ~, ~ ] = ranksum( mean4ttest1(masks1(masks1>0),groupi), mean4ttest2(masks2(masks2>0),groupi), 'Alpha', 0.05 );
                            
                            [ ~, p_ttest2_median, ~, ~ ] = ttest2( median4ttest1(masks1(masks1>0),groupi), median4ttest2(masks2(masks2>0),groupi), 'Alpha', 0.05, 'Vartype', 'unequal' );
                            [ p_ranksum_median, ~, ~ ] = ranksum( median4ttest1(masks1(masks1>0),groupi), median4ttest2(masks2(masks2>0),groupi), 'Alpha', 0.05 );
                            
                            table_moving_row = [ ...
                                table_moving_row, ...
                                [ string(p_ttest2_mean), string(p_ranksum_mean), string(p_ttest2_median), string(p_ranksum_median) ], ...
                                ];
                            
                        end
                        
                        min_p = min([ p_ttest2_mean, p_ranksum_mean, p_ttest2_median, p_ranksum_median ]);
                        
                    end
                    
                    % Single ion images
                    
                    indexes2add = (abs(datacubeonly_peakDetails(mzi,2)-double(extended_hmdb_sample_info(:,4))) < 1e-10);
                    
                    if (sii.plot == 1) && ( ( (abs(AUC-0.5)+0.5)>=(1-sii.roc_th) ) || ( min_p<=sii.ttest_th ) )
                        
                        starti = size(sii_sample_info,1)+1;
                                                
                        if sum(indexes2add) >= 1
                            
                            sii_sample_info = [ sii_sample_info; [ extended_hmdb_sample_info(find(indexes2add,1),:)]]; % just one sii per peak
                            
                        else
                            
                            aux_row = repmat("not assigned", 1, size(extended_hmdb_sample_info,2));
                            aux_row(:,4) = datacubeonly_peakDetails(mzi,2);
                            
                            sii_sample_info = [ sii_sample_info; aux_row ]; % just one sii per peak
                            
                        end
                        
                        endi = size(sii_sample_info,1);
                        
                        sii_sample_info(starti:endi,7) = ['uva ' char(groups.names{groups.pairs{groupi}(2)}) ' vs ' char(groups.names{groups.pairs{groupi}(1)}) ];
                        
                    end
                    
                end
                                
                % Adding peak assigments information
                
                if mzi == 1
                    table_row1 = [ table_row1, "meas mz", "molecule", "mono mz", "adduct", "ppm", "database (by mono mz)" ];
                end
                
                indexes2add = (abs(datacubeonly_peakDetails(mzi,2)-double(new_hmdb_sample_info(:,3))) < 1e-10);
                
                if sum(indexes2add) >= 1
                    
                    table_moving_row = [...
                        repmat([ table_moving_row string(datacubeonly_peakDetails(mzi,2)) ],sum(indexes2add),1),...
                        new_hmdb_sample_info(indexes2add,[1:2 4:end]),...
                        ];
                    
                else
                    
                    table_moving_row = [...
                        [ table_moving_row string(datacubeonly_peakDetails(mzi,2)) ],...
                        repmat("not assigned",1,5),...
                        ];
                    
                end
                
                % Mean and median intensity for each small mask
                
                if mzi == 1
                    table_row1 = [ table_row1, col_mean, col_median ];
                end
                
                table_moving_row = [...
                    table_moving_row, ...
                    repmat([ mean([mean4ttest1 mean4ttest2],2,'omitnan')', median([median4ttest1 median4ttest2],2,'omitnan')'],size(table_moving_row,1),1),...
                    ];
                
                % Compiling univariate analyses table
                
                if mzi > 1
                    table = [ table; table_moving_row ];
                else
                    table = [ table_row1; table_moving_row ];
                end
                
            end
            
            % Saving table
            
            disp('! Saving univariate analyses table...')
            
            mkdir([ results_path char(main_mask) '\' char(norm_type) ])
            cd([ results_path char(main_mask) '\' char(norm_type) ])
            
            save(strjoin([ groups.name, '.mat' ],''),'table' )
           
            table(ismissing(table)) = "NaN";
            
            txt_row = strcat(repmat('%s\t',1,size(table,2)-1),'%s\n');
            
            fileID = fopen([ char(groups.name), '.txt' ], 'w');
            fprintf(fileID,txt_row, table');
            fclose(fileID);
            
            disp('! Finished.')
            
            % Saving siis
            
            if size(sii_sample_info,1)>1
                                
                disp(['! Saving ' num2str(size(sii_sample_info,1)) ' single ion images...'])
                
                if isempty(sii.dataset_name)
                    f_saving_sii_sample_info( filesToProcess, main_mask, norm_type, sii_sample_info, sii.mask )
                else
                    f_saving_sii_sample_info_ca( sii.extensive_filesToProcess, main_mask, sii.smaller_masks_list, sii.outputs_xy_pairs, sii.dataset_name, norm_type, sii_sample_info )
                    
                end
                
                disp('! Finished.')
                
            end
            
        end
        
    end
    
else
    
    disp('Please specify at least 1 univariate analysis to perform.')
    
end


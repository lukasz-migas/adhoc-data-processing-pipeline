function f_saving_mva_outputs_barplot_summary_ca( filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, mva_type_list, numComponentsSaved_pca, numComponents, molecules_list )

for main_mask = main_mask_list
    
    datacube_cell = {};
    main_mask_cell = {};
    smaller_masks_cell = {};
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
        
        rois_path               = [ char(outputs_path) '\rois\' ];
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        
        if isempty(molecules_list)
            mva_path = [ char(outputs_path) '\mva\' ];
        else
            mva_path = [ char(outputs_path) '\mva ' char(molecules_list) '\' ];
        end
        
        % Load the datacube and assignments list
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacube' ])
        
        datacube_cell{file_index} = datacube;
        
        if file_index == 1
            
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacubeonly_peakDetails' ])
            
        end
        
        % Loading main mask information
        
        if ~strcmpi(main_mask,"no mask")
            
            load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'roi'])
            
            main_mask_cell{file_index} = reshape(roi.pixelSelection',[],1);
            
        else
            
            main_mask_cell{file_index} = true(ones(size(datacube,1),1));
            
        end
        
        % Loading smaller masks information
        
        load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(smaller_masks_list(file_index)) filesep 'roi'])
        
        smaller_masks_cell{file_index} = logical((sum(datacube.data,2)>0).*reshape(roi.pixelSelection',[],1));
        
    end
    
    for mva_type = mva_type_list
        
        for norm_type = norm_list
            
            % Loading mvas outputs
            
            switch mva_type
                
                case 'pca'
                    
                    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponentsSaved_pca) ' components\' char(norm_type) '\'])
                    load('datacube_mzvalues_indexes')
                    
                    load('firstCoeffs')
                    load('firstScores')
                    load('explainedVariance')
                    numComponentsSaved = size(firstCoeffs,2);
                    
                case 'nnmf'
                    
                    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                    load('datacube_mzvalues_indexes')
                    
                    load('W')
                    load('H')
                    numComponentsSaved = size(W,2);
                    
                    
                case 'kmeans'
                    
                    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                    load('datacube_mzvalues_indexes')
                    
                    load('C')
                    load('idx')
                    numComponentsSaved = size(C,1);
                    
                case 'nntsne'
                    
                    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                    load('datacube_mzvalues_indexes')
                    
                    load('idx')
                    load('cmap')
                    load('rgbData')
                    load('outputSpectralContriubtion')
                    numComponentsSaved = max(idx);
                    
            end
            
            if numComponents > numComponentsSaved
                disp('Error - The currently saved MVA results do not comprise all the information you want to look at! Please run the function f_running_mva again.')
                break
            else
                
                fig = figure('units','normalized','outerposition',[0 0 .35 .35]); % set(gcf,'Visible', 'off');
                
                data2plot = [];
                aux_legend = string([]);
                for componenti = 1:numComponents
                    
                    switch mva_type
                        
                        case 'pca'
                            
                            [ ~, data2plot0 ] = f_mva_barplots( firstScores(:,componenti), datacube_cell, smaller_masks_cell, outputs_xy_pairs );
                            cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponentsSaved_pca) ' components\' char(norm_type) '\'])
                            aux_legend = [aux_legend, join(['PC ' num2str(componenti)])];
                            
                        case 'nnmf'
                            
                            [ ~, data2plot0 ] = f_mva_barplots( W(:,componenti), datacube_cell, smaller_masks_cell, outputs_xy_pairs );
                            cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                            aux_legend = [aux_legend, join(['factor ' num2str(componenti)])];
                            
                        case 'kmeans'
                            
                            [ data2plot0, ~ ] = f_mva_barplots( logical(idx.*(idx==componenti)), datacube_cell, smaller_masks_cell, outputs_xy_pairs );
                            cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                            aux_legend = [aux_legend, join(['cluster ' num2str(componenti)])];
                            
                        case 'nntsne'
                            
                            [ data2plot0, ~ ] = f_mva_barplots( logical(idx.*(idx==componenti)), datacube_cell, smaller_masks_cell, outputs_xy_pairs );
                            cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                            aux_legend = [aux_legend, join(['cluster ' num2str(componenti)])];
                            
                    end
                                        
                    data2plot = [ data2plot data2plot0 ]; % one column per component
                                        
                end
                
                switch mva_type
                    
                    case 'pca'
                        
                        bar(data2plot,'EdgeColor',[1 1 1]);
                        ylabel('score median')
                        
                    case 'nnmf'
                        
                        bar(data2plot,'EdgeColor',[1 1 1]);
                        ylabel('factor median')

                    case 'kmeans'
                        
                        bar(data2plot,'stacked','EdgeColor',[1 1 1]);
                        ylabel('% of cluster coverage')
                        
                    case 'nntsne'
                        
                        bar(data2plot,'stacked','EdgeColor',[1 1 1]);
                        ylabel('% of cluster coverage')
                end
                
                xticks(1:4)
                xticklabels({'WT','KRAS','APC','APC-KRAS'})
                xlabel('Genetic Model')
                
                legend({char(aux_legend')},'location','northeastoutside')
                legend boxoff   
                
                figname_char = ['mva ' num2str(numComponents) ' components barplot.fig'];
                tifname_char = ['mva ' num2str(numComponents) ' components barplot.tif'];
                
                savefig(fig,figname_char,'compact')
                saveas(fig,tifname_char)
                
                close all
                clear fig
                
            end
        end
    end
end

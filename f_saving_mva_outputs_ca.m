function f_saving_mva_outputs_ca( filesToProcess, main_mask_list, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, molecules_list )

for main_mask = main_mask_list
    
    datacube_cell = {};
    main_mask_cell = {};
    smaller_masks_cell = {};
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ...
            mva_list, ~, ...
            numComponents_array, numLoadings_array, ...
            ~, ~, ~, ...
            ~, ~, ~, ...
            fig_ppmTolerance, ...
            outputs_path ] = f_reading_inputs(csv_inputs);
        
        rois_path               = [ char(outputs_path) '\rois\' ];
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
        if isempty(molecules_list)
            mva_path            = [ char(outputs_path) '\mva\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
        else
            mva_path            = [ char(outputs_path) '\mva ' char(molecules_list) '\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
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
    
    mvai = 0;
    for mva_type = mva_list
        mvai = mvai + 1;
        
        for norm_type = norm_list
            
            numComponents = numComponents_array(mvai);
            numLoadings = numLoadings_array(mvai);
            
            % Loading pca coefficients, scores, and explained variances
            
            switch mva_type
                
                case 'pca'
                    
                    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                    
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
                    
                    if isnan(numComponents)
                        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
                    else
                        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                    end
                    
                    load('datacube_mzvalues_indexes')
                    load('idx')
                    load('cmap')
                    load('rgbData')
                    load('outputSpectralContriubtion')
                    
                    numComponentsSaved = max(idx);
                    o_numComponents = numComponents;
                    numComponents = numComponentsSaved;
                    
            end
            
            if numComponents > numComponentsSaved
                disp('Error - The currently saved MVA results do not comprise all the information you want to look at! Please run the function f_running_mva again.')
                break
            else
                
                table = [ "cluster id" "loading relevance" "molecule" "monoisotopic mz" "theo mz" "meas mz" "adduct" "real ppm" "mean spectrum counts" "kingdom" "superclass" "class" "subclass"];
                
                for componenti = 1:numComponents
                    
                    if ( componenti == 1 )
                        
                        fig0 = figure('units','normalized','outerposition',[0 0 .7 .7]); % set(gcf,'Visible', 'off');
                        
                        if isequal(char(mva_type),'kmeans')
                            
                            cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                            
                            clustmap = f_full_colourscheme(numComponents)./255;
                            
                            image_component = f_mva_output_collage( idx, datacube_cell, outputs_xy_pairs );
                            
                            imagesc(image_component)
                            colormap(clustmap)
                            axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                            title({['Segmentation - ' num2str(numComponents)  ' clusters']})
                            
                            figname_char = 'all clusters image.fig'; savefig(fig0,figname_char,'compact')
                            tifname_char = 'all clusters image.tif'; saveas(fig0,tifname_char)
                            
                            close all
                            clear fig0
                            
                        elseif isequal(char(mva_type),'nntsne')
                            
                            if isnan(o_numComponents)
                                cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
                            else
                                cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                            end
                            
                            image_component = f_mva_output_collage( idx, datacube_cell, outputs_xy_pairs );
                            rgb_image_component = zeros(size(image_component,1),size(image_component,2),size(rgbData,2));
                            for ci = 1:size(rgbData,2); aux_rgbData = 0*idx; aux_rgbData(idx>0) = rgbData(:,ci); rgb_image_component(:,:,ci) = f_mva_output_collage( aux_rgbData, datacube_cell, outputs_xy_pairs ); end
                            
                            subplot(2,2,[1 3])
                            image(rgb_image_component)
                            axis off; axis image; set(gca, 'fontsize', 12);
                            title({'t-sne space colours'})
                            
                            subplot(2,2,2)
                            imagesc(image_component)
                            colormap(cmap)
                            axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                            title({['t-sne space segmentation - ' num2str(numComponents)  ' clusters']})
                            
                            scatter3_colour_vector = []; for cii = min(idx)+1:max(idx); scatter3_colour_vector(idx(idx>0)==cii,1:3) = repmat(cmap(cii+1,:),sum(idx(idx>0)==cii),1); end
                            
                            subplot(2,2,4)
                            scatter3(rgbData(:,1),rgbData(:,2),rgbData(:,3),1,scatter3_colour_vector); colorbar;
                            title({'t-sne space'})
                            
                            figname_char = 'all clusters image.fig'; savefig(fig0,figname_char,'compact')
                            tifname_char = 'all clusters image.tif'; saveas(fig0,tifname_char)
                            
                            close all
                            clear fig0
                            
                        end
                        
                    end
                    
                    fig = figure('units','normalized','outerposition',[0 0 .7 .7]); % set(gcf,'Visible', 'off');
                    
                    subplot(1,2,1)
                    
                    switch mva_type
                        
                        case 'pca'
                            
                            mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\pc ' num2str(componenti) '\'])
                            cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\pc ' num2str(componenti) '\'])
                            
                            image_component = f_mva_output_collage( firstScores(:,componenti), datacube_cell, outputs_xy_pairs );
                            
                            spectral_component = firstCoeffs(:,componenti);
                            
                            map = makePCAcolorscheme(image_component); colormap(map); title({['pc ' num2str(componenti) ' scores - ' num2str(explainedVariance(componenti,1)) '% of explained variance' ]})
                            
                            outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\pc ' num2str(componenti) '\top loadings images\'];
                            mkdir(outputs_path)
                            
                        case 'nnmf'
                            
                            mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\'])
                            cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\'])
                            
                            image_component = f_mva_output_collage( W(:,componenti), datacube_cell, outputs_xy_pairs );
                            
                            spectral_component = H(componenti,:);
                            
                            colormap(viridis); title({['factor ' num2str(componenti) ' image ' ]})
                            
                            outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\top loadings images\'];
                            mkdir(outputs_path)
                            
                            
                        case 'kmeans'
                            
                            mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                            cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                            
                            image_component = f_mva_output_collage( logical(idx.*(idx==componenti)), datacube_cell, outputs_xy_pairs );
                            
                            spectral_component = C(componenti,:);
                            
                            colormap(clustmap([1 componenti+1],:)); title({['cluster ' num2str(componenti) ' image ' ]})
                            
                            outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\top loadings images\'];
                            mkdir(outputs_path)
                            
                        case 'nntsne'
                            
                            if isnan(o_numComponents)
                                mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                                cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                                outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\cluster ' num2str(componenti) '\top loadings images\'];
                                mkdir(outputs_path)
                            else
                                mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                                cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                                outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\top loadings images\'];
                                mkdir(outputs_path)
                            end
                            
                            image_component = f_mva_output_collage( logical(idx.*(idx==componenti)), datacube_cell, outputs_xy_pairs );
                            
                            spectral_component = outputSpectralContriubtion{1,componenti}';
                            
                            colormap(cmap([1 componenti+1],:)); title({['cluster ' num2str(componenti) ' image ' ]})
                            
                    end
                    
                    imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                    
                    subplot(1,2,2)
                    
                    stem(datacube.spectralChannels(datacube_mzvalues_indexes), spectral_component, 'color', [0 0 0] , 'marker', 'none'); xlabel('\it{m/z}'); axis square;
                    set(gca, 'LineWidth', 2 );
                    set(gca, 'fontsize', 12);
                    set(gca, 'Xlim', [min(datacube.spectralChannels(datacube_mzvalues_indexes)) max(datacube.spectralChannels(datacube_mzvalues_indexes))])
                    set(gca, 'Ylim', [min(spectral_component).*1.1 max(spectral_component).*1.1])
                    
                    switch mva_type
                        
                        case 'pca'
                            
                            title({['PC ' num2str(componenti) ' (exp. var. ' num2str(round(explainedVariance(componenti,1),2)) '%) loadings' ]})
                            
                            figname_char = [ 'pc ' num2str(componenti) ' scores and loadings.fig'];
                            tifname_char = [ 'pc ' num2str(componenti) ' scores and loadings.tif'];
                            
                        case 'nnmf'
                            
                            title({['Factor ' num2str(componenti) ' spectrum' ]})
                            
                            figname_char = [ 'factor ' num2str(componenti) ' image and spectrum.fig'];
                            tifname_char = [ 'factor ' num2str(componenti) ' image and spectrum.tif'];
                            
                        case 'kmeans'
                            
                            title({['Cluster ' num2str(componenti) ' spectrum' ]})
                            
                            figname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.fig'];
                            tifname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.tif'];
                            
                        case 'nntsne'
                            
                            title({['Cluster ' num2str(componenti) ' spectrum' ]})
                            
                            figname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.fig'];
                            tifname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.tif'];
                            
                    end
                    
                    savefig(fig,figname_char,'compact')
                    saveas(fig,tifname_char)
                    
                    close all
                    clear fig
                    
                    % if ~strcmpi(main_mask,"no mask")
                    
                    % saving single ion images of the highest loadings
                    
                    % loading hmdb matching information
                    
                    load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\hmdb_sample_info' ])
                    
                    [ ~, mz_indexes ] = sort(abs(spectral_component),'descend');
                    
                    mva_mzvalues        = datacube_cell{1}.spectralChannels(datacube_mzvalues_indexes);
                    mini_mzvalues       = mva_mzvalues(mz_indexes(1:numLoadings));
                    
                    mva_peakDetails     = datacubeonly_peakDetails(datacube_mzvalues_indexes,:);
                    mini_peak_details   = mva_peakDetails(mz_indexes(1:numLoadings),:); % Peak details need to be sorted in the intended way (e.g, highest loading peaks first)! Sii will be saved based on it.
                    
                    all_mzvalues        = double(hmdb_sample_info(:,4));
                    
                    mini_mzvalues_aux   = repmat(mini_mzvalues,1,size(all_mzvalues,1));
                    all_mzvalues_aux    = repmat(all_mzvalues',size(mini_mzvalues,1),1);
                    
                    mini_sample_info    = hmdb_sample_info(logical(sum(abs(mini_mzvalues_aux-all_mzvalues_aux)<0.0000001,1))',:);
                    
                    aux_string1 = "not assigned";
                    aux_string2 = "NA";
                    
                    aux_string_left     = repmat([ aux_string1 aux_string2 aux_string2 ],1,1);
                    aux_string_right    = repmat([ aux_string2 aux_string2 aux_string1 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 ],1,1);
                    
                    ii = 0;
                    mini_sample_info_indexes = [];
                    for mzi = mini_mzvalues'
                        ii = ii + 1;
                        if sum(abs(mzi-double(mini_sample_info(:,4)))<0.0000001,1)
                            mini_sample_info_indexes = [
                                mini_sample_info_indexes
                                find(abs(mzi-double(mini_sample_info(:,4)))<0.0000001,1,'first')
                                ];
                        else
                            mini_sample_info_indexes = [
                                mini_sample_info_indexes
                                size(mini_sample_info,1)+1
                                ];
                            mini_sample_info = [
                                mini_sample_info
                                aux_string_left string(mzi) aux_string_right
                                ];
                        end
                        table =    [
                            table
                            [ repmat([ string(componenti) string(ii) ],length(find(abs(mzi-double(mini_sample_info(:,4)))<0.0000001)),1) mini_sample_info(logical(abs(mzi-double(mini_sample_info(:,4)))<0.0000001),[1 12 2 4 3 8 11 14:size(mini_sample_info,2)]) ]
                            ];
                    end
                    
                    % [ mini_peakDetails(:,2) mini_sample_info(mini_sample_info_indexes,4) ]
                    
                    mini_ion_images_cell = {};
                    totalSpectrum_intensities_cell = {};
                    totalSpectrum_mzvalues_cell = {};
                    pixels_num_cell = {};
                    
                    for file_index = 1:length(datacube_cell)
                        
                        mva_ion_images = f_norm_datacube_v2( datacube_cell{file_index}, main_mask_cell{file_index}, norm_type );
                        mva_ion_images = mva_ion_images(:,datacube_mzvalues_indexes);
                        
                        mini_ion_images_cell{file_index}.data = mva_ion_images(:,mz_indexes(1:numLoadings));
                        mini_ion_images_cell{file_index}.width = datacube_cell{file_index}.width;
                        mini_ion_images_cell{file_index}.height = datacube_cell{file_index}.height;
                        
                        % loading spectral information
                        
                        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_intensities' ])
                        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_mzvalues' ])
                        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\pixels_num' ])
                        
                        totalSpectrum_intensities_cell{file_index} = totalSpectrum_intensities;
                        totalSpectrum_mzvalues_cell{file_index} = totalSpectrum_mzvalues;
                        pixels_num_cell{file_index} = pixels_num;
                        
                    end
                    
                    % figures generation and saving
                    
                    f_saving_sii_files_ca( ...
                        outputs_path, ...
                        smaller_masks_list, ...
                        outputs_xy_pairs, ...
                        mini_sample_info, mini_sample_info_indexes, ...
                        mini_ion_images_cell, smaller_masks_cell, ...
                        mini_peak_details, ...
                        pixels_num_cell, ...
                        totalSpectrum_intensities_cell, totalSpectrum_mzvalues_cell, ...
                        fig_ppmTolerance, 1 )
                    
                    % end
                end
                
                % saving table with the to loading information
                
                if (strcmpi(mva_type,'nntsne') && isnan(o_numComponents))
                    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
                else
                    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                end
                
                save('top_loadings_info','table')
                
                txt_row = strcat(repmat('%s\t',1,size(table,2)-1),'%s\n');
                
                fileID = fopen('top_loadings_info.txt','w');
                fprintf(fileID,txt_row, table');
                fclose(fileID);
                
                load([ peak_assignments_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
                
                % curating the top loadings info table and saving it
                
                curated_table = f_saving_curated_top_loadings_info( table, relevant_lists_sample_info );
                
                save('top_loadings_info_curated_1','curated_table')
                
                txt_row = strcat(repmat('%s\t',1,size(curated_table,2)-1),'%s\n');
                
                fileID = fopen('top_loadings_info_curated_1.txt','w');
                fprintf(fileID,txt_row, curated_table');
                fclose(fileID);
                
            end
        end
    end
end

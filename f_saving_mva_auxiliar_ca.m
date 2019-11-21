function f_saving_mva_auxiliar_ca( mva_type, mva_path, dataset_name, main_mask, norm_type, numComponents, numLoadings, datacube_cell, outputs_xy_pairs, spectra_details_path, datacubeonly_peakDetails, hmdb_sample_info, relevant_lists_sample_info, filesToProcess, smaller_masks_list, main_mask_cell, smaller_masks_cell, meanSpectrum_intensities, meanSpectrum_mzvalues, fig_ppmTolerance)

if ~isnan(numComponents)
    
    mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
    
else
    
    mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
    
end

load('datacube_mzvalues_indexes')

% Loading MVA results

switch mva_type
    
    case 'pca'
        
        load('datacube_mzvalues_indexes')
        load('firstCoeffs')
        load('firstScores')
        load('explainedVariance')
        
        numComponentsSaved = size(firstCoeffs,2);
        numComponents = numComponentsSaved;
        
    case 'nnmf'
        
        load('datacube_mzvalues_indexes')
        load('W')
        load('H')
        
        numComponentsSaved = size(W,2);
        
        
    case 'kmeans'
        
        load('datacube_mzvalues_indexes')
        load('C')
        load('idx')
        
        numComponentsSaved = size(C,1);
        
    case 'nntsne'
        
        load('datacube_mzvalues_indexes')
        load('idx')
        load('cmap')
        load('rgbData')
        load('outputSpectralContriubtion')
        
        numComponentsSaved = max(idx);
        o_numComponents = numComponents;
        numComponents = numComponentsSaved;
        
    case 'tsne'
        
        load('datacube_mzvalues_indexes')
        load('idx')
        load('cmap')
        load('rgbData')
        
        numComponentsSaved = max(idx);
        o_numComponents = numComponents;
        numComponents = numComponentsSaved;
        
end

if numComponents > numComponentsSaved
    disp('!!! Error - The currently saved MVA results do not comprise all the information you want to look at! Please run the function f_running_mva again.')
    return
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
                svgname_char = 'all clusters image.svg'; saveas(fig0,svgname_char)
                
                
            elseif isequal(char(mva_type),'nntsne') || isequal(char(mva_type),'tsne')
                
                if isnan(o_numComponents)
                    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
                else
                    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                end
                
                image_component = f_mva_output_collage( idx, datacube_cell, outputs_xy_pairs );
                rgb_image_component = zeros(size(image_component,1),size(image_component,2),size(rgbData,2));
                for ci = 1:size(rgbData,2); aux_rgbData = 0*idx; aux_rgbData(idx>0) = rgbData(:,ci); rgb_image_component(:,:,ci) = f_mva_output_collage( aux_rgbData, datacube_cell, outputs_xy_pairs ); end
                
                subplot(2,2,[1 3])
                imagesc(image_component)
                colormap(cmap)
                axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                title({['t-sne space segmentation - ' num2str(numComponents)  ' clusters']})
                
                subplot(2,2,2)
                image(rgb_image_component)
                axis off; axis image; set(gca, 'fontsize', 12);
                title({'t-sne space colours'})               
                
                scatter3_colour_vector = []; for cii = min(idx)+1:max(idx); scatter3_colour_vector(idx(idx>0)==cii,1:3) = repmat(cmap(cii+1,:),sum(idx(idx>0)==cii),1); end
                
                subplot(2,2,4)
                scatter3(rgbData(:,1),rgbData(:,2),rgbData(:,3),1,scatter3_colour_vector); colorbar;
                title({'t-sne space'})
                
                figname_char = 'all clusters image.fig'; savefig(fig0,figname_char,'compact')
                tifname_char = 'all clusters image.tif'; saveas(fig0,tifname_char)
                svgname_char = 'all clusters image.svg'; saveas(fig0,svgname_char)
                
            end
            
        end
        
        close all
        clear fig0
        
        fig = figure('units','normalized','outerposition',[0 0 .7 .7]); % set(gcf,'Visible', 'off');
        
        subplot(1,2,1)
        
        switch mva_type
            
            case 'pca'
                
                mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\pc ' num2str(componenti) '\'])
                cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\pc ' num2str(componenti) '\'])
                
                image_component = f_mva_output_collage( firstScores(:,componenti), datacube_cell, outputs_xy_pairs );
                
                spectral_component = firstCoeffs(:,componenti);
                
                imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                
                cmap = makePCAcolormap_tm('DarkRose-LightRose-White-LightGreen-DarkGreen'); scaleColorMap(cmap, 0);
                
                title({['pc ' num2str(componenti) ' scores - ' num2str(explainedVariance(componenti,1)) '% of explained variance' ]})
                
                outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\pc ' num2str(componenti) '\top loadings images\'];
                mkdir(outputs_path)
                
            case 'nnmf'
                
                mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\'])
                cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\'])
                
                image_component = f_mva_output_collage( W(:,componenti), datacube_cell, outputs_xy_pairs );
                
                spectral_component = H(componenti,:);
                
                imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                
                colormap(viridis); title({['factor ' num2str(componenti) ' image ' ]})
                
                outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\top loadings images\'];
                mkdir(outputs_path)
                
            case 'kmeans'
                
                mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                
                image_component = f_mva_output_collage( logical(idx.*(idx==componenti)), datacube_cell, outputs_xy_pairs );
                
                spectral_component = C(componenti,:);
                
                imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                
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
                
                imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                
                colormap(cmap([1 componenti+1],:)); title({['cluster ' num2str(componenti) ' image ' ]})
                
            case 'tsne'
                
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
                
                spectral_component = 1:sum(datacube_mzvalues_indexes>0);
                
                imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                
                colormap(cmap([1 componenti+1],:)); title({['cluster ' num2str(componenti) ' image ' ]})
                
        end
        
        subplot(1,2,2)
        
        stem(datacube_cell{1}.spectralChannels(datacube_mzvalues_indexes), spectral_component, 'color', [0 0 0] , 'marker', 'none'); xlabel('\it{m/z}'); axis square;
        set(gca, 'LineWidth', 2 );
        set(gca, 'fontsize', 12);
        set(gca, 'Xlim', [min(datacube_cell{1}.spectralChannels(datacube_mzvalues_indexes)) max(datacube_cell{1}.spectralChannels(datacube_mzvalues_indexes))])
        set(gca, 'Ylim', [min(spectral_component).*1.1 max(spectral_component).*1.1])
        
        switch mva_type
            
            case 'pca'
                
                title({['PC ' num2str(componenti) ' (exp. var. ' num2str(round(explainedVariance(componenti,1),2)) '%) loadings' ]})
                
                figname_char = [ 'pc ' num2str(componenti) ' scores and loadings.fig'];
                tifname_char = [ 'pc ' num2str(componenti) ' scores and loadings.tif'];
                svgname_char = [ 'pc ' num2str(componenti) ' scores and loadings.svg'];
                
            case 'nnmf'
                
                title({['Factor ' num2str(componenti) ' spectrum' ]})
                
                figname_char = [ 'factor ' num2str(componenti) ' image and spectrum.fig'];
                tifname_char = [ 'factor ' num2str(componenti) ' image and spectrum.tif'];
                svgname_char = [ 'factor ' num2str(componenti) ' image and spectrum.svg'];
                
            case 'kmeans'
                
                title({['Cluster ' num2str(componenti) ' spectrum' ]})
                
                figname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.fig'];
                tifname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.tif'];
                svgname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.svg'];
                
            case 'nntsne'
                
                title({['Cluster ' num2str(componenti) ' spectrum' ]})
                
                figname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.fig'];
                tifname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.tif'];
                svgname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.svg'];
                
            case 'tsne'
                
                title({['Cluster ' num2str(componenti) ' spectrum' ]})
                
                figname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.fig'];
                tifname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.tif'];
                svgname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.svg'];
                
        end
        
        savefig(fig,figname_char,'compact')
        saveas(fig,tifname_char)
        saveas(fig,svgname_char)
        
        close all
        clear fig
        
        if 1<0 % ~strcmpi(main_mask,"no mask")
            
            % saving single ion images of the highest loadings
            
            [ ~, mz_indexes ] = sort(abs(spectral_component),'descend');
            
            mva_mzvalues        = datacube_cell{1}.spectralChannels(datacube_mzvalues_indexes);
            mini_mzvalues       = mva_mzvalues(mz_indexes(1:numLoadings));
            
            mva_peakDetails     = datacubeonly_peakDetails(datacube_mzvalues_indexes,:);
            mini_peak_details   = mva_peakDetails(mz_indexes(1:numLoadings),:); % Peak details need to be sorted in the intended way (e.g, highest loading peaks first)! Sii will be saved based on it.
            
            all_mzvalues        = double(hmdb_sample_info(:,4));
            
            load([ spectra_details_path filesToProcess(1).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_mzvalues' ])
            
            th_mz_diff          = min(diff(totalSpectrum_mzvalues));
            
            mini_mzvalues_aux   = repmat(mini_mzvalues,1,size(all_mzvalues,1));
            all_mzvalues_aux    = repmat(all_mzvalues',size(mini_mzvalues,1),1);
            
            mini_sample_info    = hmdb_sample_info(logical(sum(abs(mini_mzvalues_aux-all_mzvalues_aux)<th_mz_diff,1))',:);
            
            aux_string1 = "not assigned";
            aux_string2 = "NA";
            
            aux_string_left     = repmat([ aux_string1 aux_string2 aux_string2 ],1,1);
            aux_string_right    = repmat([ aux_string2 aux_string2 aux_string1 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 ],1,1);
            
            ii = 0;
            mini_sample_info_indexes = [];
            for mzi = mini_mzvalues'
                ii = ii + 1;
                if sum(abs(mzi-double(mini_sample_info(:,4)))<th_mz_diff,1)
                    mini_sample_info_indexes = [
                        mini_sample_info_indexes
                        find(abs(mzi-double(mini_sample_info(:,4)))<th_mz_diff,1,'first')
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
                    [ repmat([ string(componenti) string(ii) ],length(find(abs(mzi-double(mini_sample_info(:,4)))<th_mz_diff)),1) mini_sample_info(logical(abs(mzi-double(mini_sample_info(:,4)))<th_mz_diff),[1 12 2 4 3 8 11 14:size(mini_sample_info,2)]) ]
                    ];
            end
            
            mini_ion_images_cell = {};
            
            for file_index = 1:length(datacube_cell)
                
                mva_ion_images = f_norm_datacube_v2( datacube_cell{file_index}, main_mask_cell{file_index}, norm_type );
                mva_ion_images = mva_ion_images(:,datacube_mzvalues_indexes);
                
                mini_ion_images_cell{file_index}.data = mva_ion_images(:,mz_indexes(1:numLoadings));
                mini_ion_images_cell{file_index}.width = datacube_cell{file_index}.width;
                mini_ion_images_cell{file_index}.height = datacube_cell{file_index}.height;
                
            end
            
            % figures generation and saving
            
            f_saving_sii_files_ca( ...
                outputs_path, ...
                smaller_masks_list, ...
                outputs_xy_pairs, ...
                mini_sample_info, mini_sample_info_indexes, ...
                mini_ion_images_cell, smaller_masks_cell, ...
                mini_peak_details, ...
                meanSpectrum_intensities, meanSpectrum_mzvalues, ...
                fig_ppmTolerance, 1 )
            
        end
        
    end
    
    % saving table with the top loading information
    
    if (strcmpi(mva_type,'nntsne') && isnan(o_numComponents)) || (strcmpi(mva_type,'tsne') && isnan(o_numComponents))
        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
    else
        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
    end
    
    save('top_loadings_info','table')
    
    txt_row = strcat(repmat('%s\t',1,size(table,2)-1),'%s\n');
    
    fileID = fopen('top_loadings_info.txt','w');
    fprintf(fileID,txt_row, table');
    fclose(fileID);
    
    % curating the top loadings info table and saving it
    
    curated_table = f_saving_curated_top_loadings_info( table, relevant_lists_sample_info );
    
    save('top_loadings_info_curated_1','curated_table')
    
    txt_row = strcat(repmat('%s\t',1,size(curated_table,2)-1),'%s\n');
    
    fileID = fopen('top_loadings_info_curated_1.txt','w');
    fprintf(fileID,txt_row, curated_table');
    fclose(fileID);
    
end
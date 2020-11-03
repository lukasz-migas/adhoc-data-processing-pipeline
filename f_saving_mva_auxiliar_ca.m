function f_saving_mva_auxiliar_ca( paths, plots_info, data_cell )

mva_path = paths.mva_path;
dataset_name = paths.dataset_name;
main_mask = paths.main_mask;
mva_type = paths.mva_type;
numComponents = paths.numComponents;
norm_type = paths.norm_type;
spectra_details_path = paths.spectra_details_path;

filesToProcess = plots_info.filesToProcess;
datacubeonly_peakDetails = plots_info.datacubeonly_peakDetails;
smaller_masks_list = plots_info.smaller_masks_list;
smaller_masks_cell = plots_info.smaller_masks_cell;
outputs_xy_pairs = plots_info.outputs_xy_pairs;
numLoadings = plots_info.numLoadings;
hmdb_sample_info = plots_info.hmdb_sample_info;
relevant_lists_sample_info = plots_info.relevant_lists_sample_info;
meanSpectrum_intensities = plots_info.meanSpectrum_intensities;
meanSpectrum_mzvalues = plots_info.meanSpectrum_mzvalues;
fig_ppmTolerance = plots_info.fig_ppmTolerance;

if numComponents > 0
    
    path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'];
    
elseif isnan(numComponents)
    
    path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'];
    
elseif numComponents < 0
    
    path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' manual\' char(norm_type) '\'];
    
end

mkdir(path)
cd(path)

load('datacube_mzvalues_indexes')

o_numComponents = NaN;

if sum(datacube_mzvalues_indexes) > 0
    
    % Loading MVA results
    
    switch mva_type
        
        case 'pca'
            
            load('datacube_mzvalues_indexes')
            load('firstCoeffs')
            load('firstScores')
            load('explainedVariance')
            
            numComponentsSaved = size(firstCoeffs,2);
            o_numComponents = numComponents;
            numComponents = numComponentsSaved;
            
        case 'rica'
            
            load('z')
            load('model')
            
            numComponentsSaved = size(z,2);
            o_numComponents = numComponents;
            
        case 'nnmf'
            
            load('datacube_mzvalues_indexes')
            load('W')
            load('H')
            
            numComponentsSaved = size(W,2);
            o_numComponents = numComponents;
            
        case 'kmeans'
            
            load('datacube_mzvalues_indexes')
            load('C')
            load('idx')
            
            numComponentsSaved = max(idx);
            o_numComponents = numComponents;
            numComponents = numComponentsSaved;
            
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
            
        case 'fdc'
            
            load('datacube_mzvalues_indexes')
            load('C')
            load('idx')
            load('rho')
            load('delta')
            load('centInd')
            
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
                
                if isequal(char(mva_type),'kmeans') || isequal(char(mva_type),'fdc')
                    
                    if isnan(o_numComponents)
                        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
                    elseif o_numComponents>0
                        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                    elseif o_numComponents<0
                        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' manual\' char(norm_type) '\'])
                    end
                    
                    fig0 = figure('units','normalized','outerposition',[0 0 .7 .7]); % set(gcf,'Visible', 'off');
                    
                    if numComponents <= 10
                        clustmap = [ 0 0 0; tab10(numComponents) ];
                    elseif numComponents <= 20
                        clustmap = [ 0 0 0; tab20(numComponents) ];
                    elseif numComponents <= 40
                        clustmap = [ 0 0 0; f_40colourscheme(numComponents) ];
                    else
                        clustmap = [ 0 0 0; viridis(numComponents) ];
                    end
                                        
                    image_component = f_mva_output_collage( idx, data_cell, outputs_xy_pairs );
                    
                    imagesc(image_component)
                    colormap(clustmap)
                    axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                    title({['Segmentation - ' num2str(numComponents)  ' clusters']})
                    
                    figname_char = 'all clusters image.fig'; savefig(fig0,figname_char,'compact')
                    tifname_char = 'all clusters image.tif'; saveas(fig0,tifname_char)
                    svgname_char = 'all clusters image.svg'; saveas(fig0,svgname_char)
                    
                    close all
                    clear fig0
                    
                    [ clusters_table, distributionsM ] = f_mva_output_table( idx, data_cell );
                    
                    txt_row = strcat(repmat('%s\t',1,size(clusters_table,2)-1),'%s\n');
                    
                    fileID = fopen('clusters_table.txt','w');
                    fprintf(fileID,txt_row, clusters_table');
                    fclose(fileID);
                    
                    % Clusters versus ROIs
                    
                    % Image / table
                    
                    fig00 = figure('units','normalized','outerposition',[0 0 .7 .7]);
                    image2plot00 = double(clusters_table(2:end-1,2:end));
                    imagesc([image2plot00 zeros(size(image2plot00,1),1)]);
                    colormap(clustmap)
                    axis image; axis off;colorbar; set(gca, 'fontsize', 12);
                    text(-1, size(image2plot00,1)/2, 'Cluster ID', 'rotation', 90, 'HorizontalAlignment', 'center')
                    text(size(image2plot00,2)/2-1,size(image2plot00,1)+2,'Sample ID', 'HorizontalAlignment', 'center')
                    
                    hold on;
                    rows = size(image2plot00,1);
                    columns = size(image2plot00,2);
                    for row = 0.5 : rows+1
                        line([0, columns+1], [row, row], 'Color', 'k');
                    end
                    for col = 0.5 : columns+1
                        line([col, col], [0, rows+1], 'Color', 'k');
                    end
                    xlabeli = 0;
                    for mask_name = clusters_table(1,2:end)
                        xlabeli = xlabeli+1;
                        text(xlabeli,0, char(mask_name),'rotation',90)
                    end
                    
                    figname_char = 'clusters vs samples.fig'; savefig(fig00,figname_char,'compact')
                    tifname_char = 'clusters vs samples.tif'; saveas(fig00,tifname_char)
                    
                    save('distributionsM','distributionsM')
                    
                    % Scatter plot
                    
                    % Percentage of occupancy
                    
                    kpercentage = zeros(length(unique(distributionsM(~isnan(distributionsM)))'),size(distributionsM,2));
                    for k = unique(distributionsM(~isnan(distributionsM)))'
                        kpercentage(k,:) = sum(distributionsM == k,1)./sum(~isnan(distributionsM),1);
                    end
                    
                    % Plotting
                    
                    x = repmat(1:size(kpercentage,2),size(kpercentage,1),1); x = x(:);
                    y = repmat((1:size(kpercentage,1))',1,size(kpercentage,2)); y = y(:);
                    sz = kpercentage; sz = sz(:).*5000;
                    c = repmat(clustmap(2:end,:),size(kpercentage,2),1);
                    
                    fig0000 = figure('units','normalized','outerposition',[0 0 .7 .7]);
                    hold on;
                    stem([0:size(kpercentage,2)+1]-0.5,size(kpercentage,2)*ones(1,size(kpercentage,2)+2),'w')
                    plot(0:size(kpercentage,2)+1,repmat([1:size(kpercentage,1)+1]'-0.5,1,size(0:size(kpercentage,2)+1,2)),'w')
                    scatter(x(sz>0),y(sz>0),sz(sz>0),c(sz>0,:),'Marker','.');
                    set(gca,'Color','k')
                    set(gca,'XColor','k','YColor','k','TickDir','out')
                    axis image;
                    ylim([0.5 size(kpercentage,1)+0.5]);
                    xticks(1:size(kpercentage,1))
                    xlim([0.5 size(kpercentage,2)+0.5]);
                    xticks(1:size(kpercentage,2))
                    for i = 1:(size(clusters_table,2)-1); aux_xticklabels{i} = char(clusters_table(1,i+1)); end
                    xticklabels(aux_xticklabels)
                    xtickangle(90)
                    set(gca, 'fontsize', 12)
                    
                    figname_char = 'clusters vs samples bubbles.fig'; savefig(fig0000,figname_char,'compact')
                    tifname_char = 'clusters vs samples bubbles.tif'; saveas(fig0000,tifname_char)
                    
                    if isequal(char(mva_type),'fdc')
                       
                        fig000 = figure;
                        plot(rho, delta, 'o', 'MarkerSize', 7, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'w');
                        title('Decision Graph', 'FontSize', 12);
                        xlabel('\rho');
                        ylabel('\delta');
                        hold on;
                        for k = 1:numComponents                   
                            plot(rho(centInd==k), delta(centInd==k), 'o', 'MarkerSize', 9, 'MarkerFaceColor', clustmap(k+1,:), 'MarkerEdgeColor', 'w'); axis square; grid on;
                        end
                        title('Decision Graph', 'FontSize', 11);
                        savefig(fig000,'coloured_decision_graph.fig','compact')
                        saveas(fig000,'coloured_decision_graph.tif','tif')
                        close(fig000)
                        
                    end
                                        
                elseif isequal(char(mva_type),'nntsne') || isequal(char(mva_type),'tsne')
                    
                    if isnan(o_numComponents)
                        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
                    elseif o_numComponents>0
                        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                    elseif o_numComponents<0
                        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' manual\' char(norm_type) '\'])
                    end
                    
                    fig0 = figure('units','normalized','outerposition',[0 0 .7 .7]); % set(gcf,'Visible', 'off');
                    
                    image_component = f_mva_output_collage( idx, data_cell, outputs_xy_pairs );
                    rgb_image_component = zeros(size(image_component,1),size(image_component,2),size(rgbData,2));
                    for ci = 1:size(rgbData,2); aux_rgbData = 0*idx; aux_rgbData(idx>0) = rgbData(:,ci); rgb_image_component(:,:,ci) = f_mva_output_collage( aux_rgbData, data_cell, outputs_xy_pairs ); end
                    
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
                    
                    close all
                    clear fig0
                    
                    fig0 = figure('units','normalized','outerposition',[0 0 .7 .7]); % set(gcf,'Visible', 'off');
                    
                    aux_rgb = logical((sum(rgb_image_component,3)==0)+(isnan(sum(rgb_image_component,3))));
                    
                    for ci = 1:3
                        image_component =  rgb_image_component(:,:,ci);
                        image_component(aux_rgb) = 1;
                        rgb_image_component(:,:,ci) = image_component;
                    end
                    
                    subplot(1,2,1)
                    image(rgb_image_component)
                    axis off; axis image; set(gca, 'fontsize', 12);
                    title({'t-sne space colours'})
                    
                    subplot(1,2,2)
                    scatter3(rgbData(:,1),rgbData(:,2),rgbData(:,3),2,rgbData,'filled');
                    title({'t-sne space colours'})
                    
                    figname_char = 'all clusters image - t-sne space colours.fig'; savefig(fig0,figname_char,'compact')
                    tifname_char = 'all clusters image - t-sne space colours.tif'; saveas(fig0,tifname_char)
                    
                    close all
                    clear fig0
                    
                    [ clusters_table, distributionsM ] = f_mva_output_table( idx, data_cell );
                    
                    txt_row = strcat(repmat('%s\t',1,size(clusters_table,2)-1),'%s\n');
                    
                    fileID = fopen('clusters_table.txt','w');
                    fprintf(fileID,txt_row, clusters_table');
                    fclose(fileID);
                    
                    % Clusters versus ROIs
                    
                    % Image / table
                    
                    fig00 = figure('units','normalized','outerposition',[0 0 .7 .7]);
                    image2plot00 = double(clusters_table(2:end-1,2:end));
                    imagesc([image2plot00 zeros(size(image2plot00,1),1)]);
                    colormap(cmap)
                    axis image; axis off; colorbar; set(gca, 'fontsize', 12);
                    text(-1, size(image2plot00,1)/2, 'Cluster ID', 'rotation', 90, 'HorizontalAlignment', 'center')
                    text(size(image2plot00,2)/2-1,size(image2plot00,1)+2,'Sample ID', 'HorizontalAlignment', 'center')
                    
                    hold on;
                    rows = size(image2plot00,1);
                    columns = size(image2plot00,2);
                    for row = 0.5 : rows+1
                        line([0, columns+1], [row, row], 'Color', 'k');
                    end
                    for col = 0.5 : columns+1
                        line([col, col], [0, rows+1], 'Color', 'k');
                    end
                    xlabeli = 0;
                    for mask_name = clusters_table(1,2:end)
                        xlabeli = xlabeli+1;
                        text(xlabeli,0, char(mask_name),'rotation',90)
                    end
                    
                    figname_char = 'clusters vs samples.fig'; savefig(fig00,figname_char,'compact')
                    tifname_char = 'clusters vs samples.tif'; saveas(fig00,tifname_char)
                    
                    save('distributionsM','distributionsM')
                    
                    % Scatter plot
                    
                    % Percentage of occupancy
                    
                    kpercentage = zeros(length(unique(distributionsM(~isnan(distributionsM)))'),size(distributionsM,2));
                    for k = unique(distributionsM(~isnan(distributionsM)))'
                        kpercentage(k,:) = sum(distributionsM == k,1)./sum(~isnan(distributionsM),1);
                    end
                    
                    % Plotting
                    
                    x = repmat(1:size(kpercentage,2),size(kpercentage,1),1); x = x(:);
                    y = repmat((1:size(kpercentage,1))',1,size(kpercentage,2)); y = y(:);
                    sz = kpercentage; sz = sz(:).*5000;
                    c = repmat(cmap(2:end,:),size(kpercentage,2),1);
                    
                    fig0000 = figure('units','normalized','outerposition',[0 0 .7 .7]);
                    hold on;
                    stem([0:size(kpercentage,2)+1]-0.5,size(kpercentage,2)*ones(1,size(kpercentage,2)+2),'w')
                    plot(0:size(kpercentage,2)+1,repmat([1:size(kpercentage,1)+1]'-0.5,1,size(0:size(kpercentage,2)+1,2)),'w')
                    scatter(x(sz>0),y(sz>0),sz(sz>0),c(sz>0,:),'Marker','.');
                    set(gca,'Color','k')
                    set(gca,'XColor','k','YColor','k','TickDir','out')
                    axis image;
                    ylim([0.5 size(kpercentage,1)+0.5]);
                    xticks(1:size(kpercentage,1))
                    xlim([0.5 size(kpercentage,2)+0.5]);
                    xticks(1:size(kpercentage,2))
                    for i = 1:(size(clusters_table,2)-1); aux_xticklabels{i} = char(clusters_table(1,i+1)); end
                    xticklabels(aux_xticklabels)
                    xtickangle(90)
                    set(gca, 'fontsize', 12)
                    
                    figname_char = 'clusters vs samples bubbles.fig'; savefig(fig0000,figname_char,'compact')
                    tifname_char = 'clusters vs samples bubbles.tif'; saveas(fig0000,tifname_char)       
                    
                end
                
            end
            
            fig = figure('units','normalized','outerposition',[0 0 .7 .7]); % set(gcf,'Visible', 'off');
            
            subplot(1,2,1)
            
            switch mva_type
                
                case 'pca'
                    
                    mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\pc ' num2str(componenti) '\'])
                    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\pc ' num2str(componenti) '\'])
                    
                    image_component = f_mva_output_collage( firstScores(:,componenti), data_cell, outputs_xy_pairs );
                    
                    spectral_component = firstCoeffs(:,componenti);
                    
                    imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                    
                    cmap = makePCAcolormap_tm('DarkRose-LightRose-White-LightGreen-DarkGreen'); scaleColorMap(cmap, 0);
                    
                    title({['pc ' num2str(componenti) ' scores - ' num2str(explainedVariance(componenti,1)) '% of explained variance' ]})
                    
                    outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\pc ' num2str(componenti) '\top loadings images\'];
                    mkdir(outputs_path)
                    
                case 'rica'
                    
                    mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\ic ' num2str(componenti) '\'])
                    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\ic ' num2str(componenti) '\'])
                    
                    image_component = f_mva_output_collage( z(:,componenti), data_cell, outputs_xy_pairs );
                    
                    spectral_component = model.TransformWeights(:,componenti);
                    
                    imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                    
                    cmap = makePCAcolormap_tm('DarkRose-LightRose-White-LightGreen-DarkGreen'); scaleColorMap(cmap, 0);
                    
                    title({['ic ' num2str(componenti) ]})
                    
                    outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\ic ' num2str(componenti) '\top loadings images\'];
                    mkdir(outputs_path)
                    
                case 'nnmf'
                    
                    mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\'])
                    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\'])
                    
                    image_component = f_mva_output_collage( W(:,componenti), data_cell, outputs_xy_pairs );
                    
                    spectral_component = H(componenti,:);
                    
                    imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                    
                    colormap(viridis); title({['factor ' num2str(componenti) ' image ' ]})
                    
                    outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\top loadings images\'];
                    mkdir(outputs_path)
                    
                case 'kmeans'
                    
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
                    
                    image_component = f_mva_output_collage( logical(idx.*(idx==componenti)), data_cell, outputs_xy_pairs );
                    
                    spectral_component = C(componenti,:);
                    
                    imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                    
                    colormap(clustmap([1 componenti+1],:)); title({['cluster ' num2str(componenti) ' image ' ]})
                    
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
                    
                    image_component = f_mva_output_collage( logical(idx.*(idx==componenti)), data_cell, outputs_xy_pairs );
                    
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
                    
                    image_component = f_mva_output_collage( logical(idx.*(idx==componenti)), data_cell, outputs_xy_pairs );
                    
                    spectral_component = 1:sum(datacube_mzvalues_indexes>0);
                    
                    imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                    
                    colormap(cmap([1 componenti+1],:)); title({['cluster ' num2str(componenti) ' image ' ]})
                    
                case 'fdc'
                    
                    if isnan(o_numComponents)
                        mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                        outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\cluster ' num2str(componenti) '\top loadings images\'];
                        mkdir(outputs_path)
                    elseif o_numComponents>0
                        mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                        outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\top loadings images\'];
                        mkdir(outputs_path)
                    elseif o_numComponents<0
                        mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' manual\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                        cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' manual\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                        outputs_path = [ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' manual\' char(norm_type) '\cluster ' num2str(componenti) '\top loadings images\'];
                        mkdir(outputs_path)
                    end
                    
                    image_component = f_mva_output_collage( logical(idx.*(idx==componenti)), data_cell, outputs_xy_pairs );
                    
                    spectral_component = C(componenti,:);
                    
                    imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                    
                    colormap(clustmap([1 componenti+1],:)); title({['cluster ' num2str(componenti) ' image ' ]})
                    
            end
            
            subplot(1,2,2)
            
            stem(datacubeonly_peakDetails(datacube_mzvalues_indexes,2), spectral_component, 'color', [0 0 0] , 'marker', 'none'); xlabel('\it{m/z}'); axis square;
            set(gca, 'LineWidth', 2 );
            set(gca, 'fontsize', 12);
            set(gca, 'Xlim', [min(datacubeonly_peakDetails(datacube_mzvalues_indexes,2)) max(datacubeonly_peakDetails(datacube_mzvalues_indexes,2))])
            set(gca, 'Ylim', [min(spectral_component).*1.1 max(spectral_component).*1.1])
            
            switch mva_type
                
                case 'pca'
                    
                    title({['PC ' num2str(componenti) ' (exp. var. ' num2str(round(explainedVariance(componenti,1),2)) '%) loadings' ]})
                    
                    figname_char = [ 'pc ' num2str(componenti) ' scores and loadings.fig'];
                    tifname_char = [ 'pc ' num2str(componenti) ' scores and loadings.tif'];
                    svgname_char = [ 'pc ' num2str(componenti) ' scores and loadings.svg'];
                    
                case 'rica'
                    
                    title({['IC ' num2str(componenti) ' weights' ]})
                    
                    figname_char = [ 'ic ' num2str(componenti) ' transformation and weights.fig'];
                    tifname_char = [ 'ic ' num2str(componenti) ' transformation and weights.tif'];
                    svgname_char = [ 'ic ' num2str(componenti) ' transformation and weights.svg'];
                    
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
                    
                case 'fdc'
                    
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
            
            if ~strcmpi(main_mask,'no mask') && ~strcmpi(mva_type,'tsne')
                
                % saving single ion images of the highest loadings
                
                [ ~, mz_indexes ] = sort(abs(spectral_component),'descend');
                
                if numLoadings <= length(mz_indexes)
                    
                    mva_mzvalues        = datacubeonly_peakDetails(datacube_mzvalues_indexes,2);
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
                    aux_string_right    = repmat([ aux_string2 aux_string2 aux_string1 repmat(aux_string2, 1, size(mini_sample_info,2)-7) ],1,1);
                    
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
                    
                    mini_data_cell = data_cell;
                    
                    for file_index = 1:length(data_cell)
                        
                        mva_ion_images = data_cell{file_index}.data(:,datacube_mzvalues_indexes);
                        mini_data_cell{file_index}.data = mva_ion_images(:,mz_indexes(1:numLoadings));
                        
                    end
                    
                    % figures generation and saving
                    
                    f_saving_sii_files_ca( ...
                        outputs_path, ...
                        smaller_masks_list, ...
                        outputs_xy_pairs, ...
                        mini_sample_info, mini_sample_info_indexes, ...
                        mini_data_cell, ...
                        mini_peak_details, ...
                        meanSpectrum_intensities, meanSpectrum_mzvalues, ...
                        fig_ppmTolerance, 1 )
                    
                else
                    
                    disp('!!! The number of loadings is higher than the number of peaks used to run the mva.')
                    
                end
                
            end
            
        end
        
        % saving table with the top loading information
        
        if isnan(o_numComponents)
            cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
        elseif o_numComponents>0
            cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
        elseif o_numComponents<0
            cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' manual\' char(norm_type) '\'])
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
    
end
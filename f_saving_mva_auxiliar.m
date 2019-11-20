function f_saving_mva_auxiliar( file_name, main_mask, mva_type, mva_path, norm_type, numComponents, numLoadings, datacube, datacubeonly_peakDetails, mask, hmdb_sample_info, totalSpectrum_intensities, totalSpectrum_mzvalues, pixels_num, fig_ppmTolerance)

if ~isnan(numComponents)
    
    mkdir([ mva_path char(file_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
    cd([ mva_path char(file_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
    
else
    
    mkdir([ mva_path char(file_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
    cd([ mva_path char(file_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
    
end

load('datacube_mzvalues_indexes')

% Loading MVA results

o_numComponents = NaN;

switch mva_type
    
    case 'pca'
        
        load('firstCoeffs')
        load('firstScores')
        load('explainedVariance')
        
        numComponentsSaved = size(firstCoeffs,2);
        
    case 'nnmf'
        
        load('W')
        load('H')
        
        numComponentsSaved = size(W,2);
        
        
    case 'kmeans'
        
        load('C')
        load('idx')
        
        numComponentsSaved = size(C,1);
        
    case 'nntsne'
        
        load('idx')
        load('cmap')
        load('rgbData')
        load('outputSpectralContriubtion')
        
        numComponentsSaved = max(idx);
        o_numComponents = numComponents;
        numComponents = numComponentsSaved;
        
    case 'tsne'
        
        load('idx')
        load('cmap')
        load('rgbData')
        
        numComponentsSaved = max(idx);
        o_numComponents = numComponents;
        numComponents = numComponentsSaved;
        
end

if numComponents > numComponentsSaved
    disp('!!! ERROR !!! The currently saved MVA results do not comprise all the information you want to look at! Please run the function f_running_mva again.')
    return
else
    
    for componenti = 1:numComponents
        
        if ( componenti == 1 ) && ( (isequal(char(mva_type),'kmeans')) || (isequal(char(mva_type),'nntsne')) || isequal(char(mva_type),'tsne') )
            
            fig0 = figure('units','normalized','outerposition',[0 0 .7 .7]); % set(gcf,'Visible', 'off');
            jFrame = get(handle(fig0), 'JavaFrame');
            jFrame.setMinimized(1);
            
            if isequal(char(mva_type),'kmeans')
                
                image_component = reshape(idx,datacube.width,datacube.height)';
                imagesc(image_component);
                clustmap = f_full_colourscheme(numComponents);
                if min(min(image_component)) == 1
                    colormap(clustmap(2:numComponents+1,:)./255)
                else
                    colormap(clustmap./255)
                end
                axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                
                title({'all clusters image'})
                
            elseif isequal(char(mva_type),'nntsne') || isequal(char(mva_type),'tsne')
                
                image_component = reshape(idx,datacube.width,datacube.height)';
                rgb_image_component = zeros(size(image_component,1),size(image_component,2),size(rgbData,2));
                for ci = 1:size(rgbData,2); aux_rgbData = 0*idx; aux_rgbData(idx>0) = rgbData(:,ci); rgb_image_component(:,:,ci) = reshape(aux_rgbData,datacube.width,datacube.height)'; end
                
                subplot(2,2,[1 3])
                image(rgb_image_component)
                axis off; axis image; set(gca, 'fontsize', 12);
                title({'t-sne space colours'})
                
                subplot(2,2,2)
                imagesc(image_component)
                colormap(cmap((min(idx)+1):end,:))
                axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                title({['t-sne space segmentation - ' num2str(numComponents)  ' clusters']})
                
                scatter3_colour_vector = []; for cii = max(min(idx),1):max(idx); scatter3_colour_vector(idx(idx>0)==cii,1:3) = repmat(cmap(cii+1,:),sum(idx(idx>0)==cii),1); end
                
                subplot(2,2,4)
                scatter3(rgbData(:,1),rgbData(:,2),rgbData(:,3),1,scatter3_colour_vector); colorbar;
                title({'t-sne space'})
                
            end
            
            figname_char = 'all clusters image.fig'; savefig(fig0,figname_char,'compact')
            tifname_char = 'all clusters image.tif'; saveas(fig0,tifname_char)
            
            close all
            clear fig0
            
        end
        
        fig = figure('units','normalized','outerposition',[0 0 .7 .7]); % set(gcf,'Visible', 'off');
        jFrame = get(handle(fig), 'JavaFrame');
        jFrame.setMinimized(1);
        
        subplot(1,2,1)
        
        switch mva_type
            
            case 'pca'
                
                mkdir([ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\pc ' num2str(componenti) '\'])
                cd([ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\pc ' num2str(componenti) '\'])
                
                image_component = reshape(firstScores(:,componenti),datacube.width,datacube.height)';
                
                spectral_component = firstCoeffs(:,componenti);
                
                imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                
                cmap = makePCAcolormap_tm('DarkRose-LightRose-White-LightGreen-DarkGreen'); scaleColorMap(cmap, 0);
                
                title({['pc ' num2str(componenti) ' scores - ' num2str(explainedVariance(componenti,1)) '% of explained variance' ]})
                
                outputs_path = [ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\pc ' num2str(componenti) '\top loadings images\']; mkdir(outputs_path)
                
            case 'nnmf'
                
                mkdir([ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\'])
                cd([ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\'])
                
                image_component = reshape(W(:,componenti),datacube.width,datacube.height)';
                
                spectral_component = H(componenti,:);
                
                imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                
                colormap(viridis); title({['factor ' num2str(componenti) ' image ' ]})
                
                outputs_path = [ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\top loadings images\']; mkdir(outputs_path)
                
            case 'kmeans'
                
                mkdir([ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                cd([ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                
                image_component = reshape(logical(idx.*(idx==componenti)),datacube.width,datacube.height)';
                
                spectral_component = C(componenti,:);
                
                imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                
                colormap(viridis); title({['cluster ' num2str(componenti) ' image ' ]})
                
                outputs_path = [ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\top loadings images\']; mkdir(outputs_path)
                
            case 'nntsne'
                
                if isnan(o_numComponents)
                    mkdir([ mva_path file_name '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                    cd([ mva_path file_name '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                    outputs_path = [ mva_path file_name '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\cluster ' num2str(componenti) '\top loadings images\'];
                    mkdir(outputs_path)
                else
                    mkdir([ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                    cd([ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                    outputs_path = [ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\top loadings images\'];
                    mkdir(outputs_path)
                end
                
                image_component = reshape(logical(idx.*(idx==componenti)),datacube.width,datacube.height)';
                
                spectral_component = outputSpectralContriubtion{1,componenti}';
                
                imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                
                colormap(cmap([1 componenti+1],:)); title({['cluster ' num2str(componenti) ' image ' ]})
                
            case 'tsne'
                
                if isnan(o_numComponents)
                    mkdir([ mva_path file_name '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                    cd([ mva_path file_name '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                    outputs_path = [ mva_path file_name '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\cluster ' num2str(componenti) '\top loadings images\'];
                    mkdir(outputs_path)
                else
                    mkdir([ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                    cd([ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\'])
                    outputs_path = [ mva_path file_name '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\cluster ' num2str(componenti) '\top loadings images\'];
                    mkdir(outputs_path)
                end
                
                image_component = reshape(logical(idx.*(idx==componenti)),datacube.width,datacube.height)';
                
                spectral_component = 1:sum(datacube_mzvalues_indexes>0);
                
                imagesc(image_component); axis off; axis image; colorbar; set(gca, 'fontsize', 12);
                
                colormap(cmap([1 componenti+1],:)); title({['cluster ' num2str(componenti) ' image ' ]})
                
        end
        
        subplot(1,2,2)
        
        stem(datacube.spectralChannels(datacube_mzvalues_indexes), spectral_component, 'color', [0 0 0] , 'marker', 'none'); xlabel('\it{m/z}'); axis square;
        set(gca, 'LineWidth', 2 );
        set(gca, 'fontsize', 12);
        set(gca, 'Xlim', [min(datacube.spectralChannels(datacube_mzvalues_indexes)) max(datacube.spectralChannels(datacube_mzvalues_indexes))])
        set(gca, 'Ylim', [min(spectral_component).*1.1 max(spectral_component).*1.1])
        
        switch mva_type
            
            case 'pca'
                
                title({['PC ' num2str(componenti) ' loadings' ]})
                
                figname_char = [ 'pc ' num2str(componenti) ' scores and loadings.fig'];
                tifname_char = [ 'pc ' num2str(componenti) ' scores and loadings.tif'];
                
            case 'nnmf'
                
                title({['Factor ' num2str(componenti) ' spectra' ]})
                
                figname_char = [ 'factor ' num2str(componenti) ' image and spectra.fig'];
                tifname_char = [ 'factor ' num2str(componenti) ' image and spectra.tif'];
                
            case 'kmeans'
                
                title({['Cluster ' num2str(componenti) ' spectra' ]})
                
                figname_char = [ 'cluster ' num2str(componenti) ' image and spectra.fig'];
                tifname_char = [ 'cluster ' num2str(componenti) ' image and spectra.tif'];
                
            case 'nntsne'
                
                title({['Cluster ' num2str(componenti) ' spectrum' ]})
                
                figname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.fig'];
                tifname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.tif'];
                
            case 'tsne'
                
                title({'Spectral Component is not available.'})
                
                figname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.fig'];
                tifname_char = [ 'cluster ' num2str(componenti) ' image and spectrum.tif'];
                
        end
        
        savefig(fig,figname_char,'compact')
        saveas(fig,tifname_char)
        
        close all
        clear fig
        
        if ~strcmpi(main_mask,'no mask') && ~strcmpi(mva_type,'tsne')
            
            % saving single ion images of the highest loadings
            
            [ ~, mz_indexes ] = sort(abs(spectral_component),'descend');
            
            mva_mzvalues        = datacube.spectralChannels(datacube_mzvalues_indexes);
            mva_ion_images      = f_norm_datacube_v2( datacube, mask, norm_type );
            mva_ion_images      = mva_ion_images(:,datacube_mzvalues_indexes);
            mva_peakDetails     = datacubeonly_peakDetails(datacube_mzvalues_indexes,:);
            
            mini_mzvalues       = mva_mzvalues(mz_indexes(1:numLoadings));
            mini_ion_images     = mva_ion_images(:,mz_indexes(1:numLoadings));
            mini_peakDetails    = mva_peakDetails(mz_indexes(1:numLoadings),:); % Peak details need to be sorted in the intended way (e.g, highest loading peaks first)! Sii will be saved based on it.
            
            all_mzvalues        = double(hmdb_sample_info(:,4));
            
            th_mz_diff          = min(diff(totalSpectrum_mzvalues));
            
            mini_mzvalues_aux   = repmat(mini_mzvalues,1,size(all_mzvalues,1));
            all_mzvalues_aux    = repmat(all_mzvalues',size(mini_mzvalues,1),1);
            
            mini_sample_info    = hmdb_sample_info(logical(sum(abs(mini_mzvalues_aux-all_mzvalues_aux)<th_mz_diff,1))',:);
            
            aux_string1 = "not assigned";
            aux_string2 = "NA";
            
            aux_string_left     = repmat([ aux_string1 aux_string2 aux_string2 ],1,1);
            aux_string_right    = repmat([ aux_string2 aux_string2 aux_string1 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 aux_string2 ],1,1);
            
            mini_sample_info_indexes = [];
            for mzi = mini_mzvalues'
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
            end
            
            % figures generation and saving
            
            f_saving_sii_files( outputs_path, mini_sample_info, mini_sample_info_indexes, mini_ion_images, datacube.width, datacube.height, mini_peakDetails, pixels_num, totalSpectrum_intensities, totalSpectrum_mzvalues, fig_ppmTolerance, 1 )
            
        end
    end
end
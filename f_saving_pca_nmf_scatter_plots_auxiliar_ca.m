function f_saving_pca_nmf_scatter_plots_auxiliar_ca( mva_type, mva_path, dataset_name, main_mask, norm_type, numComponents, datacube_cell, smaller_masks_colours )

if ~isnan(numComponents)
    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
else
    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
end

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
            
            %         case 'nnmf'
            %
            %             load('datacube_mzvalues_indexes')
            %             load('W')
            %             load('H')
            %
            %             numComponentsSaved = size(W,2);
            %             o_numComponents = numComponents;
            
    end
    
    if numComponents > numComponentsSaved
        disp('!!! Error - The currently saved MVA results do not comprise all the information you want to look at! Please run the function f_running_mva again.')
        return
    else
        
        first_componenet_read = 1;
        
        for componenti = 1:numComponents
            
            switch mva_type
                
                case 'pca'
                    
                    component_by_file = f_pca_nmf_scatter_plots_colouring( firstScores(:,componenti), datacube_cell );
                    
                    if first_componenet_read
                        component2plot = NaN*ones(size(component_by_file,1),size(component_by_file,2),numComponents);
                        first_componenet_read = 0;
                    end
                    
                    component2plot(:,:,componenti) = component_by_file;
                    
                    %                 case 'nnmf'
                    %
                    %                     mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\'])
                    %                     cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\factor ' num2str(componenti) '\'])
                    
            end
            
        end
        
        dot_size = [];
        
        component_x = 1;
        component_y = 2;
        component_z = 3;
        
        x = [];
        y = [];
        z = [];
        c = [];
        for file_index = 1:size(component2plot,2)
            x = [ x; component2plot(:,file_index,component_x) ];
            y = [ y; component2plot(:,file_index,component_y) ];
            z = [ z; component2plot(:,file_index,component_z) ];
            c = [ c; repmat(smaller_masks_colours(file_index,1:3),size(component2plot,1),1) ];
        end
        
        fig = figure('units','normalized','outerposition',[0 0 .7 .7]); % set(gcf,'Visible', 'off');
        scatter3(x,y,z,dot_size,c,'.');
        xlabel(['Principal Component ' num2str(component_x)])
        ylabel(['Principal Component ' num2str(component_y)])
        zlabel(['Principal Component ' num2str(component_z)])
        figname_char = '3D PCs plot.fig';
        tifname_char = '3D PCs plot.tif';
        savefig(fig,figname_char,'compact')
        saveas(fig,tifname_char)
        clear fig
        
        fig = figure('units','normalized','outerposition',[0 0 .7 .7]); % set(gcf,'Visible', 'off');
        subplot(1,3,1)
        scatter(x,y,dot_size,c,'.'); grid on; axis image;
        xlabel(['Principal Component ' num2str(component_x)])
        ylabel(['Principal Component ' num2str(component_y)])
        
        subplot(1,3,2)
        scatter(x,z,dot_size,c,'.'); grid on; axis image;
        xlabel(['Principal Component ' num2str(component_x)])
        ylabel(['Principal Component ' num2str(component_z)])
        
        subplot(1,3,3)
        scatter(y,z,dot_size,c,'.'); grid on; axis image;
        xlabel(['Principal Component ' num2str(component_y)])
        ylabel(['Principal Component ' num2str(component_z)])
        figname_char = '2D PCs plot.fig';
        tifname_char = '2D PCs plot.tif';
        savefig(fig,figname_char,'compact')
        saveas(fig,tifname_char)
        close all
        
    end
    
end
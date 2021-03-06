function f_saving_sii_ratio_files_ca( ...
    outputs_path, ...
    smaller_masks_list, ...
    outputs_xy_pairs, ...
    sample_info_1, sample_info_indexes_1, norm_sii_cell_1, smaller_masks_cell, peak_details_1, ...
    sample_info_2, sample_info_indexes_2, norm_sii_cell_2, peak_details_2, ...
    pixels_num_cell, ...
    totalSpectrum_intensities_cell, totalSpectrum_mzvalues_cell, ...
    fig_ppmTolerance )

for ratio_i = unique(intersect(double(sample_info_1(:,end)),double(sample_info_2(:,end))))'
    
    for peak_1_i = find(peak_details_1(:,end)==ratio_i)'
        for peak_2_i = find(peak_details_2(:,end)==ratio_i)'
            
            cd(outputs_path)
            
            % Sii collage
            
            min_cn = 0;
            min_rn = 0;
            sii_cell2plot = {};
            smaller_masks_list2plot = {};
            
            for file_index = 1:length(norm_sii_cell_1)
                
                norm_sii1_1 = norm_sii_cell_1{file_index}.data(:,peak_1_i).*smaller_masks_cell{file_index}; % normalised sii 1
                norm_sii1_2 = norm_sii_cell_2{file_index}.data(:,peak_2_i).*smaller_masks_cell{file_index}; % normalised ssi 2
                
                ratios = norm_sii1_1./norm_sii1_2; % sii ratio
                ratios(isnan(ratios)) = 0;
                ratios(isinf(ratios)) = 0;
                
                ratios_image = reshape(ratios,norm_sii_cell_1{file_index}.width,norm_sii_cell_1{file_index}.height)';
                
                rows = (sum(ratios_image,2)==0); ratios_image(rows,:) = [];
                cols = (sum(ratios_image,1)==0); ratios_image(:,cols) = [];
                
                sii_cell2plot{outputs_xy_pairs(file_index,1),outputs_xy_pairs(file_index,2)} = ratios_image;
                
                min_cn = max(min_cn,size(ratios_image,2));
                min_rn = max(min_rn,size(ratios_image,1));
                
                if file_index == 1
                    totalSpectrum_mzvalues = totalSpectrum_mzvalues_cell{file_index};
                    totalSpectrum_intensities = totalSpectrum_intensities_cell{file_index};
                    pixels_num = pixels_num_cell{file_index};
                    
                else
                    if (totalSpectrum_mzvalues ~= totalSpectrum_mzvalues_cell{file_index}); disp('! mz axis are not common across datasets !'); end
                    totalSpectrum_intensities = totalSpectrum_intensities + totalSpectrum_intensities_cell{file_index};
                    pixels_num = pixels_num + pixels_num_cell{file_index};
                end
                
                smaller_masks_list2plot{outputs_xy_pairs(file_index,1),outputs_xy_pairs(file_index,2)} = smaller_masks_list{file_index};
                
            end
            
            sii2plot = [];
            
            pi = 0;
            pi1 = 5;
            pi2 = pi1;
            data4boxplots = [];
            boxplots_xlabels = string([]);
            colors2plot = [];
            for ri = 1:size(sii_cell2plot,1)
                
                colors2plot = [ colors2plot; [ ri/size(sii_cell2plot,1) (size(sii_cell2plot,1)-ri)/size(sii_cell2plot,1) 0.5 ] ];
                
                sii2plot3 = [];
                
                for ci = 1:size(sii_cell2plot,2)
                    
                    if ci > 1
                        colors2plot = [ colors2plot; colors2plot(end,:) ];
                    end
                    
                    % Single ion images
                    
                    sii2plot0 = sii_cell2plot{ri,ci};
                    sii2plot1 = [ NaN*ones(size(sii2plot0,1), floor(max(0,(min_cn-size(sii2plot0,2))/2))), sii2plot0, NaN*ones(size(sii2plot0,1), ceil(max(0,(min_cn-size(sii2plot0,2))/2))) ];
                    sii2plot2 = [ NaN*ones(floor(max(0,(min_rn-size(sii2plot1,1))/2)),size(sii2plot1,2)); sii2plot1; NaN*ones(ceil(max(0,(min_rn-size(sii2plot1,1))/2)),size(sii2plot1,2)) ];
                    sii2plot3 = [ sii2plot3 sii2plot2 ];
                    
                    boxplot_data = reshape(sii2plot0,[],1);
                    boxplot_data(boxplot_data==0) = NaN;
                    
                    % Global statistical summaries
                    
                    data4boxplots = [
                        [ data4boxplots;    NaN*ones(max(0,size(boxplot_data,1)-size(data4boxplots,1)),size(data4boxplots,2)) ] [ boxplot_data;     NaN*ones(max(0,size(data4boxplots,1)-size(boxplot_data,1)),1) ]
                        ];
                    
                    pi = pi + 1;
                    
                    if ~isempty(smaller_masks_list2plot{ri,ci})
                        boxplots_xlabels(1,pi) = smaller_masks_list2plot{ri,ci};
                    else
                        boxplots_xlabels(1,pi) = "";
                    end
                    
                end
                
                pi1 = pi1 + 2;
                pi2 = pi2 + 3;
                
                sii2plot = [ sii2plot; sii2plot3 ];
                
            end
            
            % Boxplots figure
            
            fig0 = figure('units','normalized','outerposition',[0 0 .7 .7]);
            
            subplot(1,2,1)
            boxplot(data4boxplots,'Colors',colors2plot,'Notch','on','OutlierSize',2)
            set(findobj(gca,'type','line'),'linew',1.5)
            grid on
            xticks(1:size(data4boxplots,2))
            xticklabels(boxplots_xlabels)
            xtickangle(45)
            ylabel('ion counts')
            
            subplot(1,2,2)
            boxplot(data4boxplots,'Colors',colors2plot,'Notch','on','OutlierSize',2)
            set(findobj(gca,'type','line'),'linew',1.5)
            grid on
            for texti = 1:size(data4boxplots,2); text(texti, 1.1*nanmedian(data4boxplots(:,texti)), num2str(round(nanmedian(data4boxplots(:,texti)),2,'significant')), 'HorizontalAlignment','center'); end
            xticks(1:size(data4boxplots,2))
            xticklabels(boxplots_xlabels)
            xtickangle(45)
            ylabel('ion counts (y axis limit = max percentile 80)')
            if min(data4boxplots(:)) < max(prctile(data4boxplots,80))
                axis([0 1+size(data4boxplots,2) min(data4boxplots(:)) max(prctile(data4boxplots,80))])
            end
            
            % ratio image figure
            
            fig1 = figure('units','normalized','outerposition',[0 0 1 1]);
            
            subplot(2,2,[1 3])
            imagesc(sii2plot); colormap(viridis); axis off; axis image; colorbar;
            
            name_adduct_2plot_1_1 = sample_info_1(sample_info_indexes_1(peak_1_i),1);
            name_adduct_2plot_1_2 = sample_info_2(sample_info_indexes_2(peak_2_i),1);
            name_adduct_2plot_r = repmat(" vs ",size(name_adduct_2plot_1_1,1),1);
            name_adduct_2plot_2_1 = sample_info_1(sample_info_indexes_1(peak_1_i),3);
            name_adduct_2plot_2_2 = sample_info_2(sample_info_indexes_2(peak_2_i),3);
            
            name_adduct_2plot   = cat(2, name_adduct_2plot_1_1, name_adduct_2plot_2_1, name_adduct_2plot_r, name_adduct_2plot_1_2, name_adduct_2plot_2_2);
            name_adduct_2plot   = reshape(name_adduct_2plot',[],1);
            name_adduct_2plot   = name_adduct_2plot(1:end,1)';
            
            text(.5,1.09,...
                {strjoin(name_adduct_2plot(1:min(9,length(name_adduct_2plot))))},...
                'Units','normalized','fontsize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
            if length(name_adduct_2plot)>6
                text(.5,1.09,...
                    {'... (see assignments table)'},...
                    'Units','normalized','fontsize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
            end
            
            % Peak 1
            
            subplot(2,2,2)
            hold on
            
            theo_mz = str2double(sample_info_1(sample_info_indexes_1(peak_1_i),2));
            window_centre = str2double(sample_info_1(sample_info_indexes_1(peak_1_i),4));
            
            window_xmin = window_centre - 200/1000000*window_centre;
            window_xmax = window_centre + 200/1000000*window_centre;
            
            ppmwindow_xmin = window_centre - fig_ppmTolerance/1000000*window_centre;
            ppmwindow_xmax = window_centre + fig_ppmTolerance/1000000*window_centre;
            
            window_mzvalues_indexes = logical((totalSpectrum_mzvalues > window_xmin).*(totalSpectrum_mzvalues < window_xmax));
            
            window_mzvalues = totalSpectrum_mzvalues(1,window_mzvalues_indexes);
            window_intensities = totalSpectrum_intensities(1,window_mzvalues_indexes)./pixels_num;
            
            window_mzvalues_indexes_centre = logical((totalSpectrum_mzvalues > ppmwindow_xmin).*(totalSpectrum_mzvalues < ppmwindow_xmax));
            ymax = max(totalSpectrum_intensities(1,window_mzvalues_indexes_centre)./pixels_num);
            
            if ~strcmp(sample_info_1(sample_info_indexes_1(peak_1_i),7),'not assigned')
                
                patch_x = [ peak_details_1(peak_1_i,1) peak_details_1(peak_1_i,3) peak_details_1(peak_1_i,3) peak_details_1(peak_1_i,1) ];
                patch_y = [ 0 0 1.1*ymax 1.1*ymax ];
                patch(patch_x,patch_y,1,'FaceColor',[.975 .975 .975],'EdgeColor','white')
                
                stem(str2double(sample_info_1(sample_info_indexes_1(peak_1_i),2)),1.1*ymax,'color',[0 .75 .75],'linewidth',2,'Marker','none')
                stem([ppmwindow_xmin ppmwindow_xmax],1.1*ymax.*[1 1],'color',[.5 .5 .5],'linewidth',.5,'Marker','none')
                
                plot(window_mzvalues,window_intensities,'k','linewidth',1);
                legend({'peak delimitation','theoretical mz value', [ num2str(fig_ppmTolerance) ' ppm window' ],'mean spectrum'}, 'fontsize', 12, 'Location','northoutside'); legend('boxoff'); xlabel('\it{m/z}'); axis square;
                
            else
                
                plot(window_mzvalues,window_intensities,'k','linewidth',1);
                legend({'mean spectrum'},'fontsize', 12); legend('Location','northoutside'); legend('boxoff'); xlabel('\it{m/z}'); axis square;
                
            end
            
            axis([window_xmin window_xmax min(window_intensities) 1.1*ymax]);
            
            % Peak 2
            
            subplot(2,2,4)
            hold on
            
            theo_mz = str2double(sample_info_2(sample_info_indexes_2(peak_2_i),2));
            window_centre = str2double(sample_info_2(sample_info_indexes_2(peak_2_i),4));
            
            window_xmin = window_centre - 200/1000000*window_centre;
            window_xmax = window_centre + 200/1000000*window_centre;
            
            ppmwindow_xmin = window_centre - fig_ppmTolerance/1000000*window_centre;
            ppmwindow_xmax = window_centre + fig_ppmTolerance/1000000*window_centre;
            
            window_mzvalues_indexes = logical((totalSpectrum_mzvalues > window_xmin).*(totalSpectrum_mzvalues < window_xmax));
            
            window_mzvalues = totalSpectrum_mzvalues(1,window_mzvalues_indexes);
            window_intensities = totalSpectrum_intensities(1,window_mzvalues_indexes)./pixels_num;
            
            window_mzvalues_indexes_centre = logical((totalSpectrum_mzvalues > ppmwindow_xmin).*(totalSpectrum_mzvalues < ppmwindow_xmax));
            ymax = max(totalSpectrum_intensities(1,window_mzvalues_indexes_centre)./pixels_num);
            
            if ~strcmp(sample_info_2(sample_info_indexes_2(peak_2_i),7),'not assigned')
                
                patch_x = [ peak_details_2(peak_2_i,1) peak_details_2(peak_2_i,3) peak_details_2(peak_2_i,3) peak_details_2(peak_2_i,1) ];
                patch_y = [ 0 0 1.1*ymax 1.1*ymax ];
                patch(patch_x,patch_y,1,'FaceColor',[.975 .975 .975],'EdgeColor','white')
                
                stem(str2double(sample_info_2(sample_info_indexes_2(peak_2_i),2)),1.1*ymax,'color',[0 .75 .75],'linewidth',2,'Marker','none')
                stem([ppmwindow_xmin ppmwindow_xmax],1.1*ymax.*[1 1],'color',[.5 .5 .5],'linewidth',.5,'Marker','none')
                
                plot(window_mzvalues,window_intensities,'k','linewidth',1);
                legend({'peak delimitation','theoretical mz value', [ num2str(fig_ppmTolerance) ' ppm window' ],'mean spectrum'}, 'fontsize', 12, 'Location','northoutside'); legend('boxoff'); xlabel('\it{m/z}'); axis square;
                
            else
                
                plot(window_mzvalues,window_intensities,'k','linewidth',1);
                legend({'mean spectrum'},'fontsize', 12); legend('Location','northoutside'); legend('boxoff'); xlabel('\it{m/z}'); axis square;
                
            end
            
            axis([window_xmin window_xmax min(window_intensities) 1.1*ymax]);
            
            % Saving figs and tif files
            
            name = reshape(char(strcat(...
                sample_info_1(sample_info_indexes_1(peak_1_i),4), " vs ",...
                sample_info_2(sample_info_indexes_2(peak_2_i),4), " ie ", ...
                name_adduct_2plot(1), " ", name_adduct_2plot(2), " vs ",...
                name_adduct_2plot(4), " ", name_adduct_2plot(5)...
                ))',[],1);
            
            rel_char_i = [];
            rel_char_ii = [];
            for char_i = 1:length(name)
                if isequal(name(char_i),',') || isequal(name(char_i),':') || isequal(name(char_i),'/') || isequal(name(char_i),' ')
                    rel_char_i = [ rel_char_i; char_i];
                elseif isequal(name(char_i),char("^")) || isequal(name(char_i),char("<")) || isequal(name(char_i),char(">")) || ...
                        isequal(name(char_i),char("'"))  || isequal(name(char_i),'"') || isequal(name(char_i),'*')
                    rel_char_ii = [ rel_char_ii; char_i];
                end
            end
            name(rel_char_i) = '_';
            name(rel_char_ii) = [];
            
            figname_char = [ name(1:min(70,length(name)))' '.fig' ];
            tifname_char = [ name(1:min(70,length(name)))' '.png' ];
            
            savefig(fig0,['boxplots_' figname_char],'compact')
            saveas(fig0,['boxplots_' tifname_char])
            
            savefig(fig1,figname_char,'compact')
            saveas(fig1,tifname_char)
            
            close all
            clear fig0
            clear fig1
            
            save(['data4boxplots_' figname_char(1:end-4) '.mat'],'data4boxplots')
            
        end
    end
end
function f_saving_sii_files( outputs_path, sample_info, sample_info_indexes, ion_images, image_width, image_height, peakDetails, pixels_num, totalSpectrum_intensities, totalSpectrum_mzvalues, fig_ppmTolerance, isitloadings )

for peak_i = 1:size(peakDetails,1)
    
    sample_info_i0 = sample_info_indexes(peak_i);
    
    sample_info_i1 = logical(sample_info(:,4)==sample_info(sample_info_i0,4));
    
    for databasei = unique(sample_info(sample_info_i1,7))'
        
        if isitloadings
            sample_info_i3 = find(sample_info_i1.*logical(sample_info(:,7)==databasei),1,'first');
        else
            sample_info_i3 = find(sample_info_i1.*logical(sample_info(:,7)==databasei))';
        end
        
        for sample_info_i = sample_info_i3
            
            % Organising the outputs
            
            mkdir([ outputs_path '\' char(sample_info(sample_info_i,7)) '\' ])
            cd([ outputs_path '\' char(sample_info(sample_info_i,7)) '\' ])
            
            % Creating the figure
            
            sii2plot = reshape(ion_images(:,peak_i),image_width,image_height)';
            
            fig1 = figure('units','normalized','outerposition',[0 0 1 1]);
            
            subplot(1,2,1)
            imagesc(sii2plot); colormap(viridis); axis off; axis image; colorbar;
            
            name_adduct_2plot_1 = sample_info(sample_info_i, 1);
            name_adduct_2plot_2 = sample_info(sample_info_i, 3);
            name_adduct_2plot_3 = repmat(" / ",size(name_adduct_2plot_1,1),1);
            
            name_adduct_2plot   = cat(2, name_adduct_2plot_1, name_adduct_2plot_2, name_adduct_2plot_3);
            name_adduct_2plot   = reshape(name_adduct_2plot',[],1);
            name_adduct_2plot   = name_adduct_2plot(1:end-1,1)';
            
            text(.5,1.09,...
                {strjoin(name_adduct_2plot(1:min(9,length(name_adduct_2plot))))},...
                'Units','normalized','fontsize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
            if length(name_adduct_2plot)>6
                text(.5,1.09,...
                    {'... (see assignments table)'},...
                    'Units','normalized','fontsize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
            end
            text(.5,1.05,...
                {strjoin(['theo mz ' sample_info(sample_info_i,2) ' - meas mz ', sample_info(sample_info_i,4)])},...
                'Units','normalized','fontsize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
            text(.5,1.025,...
                {['ppm ' num2str(round(double(sample_info(sample_info_i,5)))) ' - peak intensity ' num2str(round(double(sample_info(sample_info_i,11))))]},...
                'Units','normalized','fontsize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
            
            theo_mz = str2double(sample_info(sample_info_i,2));
            window_centre = str2double(sample_info(sample_info_i,4));
            
            window_xmin = window_centre - 200/1000000*window_centre;
            window_xmax = window_centre + 200/1000000*window_centre;
            
            ppmwindow_xmin = window_centre - fig_ppmTolerance/1000000*window_centre;
            ppmwindow_xmax = window_centre + fig_ppmTolerance/1000000*window_centre;
            
            window_mzvalues_indexes = logical((totalSpectrum_mzvalues > window_xmin).*(totalSpectrum_mzvalues < window_xmax));
            
            window_mzvalues = totalSpectrum_mzvalues(1,window_mzvalues_indexes);
            window_intensities = totalSpectrum_intensities(1,window_mzvalues_indexes)./pixels_num;
            
            window_mzvalues_indexes_centre = logical((totalSpectrum_mzvalues > ppmwindow_xmin).*(totalSpectrum_mzvalues < ppmwindow_xmax));
            ymax = max(totalSpectrum_intensities(1,window_mzvalues_indexes_centre)./pixels_num);
            
            subplot(1,2,2)
            hold on
            
            if ~strcmp(sample_info(sample_info_i,7),'not assigned')
                
                patch_x = [ peakDetails(peak_i,1) peakDetails(peak_i,3) peakDetails(peak_i,3) peakDetails(peak_i,1) ];
                patch_y = [ 0 0 1.1*ymax 1.1*ymax ];
                patch(patch_x,patch_y,1,'FaceColor',[.975 .975 .975],'EdgeColor','white')
                
                stem(str2double(sample_info(sample_info_i,2)),1.1*ymax,'color',[0 .75 .75],'linewidth',2,'Marker','none')
                stem([ppmwindow_xmin ppmwindow_xmax],1.1*ymax.*[1 1],'color',[.5 .5 .5],'linewidth',.5,'Marker','none')
                
                plot(window_mzvalues,window_intensities,'k','linewidth',1);
                legend({'peak delimitation','theoretical mz value', [ num2str(fig_ppmTolerance) ' ppm window' ],'mean spectrum'}, 'fontsize', 12, 'Location','northoutside'); legend('boxoff'); xlabel('\it{m/z}'); axis square;
                
            else
                
                plot(window_mzvalues,window_intensities,'k','linewidth',1);
                legend({'mean spectrum'},'fontsize', 12); legend('boxoff'); xlabel('\it{m/z}'); axis square;
                
            end
            
            axis([window_xmin window_xmax min(window_intensities) 1.1*ymax]);
            
            % Saving figs and tif files
            
            if ~isnan(str2double(sample_info(sample_info_i,6)))
                
                
                if length(name_adduct_2plot)>2
                    name = reshape(char(strcat(sample_info(sample_info_i,4), " ", name_adduct_2plot(1), name_adduct_2plot(2), " or other"))',[],1);
                else
                    name = reshape(char(strcat(sample_info(sample_info_i,4), " ", name_adduct_2plot(1), name_adduct_2plot(2)))',[],1);
                end
                
            else
                
                name = reshape([char(sample_info(sample_info_i,1)) '_' char(sample_info(sample_info_i,4))],[],1);
                
            end
            
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
            
            if isitloadings
                figname_char = [ char(num2str(peak_i)) '_' name(1:min(68,length(name)))' '.fig' ];
                tifname_char = [ char(num2str(peak_i)) '_' name(1:min(68,length(name)))' '.png' ];
            else
                figname_char = [ name(1:min(70,length(name)))' '.fig' ];
                tifname_char = [ name(1:min(70,length(name)))' '.png' ];
            end
            
            savefig(fig1,figname_char,'compact')
            saveas(fig1,tifname_char)
            
            close all
            clear fig1
            
        end
        
    end
    
end
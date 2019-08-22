function f_saving_sii_files_ca( ...
    outputs_path, ...
    smaller_masks_list, ...
    outputs_xy_pairs, ...
    sample_info, sample_info_indexes, ...
    norm_sii_cell, smaller_masks_cell, ...
    peak_details, ...
    pixels_num_cell, ...
    totalSpectrum_intensities_cell, totalSpectrum_mzvalues_cell, ...
    fig_ppmTolerance, isitloadings )

for database_type = unique(sample_info(:,7))'
    if ~strcmp(database_type,'not assigned')
        if ~exist([ outputs_path '\' char(database_type) '\0 to 5 ppm\' ], 'dir'); mkdir([ outputs_path '\' char(database_type) '\0 to 5 ppm\' ]); end
        if ~exist([ outputs_path '\' char(database_type) '\5 to 15 ppm\' ], 'dir'); mkdir([ outputs_path '\' char(database_type) '\5 to 15 ppm\' ]); end
        if ~exist([ outputs_path '\' char(database_type) '\15 to 30 ppm\' ], 'dir'); mkdir([ outputs_path '\' char(database_type) '\15 to 30 ppm\' ]); end
    end
end

table1 = [ "database", "name", "meas mz", "sample set" ];
tableri = 2;

table2 = table1;

for peak_i = 1:size(peak_details,1)
    
    sample_info_i0 = sample_info_indexes(peak_i);
    
    sample_info_i1 = logical(sample_info(:,4)==sample_info(sample_info_i0,4));
    
    for databasei = unique(sample_info(sample_info_i1,7))'
        
        if isitloadings
            sample_info_i3 = find(sample_info_i1.*logical(sample_info(:,7)==databasei),1,'first');
%             adduct_char = char(sample_info(:,3));
%             sample_info_i2 = logical(sample_info_i1 .* logical(sample_info(:,7)==databasei) .* logical(sum(adduct_char(:,4:5)==('H]'),2)==2)); % H adducts
%             if sum(sample_info_i2) > 1
%                 sample_info_i3 = sample_info_i2 .* logical(unique(min(double(sample_info(sample_info_i2,5))))==double(sample_info(:,5))); % smallest ppm
%             else
%                 sample_info_i3 = find(sample_info_i1 .* logical(sample_info(:,7)==databasei),1,'first');
%             end
        else
            sample_info_i3 = find(sample_info_i1.*logical(sample_info(:,7)==databasei))';
        end
        
        for sample_info_i = sample_info_i3
            
            % Organising the outputs
            
            if double(sample_info(sample_info_i,5)) <= 5
                cd([ outputs_path '\' char(sample_info(sample_info_i,7)) '\0 to 5 ppm\' ])
            elseif double(sample_info(sample_info_i,5)) <= 15
                cd([ outputs_path '\' char(sample_info(sample_info_i,7)) '\5 to 15 ppm\' ])
            elseif double(sample_info(sample_info_i,5)) <= 30
                cd([ outputs_path '\' char(sample_info(sample_info_i,7)) '\15 to 30 ppm\' ])
            else
                if ~exist([ outputs_path '\' char(sample_info(sample_info_i,7)) '\' ], 'dir'); mkdir([ outputs_path '\' char(sample_info(sample_info_i,7)) '\' ]); end
                cd([ outputs_path '\' char(sample_info(sample_info_i,7)) '\' ])
            end
            
            % Sii collage
            
            min_cn = 0;
            min_rn = 0;
            sii_cell2plot = {};
            smaller_masks_list2plot = {};
            
            for file_index = 1:length(norm_sii_cell)
                
                norm_sii1 = reshape(norm_sii_cell{file_index}.data(:,peak_i).*smaller_masks_cell{file_index},norm_sii_cell{file_index}.width,norm_sii_cell{file_index}.height)';
                norm_sii1(isnan(norm_sii1)) = 0;
                
                rows = (sum(norm_sii1,2)==0); norm_sii1(rows,:) = [];
                cols = (sum(norm_sii1,1)==0); norm_sii1(:,cols) = [];
                
                sii_cell2plot{outputs_xy_pairs(file_index,1),outputs_xy_pairs(file_index,2)} = norm_sii1;
                
                min_cn = max(min_cn,size(norm_sii1,2));
                min_rn = max(min_rn,size(norm_sii1,1));
                
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
            
            if size(table1,2) == 4
                table1 = [ table1, strcat(repmat("row ",2*size(sii_cell2plot,1),1), reshape(string([1:size(sii_cell2plot,1);1:size(sii_cell2plot,1)]),[],1))' ];
                table2 = [ table2, strcat(repmat("row ",3*size(sii_cell2plot,1),1), reshape(string([1:size(sii_cell2plot,1);1:size(sii_cell2plot,1);1:size(sii_cell2plot,1)]),[],1))' ];
            end
            
            table1(tableri-1+(1:size(sii_cell2plot,2)),1) = repmat(databasei,size(sii_cell2plot,2),1);
            table1(tableri-1+(1:size(sii_cell2plot,2)),2) = repmat(strcat(sample_info(sample_info_i, 1), " ", sample_info(sample_info_i, 3)),size(sii_cell2plot,2),1);
            table1(tableri-1+(1:size(sii_cell2plot,2)),3) = repmat(sample_info(sample_info_i, 4),size(sii_cell2plot,2),1);
            
            table2(tableri-1+(1:size(sii_cell2plot,2)),1) = repmat(databasei,size(sii_cell2plot,2),1);
            table2(tableri-1+(1:size(sii_cell2plot,2)),2) = repmat(strcat(sample_info(sample_info_i, 1), " ", sample_info(sample_info_i, 3)),size(sii_cell2plot,2),1);
            table2(tableri-1+(1:size(sii_cell2plot,2)),3) = repmat(sample_info(sample_info_i, 4),size(sii_cell2plot,2),1);
            
            pi = 0;
            pi1 = 5;
            pi2 = pi1;
            data4boxplots = [];
            boxplots_xlabels = string([]);
            colors2plot = [];
            for ri = 1:size(sii_cell2plot,1)
                
                colors2plot = [ colors2plot; [ ri/size(sii_cell2plot,1) (size(sii_cell2plot,1)-ri)/size(sii_cell2plot,1) 0.5 ] ];
                
                sii2plot3 = [];
                tableri0 = tableri-1;
                
                for ci = 1:size(sii_cell2plot,2)
                    
                    if ci > 1
                        colors2plot = [ colors2plot; colors2plot(end,:) ];
                    end
                    
                    % Single ion images
                    
                    sii2plot0 = sii_cell2plot{ri,ci};
                    sii2plot1 = [ NaN*ones(size(sii2plot0,1), floor(max(0,(min_cn-size(sii2plot0,2))/2))), sii2plot0, NaN*ones(size(sii2plot0,1), ceil(max(0,(min_cn-size(sii2plot0,2))/2))) ];
                    sii2plot2 = [ NaN*ones(floor(max(0,(min_rn-size(sii2plot1,1))/2)),size(sii2plot1,2)); sii2plot1; NaN*ones(ceil(max(0,(min_rn-size(sii2plot1,1))/2)),size(sii2plot1,2)) ];
                    sii2plot3 = [ sii2plot3 sii2plot2 ];
                    
                    % Tables (mean, std, median, percentiles)
                    
                    tableri0 = tableri0 + 1;
                    
                    table1(tableri0,4) = strcat("column ",string(ci));
                    table2(tableri0,4) = strcat("column ",string(ci));
                    
                    boxplot_data = reshape(sii2plot0,[],1);
                    boxplot_data(boxplot_data==0) = NaN;
                    
                    table1(tableri0,pi1) = string(nanmean(boxplot_data));
                    table1(tableri0,pi1+1) = string(nanstd(boxplot_data));
                    
                    table2(tableri0,pi2) = string(nanmedian(boxplot_data));
                    table2(tableri0,pi2+1) = string(prctile(boxplot_data(~isnan(boxplot_data)),25));
                    table2(tableri0,pi2+2) = string(prctile(boxplot_data(~isnan(boxplot_data)),75));
                    
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
            
            tableri = tableri0 + 1;
            
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
            
            % Single ion image figure
            
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
                {['ppm ' num2str(round(double(sample_info(sample_info_i,5)))) ' - peak intensity ' num2str(round(double(sample_info(sample_info_i,6))./pixels_num))]},...
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
                
                patch_x = [ peak_details(peak_i,1) peak_details(peak_i,3) peak_details(peak_i,3) peak_details(peak_i,1) ];
                patch_y = [ 0 0 1.1*ymax 1.1*ymax ];
                patch(patch_x,patch_y,1,'FaceColor',[.975 .975 .975],'EdgeColor','white')
                
                stem(str2double(sample_info(sample_info_i,2)),1.1*ymax,'color',[0 .75 .75],'linewidth',2,'Marker','none')
                stem([ppmwindow_xmin ppmwindow_xmax],1.1*ymax.*[1 1],'color',[.5 .5 .5],'linewidth',.5,'Marker','none')
                
                plot(window_mzvalues,window_intensities,'k','linewidth',1);
                legend({'peak delimitation','theoretical mz value', [ num2str(fig_ppmTolerance) ' ppm window' ],'mean spectrum'}, 'fontsize', 12, 'Location','northeast'); legend('boxoff'); xlabel('\it{m/z}'); axis square;
                
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

cd([ outputs_path '\'])

txt_row = strcat(repmat('%s\t',1,size(table1,2)-1),'%s\n');

table1(ismissing(table1)) = " ";

fileID = fopen('mean_std_per_small_mask.txt','w');
fprintf(fileID,txt_row, table1');
fclose(fileID);

table2(ismissing(table2)) = " ";

txt_row = strcat(repmat('%s\t',1,size(table2,2)-1),'%s\n');

fileID = fopen('median_perc_per_small_mask.txt','w');
fprintf(fileID,txt_row, table2');
fclose(fileID);

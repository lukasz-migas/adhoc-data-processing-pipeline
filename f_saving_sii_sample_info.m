function f_saving_sii_sample_info(filesToProcess, mask_list, norm_list, sample_info, mask_on )

% Saving sii given a curated sample_info matrix.

for file_index = 1:length(filesToProcess)
        
    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
    
    [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, fig_ppmTolerance, outputs_path ] = f_reading_inputs(csv_inputs);
    
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
    rois_path               = [ char(outputs_path) '\rois\' ];
    sii_path                = [ char(outputs_path) '\single ion images\' ];
    
    for main_mask = mask_list
        
        % Defining mz values of interest (to plot sii of)
        
        mzvalues2plot = unique(double(sample_info(:,4)));
                
        % Loading datacube
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacube' ])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacubeonly_peakDetails' ])
        
        % Loading spectral information
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_intensities' ])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\totalSpectrum_mzvalues' ])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\pixels_num' ])
        
        % Loading main main_mask

        if mask_on            
            load([ rois_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\roi' ])
            mask = logical((sum(datacube.data,2)>0).*reshape(roi.pixelSelection',[],1));
        end
        
        %
        
        image_width = datacube.width;
        image_height = datacube.height;
        
        th_mz_diff = min(diff(totalSpectrum_mzvalues));
                
        datacube_indexes = [];
        sample_info_indexes = [];
        for mzi = mzvalues2plot'
            datacube_indexes        = [ datacube_indexes;       find(abs(datacubeonly_peakDetails(:,2)-mzi)<th_mz_diff) ];
            sample_info_indexes     = [ sample_info_indexes;    find(abs(double(sample_info(:,4))-mzi)<th_mz_diff,1,'first') ];
        end
                        
        peak_details = datacubeonly_peakDetails(datacube_indexes,:);
        
        if size(peak_details,1)~=size(mzvalues2plot,1)
            disp('There is an issue! The length of the list of mz values of interest does not match the length of the mz values of interest in the datacube. Please create datacube again.')
            break
        end
        
        for norm_type = norm_list
                        
            outputs_path = [ sii_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\' char(norm_type) '\' ]; mkdir(outputs_path)
                        
            norm_sii = f_norm_datacube( datacube, norm_type );
            norm_sii = norm_sii(:,datacube_indexes);
            
            if mask_on
                norm_sii(~mask,:) = NaN;
            end
                        
            f_saving_sii_files( outputs_path, sample_info, sample_info_indexes, norm_sii, image_width, image_height, peak_details, pixels_num, totalSpectrum_intensities, totalSpectrum_mzvalues, fig_ppmTolerance, 0 )
            
        end
        
    end
end
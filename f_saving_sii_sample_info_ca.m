function f_saving_sii_sample_info_ca( filesToProcess, main_mask, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, sample_info )

% Saving sii given a curated sample_info matrix.

datacube_cell = {};
smaller_masks_cell = {};

for file_index = 1:length(filesToProcess)
    
    csv_inputs = [ filesToProcess(file_index).folder filesep 'inputs_file' ];
    
    [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, fig_ppmTolerance, outputs_path ] = f_reading_inputs(csv_inputs);
        
    rois_path               = [ char(outputs_path) filesep 'rois' filesep ];
    spectra_details_path    = [ char(outputs_path) filesep 'spectra details' filesep ];
    sii_path                = [ char(outputs_path) filesep 'single ion images' filesep ];
    
    % Defining mz values of interest (to plot sii of)
    
    mzvalues2plot = double(unique(sample_info(:,4)));
        
    % Loading datacube
    
    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'datacube' ])
    
    datacube_cell{file_index} = datacube;
    
    if file_index == 1
          
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'datacubeonly_peakDetails' ])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'totalSpectrum_mzvalues' ])
        
        [~, datacube_indexes] = ismembertol(mzvalues2plot,datacubeonly_peakDetails(:,2),1e-10);
        [~, sample_info_indexes] = ismembertol(mzvalues2plot,double(sample_info(:,4)),1e-10);
        
        % Loading peaks information
        
        peak_details = datacubeonly_peakDetails(datacube_indexes,:);
                
        if size(peak_details,1)~=size(mzvalues2plot,1)
            disp('There is an issue! The length of the list of mz values of interest does not match the length of the mz values of interest in the datacube. Please generate a new datacube.')
            return
        end
        
    end
    
    % Loading smaller masks information
    
    load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(smaller_masks_list(file_index)) filesep 'roi'])
    smaller_masks_cell{file_index} = logical(reshape(roi.pixelSelection',[],1));
        
end

% Mean spectrum for figures

filesToProcess0 = f_unique_extensive_filesToProcess(filesToProcess);

y = 0;
pixels_num0 = 0;

for file_index = 1:length(filesToProcess0)
    
    % Loading spectral information
    
    if ( file_index == 1 ); load([ spectra_details_path filesToProcess0(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'totalSpectrum_mzvalues' ]); end
    
    load([ spectra_details_path filesToProcess0(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'totalSpectrum_intensities' ])
    load([ spectra_details_path filesToProcess0(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'pixels_num' ])
    
    y = y + totalSpectrum_intensities;
    pixels_num0 = pixels_num0 + pixels_num;
    
end

meanSpectrum_intensities = y./pixels_num0;
meanSpectrum_mzvalues = totalSpectrum_mzvalues;
    
for norm_type = norm_list
    
    outputs_path = [ sii_path filesep char(dataset_name) filesep char(main_mask) filesep char(norm_type) filesep ]; mkdir(outputs_path)
    
    norm_sii_cell = {};
    for file_index = 1:length(datacube_cell)
                
        norm_sii = f_norm_datacube( datacube_cell{file_index}, norm_type );
               
        norm_sii_cell{file_index}.data = norm_sii(:,datacube_indexes);
        norm_sii_cell{file_index}.width = datacube_cell{file_index}.width;
        norm_sii_cell{file_index}.height = datacube_cell{file_index}.height;
        
        disp([ num2str(size(norm_sii(:,datacube_indexes),1)) ' ' num2str(datacube_cell{file_index}.width .* datacube_cell{file_index}.height) ' ' num2str(size(smaller_masks_cell{file_index},1)) ])       
        
    end
    
    f_saving_sii_files_ca( ...
        outputs_path, ...
        smaller_masks_list, ...
        outputs_xy_pairs, ...
        sample_info, sample_info_indexes, ...
        norm_sii_cell, smaller_masks_cell, ...
        peak_details, ...
        meanSpectrum_intensities, meanSpectrum_mzvalues, ...
        fig_ppmTolerance, 0 )

end



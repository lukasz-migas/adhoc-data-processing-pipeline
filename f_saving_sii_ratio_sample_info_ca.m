function [ ...
    smaller_masks_list, ...
    sample_info, ...
    sample_info_indexes, ...
    norm_sii_cell, ...
    smaller_masks_cell, ...
    peak_details, ...
    pixels_num_cell, ...
    totalSpectrum_intensities_cell, ...
    totalSpectrum_mzvalues_cell ...
    ] = f_saving_sii_ratio_sample_info_ca( filesToProcess, mask, smaller_masks_list, norm_type, sample_info0, mask_on  )

% Saving sii given a curated sample_info matrix.

datacube_cell = {};
main_masks_cell = {};
smaller_masks_cell = {};

totalSpectrum_intensities_cell = {};
totalSpectrum_mzvalues_cell = {};
pixels_num_cell = {};

sample_info = [];
datacube_indexes = [];
sample_info_indexes = [];
peak_details = [];
peak_details_last_col = [];

norm_sii_cell = {};

for file_index = 1:length(filesToProcess)
    
    csv_inputs = [ filesToProcess(file_index).folder filesep 'inputs_file' ];
    
    [ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);
    
    rois_path               = [ char(outputs_path) filesep 'rois' filesep ];
    spectra_details_path    = [ char(outputs_path) filesep 'spectra details' filesep ];
    
    % Loading datacube
    
    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(mask) filesep 'datacube' ])
    
    datacube_cell{file_index} = datacube;
    
    % Reorganising
    
    if file_index == 1
        
        for ratio_i = unique(sample_info0(:,end))'
            
            % Sample information
            
            sample_info = [ sample_info; sample_info0(strcmpi(sample_info0(:,end),ratio_i),:) ];
            
            % Defining mz values of interest (to plot sii of)
            
            mzvalues2plot = unique(double(sample_info0(strcmpi(sample_info0(:,end),ratio_i),4)));
            
            %  Spectral information
            
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(mask) filesep 'datacubeonly_peakDetails' ])
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(mask) filesep 'totalSpectrum_mzvalues' ])
            
            th_mz_diff = min(diff(totalSpectrum_mzvalues));
            
            for mzi = mzvalues2plot'
                datacube_indexes        = [ datacube_indexes;       find(abs(datacubeonly_peakDetails(:,2)-mzi)<th_mz_diff) ];
                sample_info_indexes     = [ sample_info_indexes;    find(abs(double(sample_info(:,4))-mzi)<th_mz_diff,1,'first') ];
            end
            
            peak_details_last_col = [ peak_details_last_col; double(ratio_i).*ones(size(mzvalues2plot,1),1) ];
            
        end
        
        % Peaks information
        
        peak_details = [ peak_details; [ datacubeonly_peakDetails(datacube_indexes,:) peak_details_last_col ] ];
        
    end
    
    % Loading main mask information
    
    if mask_on == 1
        load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(mask) filesep 'roi'])
        main_mask = logical((sum(datacube.data,2)>0).*reshape(roi.pixelSelection',[],1));
    end
    
    % Loading smaller masks information
    
    load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(smaller_masks_list(file_index)) filesep 'roi'])
    smaller_masks_cell{file_index} = logical((sum(datacube.data,2)>0).*reshape(roi.pixelSelection',[],1));
    
    % Loading spectral information
    
    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(mask) filesep 'totalSpectrum_intensities' ])
    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(mask) filesep 'totalSpectrum_mzvalues' ])
    load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(mask) filesep 'pixels_num' ])
    
    totalSpectrum_intensities_cell{file_index}  = totalSpectrum_intensities;
    totalSpectrum_mzvalues_cell{file_index}   	= totalSpectrum_mzvalues;
    pixels_num_cell{file_index}               	= pixels_num;
    
end

for file_index = 1:length(datacube_cell)
    
    norm_sii = f_norm_datacube( datacube_cell{file_index}, norm_type );
    
    if mask_on == 1
        disp('hello')
        %norm_sii(main_mask,:) = NaN;
    end
    
    norm_sii_cell{file_index}.data = norm_sii(:,datacube_indexes);
    norm_sii_cell{file_index}.width = datacube_cell{file_index}.width;
    norm_sii_cell{file_index}.height = datacube_cell{file_index}.height;
    
end



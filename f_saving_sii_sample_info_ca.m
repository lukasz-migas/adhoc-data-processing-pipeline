function f_saving_sii_sample_info_ca( filesToProcess, main_mask, smaller_masks_list, outputs_xy_pairs, dataset_name, norm_list, sample_info )
% Saving sii given a curated sample_info matrix.

% Sorting filesToProcess (and re-organising the related information) to avoid the need to load data unnecessary times

file_names = []; for i = 1:size(filesToProcess,1); file_names = [ file_names; string(filesToProcess(i).name) ]; end
[~, files_indicies] = sort(file_names);
filesToProcess = filesToProcess(files_indicies);
smaller_masks_list = smaller_masks_list(files_indicies);
outputs_xy_pairs = outputs_xy_pairs(files_indicies,:);

% Defining all paths needed

csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];
[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, fig_ppmTolerance, outputs_path ] = f_reading_inputs(csv_inputs);

rois_path               = [ char(outputs_path) '\rois\' ];
spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
sii_path                = [ char(outputs_path) '\single ion images\' ];

% Computing mean spectrum

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

% Defining mz values of interest

mzvalues2plot = double(unique(sample_info(:,4)));

smaller_masks_cell = {};
for file_index = 1:length(filesToProcess)
    
    if file_index == 1
        
        % Loading information about the mz values saved in the datacube
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'datacubeonly_peakDetails' ])
        
        [~, datacube_indexes] = ismembertol(mzvalues2plot,datacubeonly_peakDetails(:,2),1e-10);
        [~, sample_info_indexes] = ismembertol(mzvalues2plot,double(sample_info(:,4)),1e-10);
        
        peak_details = datacubeonly_peakDetails(datacube_indexes,:);
        
        if size(peak_details,1)~=size(mzvalues2plot,1)
            disp('There is an issue! The length of the list of mz values of interest does not match the length of the mz values of interest in the datacube. Please generate a new datacube.')
            return
        end
        
        % Loading peaks information
        
        load([ peak_assignments_path    filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
        load([ peak_assignments_path    filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\hmdb_sample_info' ])
        
    end
    
    % Loading smaller masks information
    
    load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(smaller_masks_list(file_index)) filesep 'roi'])
    smaller_masks_cell{file_index} = logical(reshape(roi.pixelSelection',[],1));
    
end

for norm_type = norm_list
    
    outputs_path = [ sii_path filesep char(dataset_name) filesep char(main_mask) filesep char(norm_type) filesep ]; mkdir(outputs_path)
    
    % Loading normalised data, pixels coord, width and height
    
    data_cell = {};
    for file_index = 1:length(smaller_masks_cell)
        
        % Loading data only if the name of the file changes.
        % filesToProcess needs to be sorted for this to work properly.
        
        if file_index == 1 || ~strcmpi(filesToProcess(file_index).name(1,1:end-6),filesToProcess(file_index-1).name(1,1:end-6))
            
            disp(['! Loading ' filesToProcess(file_index).name(1,1:end-6) ' data...'])
            
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\' char(norm_type) '\data.mat' ])
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\pixels_coord'])
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\width'])
            load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\height'])
            
        end
        
        mask4plotting = logical(smaller_masks_cell{file_index});
        
        data_cell{file_index}.data = data( mask4plotting, datacube_indexes );
        data_cell{file_index}.mask = mask4plotting;
        data_cell{file_index}.pixels_coord = pixels_coord( mask4plotting, : );
        data_cell{file_index}.width = width;
        data_cell{file_index}.height = height;
        
    end
    
    f_saving_sii_files_ca( ...
        outputs_path, ...
        smaller_masks_list, ...
        outputs_xy_pairs, ...
        sample_info, sample_info_indexes, ...
        data_cell, ...
        peak_details, ...
        meanSpectrum_intensities, meanSpectrum_mzvalues, ...
        fig_ppmTolerance, 0 )
    
end



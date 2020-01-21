function f_saving_mva_rois_ca( filesToProcess, main_mask_list, dataset_name, mva_list, numComponents_list, norm_list, molecules_list )

csv_inputs = [ filesToProcess(1).folder '\inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
if isempty(molecules_list)
    mva_path            = [ char(outputs_path) '\mva\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
    molecules_list      = [];
else
    mva_path            = [ char(outputs_path) '\mva ' char(molecules_list) '\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
end
rois_path               = [ char(outputs_path) '\rois\' ];

for main_mask = main_mask_list
    
    mvai = 0;
    for mva_type = mva_list
        mvai = mvai+1;
        numComponents = numComponents_list(mvai);
        
        for norm_type = norm_list
            
            if isnan(numComponents)
                
                load([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\idx' ]);
                idx0 = idx; clear idx
                
            else
                
                load([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\idx' ]);
                idx0 = idx; clear idx
                
            end
            
            starti = 1;
            
            for file_index = 1:length(filesToProcess)
                
                load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\width' ]); % Loading original images width and height
                load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\height' ]); % Loading original images width and height
                
                endi = starti+width*height-1;
                
                idx1 = idx0(starti:endi,:); disp(filesToProcess(file_index).name(1,1:end-6)); disp(max(idx1))
                
                if isnan(numComponents)
                    
                    mkdir([ rois_path filesToProcess(file_index).name(1,1:end-6) '\mva based rois\' char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\' char(molecules_list) '\' ])
                    cd([ rois_path filesToProcess(file_index).name(1,1:end-6) '\mva based rois\' char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\' char(molecules_list) '\' ])
                    
                else
                    
                    mkdir([ rois_path filesToProcess(file_index).name(1,1:end-6) '\mva based rois\' char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\' char(molecules_list) '\' ])
                    cd([ rois_path filesToProcess(file_index).name(1,1:end-6) '\mva based rois\' char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\' char(molecules_list) '\' ])
                    
                end
                
                idx = idx1;
                
                save('idx','idx')
                
                for idx_i = unique(idx)'
                    
                    roi_mask = logical(reshape(logical(idx==idx_i),width,height)');
                    
                    roi = RegionOfInterest(width,height);
                    roi.addPixels(roi_mask)
                    
                    figure();
                    imagesc(roi.pixelSelection); axis image
                    colormap gray;
                    
                    mkdir(['component ' num2str(idx_i)])
                    cd(['component ' num2str(idx_i)])
                    
                    save('roi','roi')
                    
                    cd('..')
                    
                end
                
                clear idx
                
                starti = endi+1;
           
            end
        end
    end
end

function f_running_mva_ca( filesToProcess, main_mask_list, smaller_masks_list, dataset_name, norm_list, molecules_list )

for main_mask = main_mask_list
    
    % Creating the cells that will comprise the information regarding the
    % single ion images, the main mask, and the smaller mask. 
    % Main mask - Mask used at the preprocessing step (usually tissue only).
    % Small mask - Mask used to plot the results in the shape of a grid
    % defined by the user (it can be a reference to a particular piece of
    % tissue or a set of tissues).
    
    datacube_cell = {};
    main_mask_cell = {};
    smaller_masks_cell = {};
    
    for file_index = 1:length(filesToProcess)
        
        csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
        
        [ ~, ~, ~, ...
            mva_list, numPeaks4mva, ...
            numComponents_array, ~, ...
            ~, mva_molecules_lists_label_list, ppmTolerance, ...
            ~, ~, ~, ...
            ~, ...
            outputs_path ] = f_reading_inputs(csv_inputs);
        
        % Defining all the path needed.
        
        rois_path               = [ char(outputs_path) '\rois\' ];
        spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
        peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
        if isempty(molecules_list)
            mva_path            = [ char(outputs_path) '\mva\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
        else
            mva_path            = [ char(outputs_path) '\mva ' char(molecules_list) '\' ]; if ~exist(mva_path, 'dir'); mkdir(mva_path); end
            numPeaks4mva = [];
            mva_molecules_lists_label_list = molecules_list;
            ppmTolerance = 30;
        end
        
        % Loading datacubes, peak details, and database matching information
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacube' ])
        
        datacube_cell{file_index} = datacube;
        
        if file_index == 1
            
            % Loading the information about the peaks, the mz values saved
            % as a dacube cube and the information regarding the matching
            % of the dataset with a set of lists of relevant molecules
            
            load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\datacubeonly_peakDetails' ])
            load([ spectra_details_path     filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\peakDetails' ])
            load([ peak_assignments_path    filesToProcess(file_index).name(1,1:end-6) '\' char(main_mask) '\relevant_lists_sample_info' ])
            
            % Determining the indexes of the mzvalues that are of interest
            % from the datacube
            
            datacube_mzvalues_indexes = f_datacube_mzvalues_rod( numPeaks4mva, mva_molecules_lists_label_list, ppmTolerance, relevant_lists_sample_info, peakDetails, datacubeonly_peakDetails );
            
        end
        
        % Loading main mask information
        
        if ~strcmpi(main_mask,"no mask")
            load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(main_mask) filesep 'roi'])
            main_mask_cell{file_index} = reshape(roi.pixelSelection',[],1);
        else            
            main_mask_cell{file_index} = true(ones(size(datacube,1),1));
        end
        
        % Loading smaller masks information
        
        load([ rois_path filesToProcess(file_index).name(1,1:end-6) filesep char(smaller_masks_list(file_index)) filesep 'roi'])
        smaller_masks_cell{file_index} = logical((sum(datacube.data,2)>0).*reshape(roi.pixelSelection',[],1));
        
    end
    
    for norm_type = norm_list
        
        mvai = 0;
        for mva_type = mva_list
            mvai = mvai+1;
            
            numComponents = numComponents_array(mvai);
            
            if strcmpi(mva_type,"pca") || strcmpi(mva_type,"nnmf") || strcmpi(mva_type,"kmeans") || (strcmpi(mva_type,"nntsne") && ~isnan(numComponents))
                
                % if ~exist([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'],'dir')
                mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                % else
                %    rmdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'],'s')
                %    mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                % end
                
                cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                
            elseif strcmpi(mva_type,"nntsne") && isnan(numComponents)
                
                % if ~exist([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'],'dir')
                mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
                % else
                %    rmdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'],'s')
                %    mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
                % end
                
                cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
                
            end
            
            save('datacube_mzvalues_indexes','datacube_mzvalues_indexes','-v7.3')
            
            data4mva = [];
            mask4mva = [];
            for file_index = 1:length(datacube_cell)
                
                % Data normalisation
                
                norm_data = f_norm_datacube_v2( datacube_cell{file_index}, main_mask_cell{file_index}, norm_type );
                
                % Data compilation
                
                data4mva 	= [ data4mva;  norm_data(logical(smaller_masks_cell{file_index}.*main_mask_cell{file_index}.*(sum(norm_data(:,datacube_mzvalues_indexes),2)>0)),datacube_mzvalues_indexes)    ];
                mask4mva    = [ mask4mva;  logical(smaller_masks_cell{file_index}.*main_mask_cell{file_index}.*(sum(norm_data(:,datacube_mzvalues_indexes),2)>0))                                         ];
                
            end
            
            mask4mva = logical(mask4mva);
            
            % Running MVA
            
            tic
            
            switch mva_type
                
                case 'pca'
                    
                    [ coeff, score, latent ] = pca(data4mva);
                    
                    firstCoeffs = coeff(:,1:numComponents);
                    firstScores = zeros(length(mask4mva),numComponents); firstScores(mask4mva,:) = score(:,1:numComponents);
                    explainedVariance = latent ./ sum(latent) * 100;
                    
                    save('firstCoeffs','firstCoeffs','-v7.3')
                    save('firstScores','firstScores','-v7.3')
                    save('explainedVariance','explainedVariance','-v7.3')
                    
                case 'nnmf'
                    
                    [ W0, H ] = nnmf(data4mva, numComponents);
                    
                    W = zeros(length(mask4mva),numComponents); W(mask4mva,:) = W0;
                    
                    save('W','W','-v7.3')
                    save('H','H','-v7.3')
                    
                case 'kmeans'
                                        
                    [ idx0, C ] = kmeans(data4mva, numComponents,'distance','cosine');
                    
                    idx = zeros(length(mask4mva),1); idx(mask4mva,:) = idx0; idx(isnan(idx)) = 0;
                    
                    save('idx','idx','-v7.3')
                    save('C','C','-v7.3')
                    
                case 'nntsne'
                    
                    [ rgbData, idx0, cmap, outputSpectralContriubtion  ] = nnTsneFull( data4mva, numComponents );
                    
                    idx = zeros(length(mask4mva),1); idx(mask4mva,:) = idx0; idx(isnan(idx)) = 0;
                    
                    save('rgbData','rgbData')
                    save('idx','idx')
                    save('cmap','cmap')
                    save('outputSpectralContriubtion','outputSpectralContriubtion')
                    
            end
            
            t = toc; disp([ '!!! ' char(mva_type) ' time elapsed: ' num2str(t) ])
            
        end
    end
end


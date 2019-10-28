function f_running_mva( filesToProcess, norm_list, mask_list )

%%

for file_index = 1:length(filesToProcess)
    
    csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];
    
    [ ~, ~, ~, ...
        mva_list, numPeaks4mva, ~, ...
        numComponents_array, ~, ...
        ~, mva_molecules_lists_label_list, ppmTolerance, ...
        ~, ~, ~, ...
        ~, ...
        outputs_path ] = f_reading_inputs(csv_inputs);
        
    rois_path               = [ char(outputs_path) '\rois\' ];
    spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
    peak_assignments_path   = [ char(outputs_path) '\peak assignments\' ];
    mva_path                = [ char(outputs_path) '\mva\' ]; mkdir(mva_path)
    
    for mask_type = mask_list
        
        % Load the datacube and assignments list
        
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\datacube' ])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\datacubeonly_peakDetails' ])
        load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\peakDetails' ])
        load([ peak_assignments_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\relevant_lists_sample_info' ])
        
        % Save image dimentions
        
        width = datacube.width; save([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\width' ],'width')
        height = datacube.height; save([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\height' ],'height')

        %
        
        mini_sample_info_mzvalues_indexes = 0;
        for labeli = mva_molecules_lists_label_list
            mini_sample_info_mzvalues_indexes = mini_sample_info_mzvalues_indexes + ( strcmp(relevant_lists_sample_info(:,7),labeli) .* logical(double(relevant_lists_sample_info(:,5))<=ppmTolerance) );
        end
        
        if ~isempty(relevant_lists_sample_info)
            mini_sample_info_mzvalues = double(unique(relevant_lists_sample_info(logical(mini_sample_info_mzvalues_indexes),4)));
        else
            mini_sample_info_mzvalues = [];
        end
        
        datacube_mzvalues_indexes = 0;
        for mzi = mini_sample_info_mzvalues'
            datacube_mzvalues_indexes = datacube_mzvalues_indexes + logical(abs(datacubeonly_peakDetails(:,2)-mzi)<0.0000001);
        end
        
        if ~isempty(numPeaks4mva)
            
            [ ~, mzvalues_highest_peaks_indexes ] = sort(peakDetails(:,4),'descend');
            highest_peaks_mzvalues = peakDetails(mzvalues_highest_peaks_indexes(1:numPeaks4mva,1),2);
            
            for mzii = highest_peaks_mzvalues'
                datacube_mzvalues_indexes = datacube_mzvalues_indexes + logical(abs(datacubeonly_peakDetails(:,2)-mzii)<0.0000001);
            end
            
        end
        
        datacube_mzvalues_indexes = logical(datacube_mzvalues_indexes);
        
        %
        
        if strcmpi(mask_type,"no mask")
                
                % Non zeros roi
                
                mask = logical(sum(datacube.data(:,datacube_mzvalues_indexes),2)>0);
                
                % mz selection
                
                data = datacube.data(:,datacube_mzvalues_indexes);
                
        else
                
                % Load tissue roi (located where the raw data is)
                
                load([ rois_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\roi'])
                
                % Mask
                
                mask = logical((sum(datacube.data(:,datacube_mzvalues_indexes),2)>0).* reshape(roi.pixelSelection',[],1));
                                
                aux_matrix = 0*roi.pixelSelection;
                for rowi = 1:length(datacube.pixels)
                    aux_matrix(datacube.pixels(rowi,2),datacube.pixels(rowi,1)) = 1;
                end
                aux_matrix = logical(aux_matrix);
               
                % mz selection
                
                data = zeros(length(mask),sum(logical(datacube_mzvalues_indexes)));
                data(reshape(aux_matrix,[],1),:) = datacube.data(:,datacube_mzvalues_indexes);
                                
        end
        
        %
        
        mvai = 0;
        for mva_type = mva_list
            mvai = mvai +1;
            
            numComponents = numComponents_array(mvai);
                        
            for norm_type = norm_list
                
                if strcmpi(mva_type,"pca") || strcmpi(mva_type,"nnmf") || strcmpi(mva_type,"kmeans") || (strcmpi(mva_type,"nntsne") && ~isnan(numComponents))
                    
%                     if exist([ mva_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'],'dir')
                        mkdir([ mva_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
%                     else
%                         rmdir([ mva_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
%                         mkdir([ mva_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
%                     end
                    
                    cd([ mva_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
                    
                elseif strcmpi(mva_type,"nntsne") && isnan(numComponents)
                    
%                     if ~exist([ mva_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(mva_type) '\' char(norm_type) '\'],'dir')
                        mkdir([ mva_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(mva_type) '\' char(norm_type) '\'])
%                     else
%                         rmdir([ mva_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(mva_type) '\' char(norm_type) '\'])
%                         mkdir([ mva_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(mva_type) '\' char(norm_type) '\'])
%                     end
                    
                    cd([ mva_path filesToProcess(file_index).name(1,1:end-6) '\' char(mask_type) '\' char(mva_type) '\' char(norm_type) '\'])
                    
                end
                
                if isequal(mask_type,"tissue only"); tissue_mask = mask; save('tissue_mask','tissue_mask','-v7.3'); end
                
                save('datacube_mzvalues_indexes','datacube_mzvalues_indexes','-v7.3')
                 
                relevant_data = data(mask,:); % No normalisation

                switch norm_type
                        
                    case 'tic norm'
                        
                        relevant_data = f_tic_norm(relevant_data); % TIC normalisation
                        
                    case 'L2 norm'
                        
                        relevant_data = f_L2_norm(relevant_data); % L2 normalisation
                        
                    case 'RMS norm'
                        
                        relevant_data = f_RMS_norm(relevant_data); % RMA normalisation
                        
                    case 'median norm'
                        
                        relevant_data = f_median_norm(relevant_data); % median normalisation
                        
                    case 'zscore'
                        
                        relevant_data = f_zscore_norm(relevant_data);
                        
                    case 'pqn mean'
                        
                        relevant_data = crukNormalise(relevant_data,'pqn-mean');
                        
                    case 'pqn median'
                        
                        relevant_data = crukNormalise(relevant_data,'pqn-median');
                        
                end
                
                % Running MVA
                
                tic
                
                switch mva_type
                    
                    case 'pca'
                        
                        [ coeff, score, latent ] = pca(relevant_data);
                        
                        firstCoeffs = coeff(:,1:numComponents);
                        firstScores = zeros(length(mask),numComponents); firstScores(mask,:) = score(:,1:numComponents);
                        explainedVariance = latent ./ sum(latent) * 100;
                        
                        save('firstCoeffs','firstCoeffs','-v7.3')
                        save('firstScores','firstScores','-v7.3')
                        save('explainedVariance','explainedVariance','-v7.3')
                        
                    case 'nnmf'
                        
                        [ W0, H ] = nnmf(relevant_data, numComponents);
                        
                        W = zeros(length(mask),numComponents); W(mask,:) = W0;
                        
                        save('W','W','-v7.3')
                        save('H','H','-v7.3')
                        
                    case 'kmeans'
                        
                        [ idx0, C ] = kmeans(relevant_data, numComponents,'distance','cosine');
                        
                        idx = zeros(length(mask),1); idx(mask,:) = idx0; idx(isnan(idx)) = 0;
                                                
                        save('idx','idx','-v7.3')
                        save('C','C','-v7.3')
                                                
                    case 'nntsne'
                        
                        [ rgbData, idx0, cmap, outputSpectralContriubtion  ] = nnTsneFull( relevant_data, numComponents );
                        
                        idx = zeros(length(mask),1); idx(mask,:) = idx0; idx(isnan(idx)) = 0;
                        
                        save('rgbData','rgbData')
                        save('idx','idx')
                        save('cmap','cmap')
                        save('outputSpectralContriubtion','outputSpectralContriubtion')
                        
                end
                
                t = toc; disp([ '!!! ' char(mva_type) ' time elapsed: ' num2str(t) ])
                
            end
        end
        
    end
end

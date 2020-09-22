function f_running_mva_auxiliar( mva_type, mva_path, dataset_name, main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )

% This function runs the multivariate analysis - mva_type - on the curated data - data4mva.
%
% Inputs:
% mva_type - string specifying which MVA to run
% mva_path - path to where the MVA results will be saved
% dataset_name - name of the dataset
% main_mask - main mask used
% norm_type - normalisation used
% data4mva - curated data
% mask4mva - mask (pixels) used to obtain curated data
% numComponents - number of components to save
% datacube_mzvalues_indexes - indicies of the peaks selected to be used in
% the MVA in the datacube
%
% Outputs:
% pca - firstCoeffs, firstScores, explainedVariance
% nnmf - W, H
% ica - z, model
% kmeans - idx, C, optimal_numComponents
% tsne - rgbData, idx, cmap, loss, tsne_parameters
% nntsne - rgbData, idx, cmap, outputSpectralContriubtion  
% See the help of each function for details on its outputs. With the
% exception of nntsne, Matlab functions are called.

% Create a folder to save the outputs of the MVA

if ~isnan(numComponents)
    
    mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
    
else
    
    mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
    
end

% Save the indicies of peaks selected to be used in the MVA in the datacube

save('datacube_mzvalues_indexes','datacube_mzvalues_indexes','-v7.3')

if sum(datacube_mzvalues_indexes) >= 3 % if there are more then 3 peaks in the curated data
    
    % Running MVA
    
    tic
    
    switch mva_type
        
        case 'pca'
            
            [ coeff, score, latent ] = pca(data4mva);
            
            firstCoeffs = coeff(:,1:min(numComponents,size(coeff,2)));
            firstScores = zeros(length(mask4mva),min(numComponents,size(coeff,2))); firstScores(mask4mva,:) = score(:,1:min(numComponents,size(coeff,2)));
            explainedVariance = latent ./ sum(latent) * 100;
            
            save('firstCoeffs','firstCoeffs','-v7.3')
            save('firstScores','firstScores','-v7.3')
            save('explainedVariance','explainedVariance','-v7.3')
                        
        case 'nnmf'
            
            [ W0, H ] = nnmf(data4mva, numComponents);
            
            W = zeros(length(mask4mva),numComponents); W(mask4mva,:) = W0;
            
            save('W','W','-v7.3')
            save('H','H','-v7.3')
            
        case 'rica'
            
            rng default % for reproducibility
            
            % data - matrix with the dimentions number of pixels (rows) by number of masses (columns)
            % q - the number os features
            % 'Lambda' — Regularization coefficient value (1 (default) | positive numeric scalar)
            % 'Standardize' — Flag to standardize predictor data (false (default) | true)
            % 'ContrastFcn' — Contrast function ('logcosh' (default) | 'exp' | 'sqrt')
            % 'InitialTransformWeights' — Transformation weights that initialize
            % optimization (randn(p,q) (default) | numeric matrix)
            
            q = numComponents;
            p = size(data4mva,2);
            
            InitialTransformWeights = randn(p,q); % would fix this for different runs
            
            model = rica(data4mva,q,'VerbosityLevel',1,'Lambda',1,'Standardize',true,'ContrastFcn','logcosh', 'InitialTransformWeights', InitialTransformWeights);
            
            z0 = transform(model,data4mva); % transforms the data into the features z via the model
            
            z = zeros(length(mask4mva),min(numComponents,size(z0,2))); z(mask4mva,:) = z0(:,1:min(numComponents,size(z0,2)));
                       
            save('z','z','-v7.3')
            save('model','model','-v7.3')
            
        case 'kmeans'
            
            [ idx0, C, optimal_numComponents ] = f_kmeans( data4mva, numComponents, 'cosine' );
            % [ idx0, C, optimal_numComponents ] = f_kmeans( data4mva, numComponents, 'correlation' );
            
            idx = zeros(length(mask4mva),1); idx(mask4mva,:) = idx0; idx(isnan(idx)) = 0;
            
            save('idx','idx','-v7.3')
            save('C','C','-v7.3')
            
            if ~isnan(optimal_numComponents)
                save('optimal_numComponents','optimal_numComponents','-v7.3')
            end
            
            
            
        case 'nntsne'
            
            [ rgbData, idx0, cmap, outputSpectralContriubtion  ] = nnTsneFull( data4mva, numComponents );
            
            idx = zeros(length(mask4mva),1); idx(mask4mva,:) = idx0; idx(isnan(idx)) = 0;
            
            save('rgbData','rgbData')
            save('idx','idx')
            save('cmap','cmap')
            save('outputSpectralContriubtion','outputSpectralContriubtion')
            
        case 'tsne'
            
            [ rgbData, idx0, cmap, loss, tsne_parameters ] = f_tsne( data4mva, numComponents );
            
            idx = zeros(length(mask4mva),1); idx(mask4mva,:) = idx0; idx(isnan(idx)) = 0;
            
            save('rgbData','rgbData')
            save('idx','idx')
            save('cmap','cmap')
            save('loss')
            save('tsne_parameters')
            
    end
    
    t = toc; disp([ '!!! ' char(mva_type) ' time elapsed: ' num2str(t) ])
    
else
    
    disp('!!! There are less than 3 mz values of interest. MVA did not run.')
    
end
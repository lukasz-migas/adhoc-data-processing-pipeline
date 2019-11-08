function f_running_mva_auxiliar( mva_type, mva_path, dataset_name, main_mask, norm_type, data4mva, mask4mva, numComponents, datacube_mzvalues_indexes )

% Creating a new folder

if strcmpi(mva_type,"pca") || strcmpi(mva_type,"nnmf") || strcmpi(mva_type,"kmeans") || (strcmpi(mva_type,"nntsne") && ~isnan(numComponents))
    
    mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\'])
    
elseif strcmpi(mva_type,"nntsne") && isnan(numComponents)
    
    mkdir([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
    cd([ mva_path char(dataset_name) '\' char(main_mask) '\' char(mva_type) '\' char(norm_type) '\'])
    
end

save('datacube_mzvalues_indexes','datacube_mzvalues_indexes','-v7.3')

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
function norm_data = f_norm_datacube( datacube, norm_type )

% Datacube normalisation using a particular mask.

% mz selection

data0 = datacube.data(logical(sum(datacube.data,2)>0),:);
data = data0(:,logical(sum(datacube.data,1)>0));

% figure; 
% subplot(2,4,1); stem(sum(datacube.data,2)); 
% subplot(2,4,2); stem(sum(datacube.data(logical(sum(datacube.data,2)>0),:),2));
% subplot(2,4,3); stem(sum(datacube.data(:,logical(sum(datacube.data,1)>0)),2));
% subplot(2,4,4); stem(sum(data,2));

% Multiple normalisation metrics

norm_data0 = 0;

switch norm_type
    
    case 'no norm' % No normalisation
        
        norm_data0 = data;
        
    case 'tic' % TIC normalisation
        
        norm_data0 = f_tic_norm(data);
        
    case 'L2 norm' % L2 normalisation
        
        norm_data0 = f_L2_norm(data); 
        
    case 'RMS' % RMS normalisation
        
        norm_data0 = f_RMS_norm(data); 
        
    case 'median' % median normalisation
        
        norm_data0 = f_median_norm(data);
        
    case 'zscore'
        
        norm_data0 = f_zscore_norm(data);
        
    case 'pqn mean'
        
        norm_data0 = crukNormalise(data,'pqn-mean');
        
    case 'pqn median'
        
        norm_data0 = crukNormalise(data,'pqn-median');
        
    case 'log' % no normalisation & log
        
        % norm_data0 = log(data+prctile(d0(:),5));
        norm_data0 = log(data+1);
        
    case 'log & pqn median'
        
        norm_data0 = crukNormalise(log(data+1),'pqn-median');
        
    case 'pqn median & log'
        
        norm_data0 = log(crukNormalise(data,'pqn-median')+1);

    case 'median norm & log' % median normalisation & log
        
        d00 = f_median_norm(data);
        d0 = d00(d00>0);
        norm_data0 = log(d00+prctile(d0(:),5));
        
    case 'pqn median & zscore'
        
        norm_data0 = zscore(crukNormalise(data,'pqn-median')')';
        
    case 'autoscaling'
        
        norm_data0 = f_msi_autoscaling_norm(data);
        
end

if norm_data0==0; disp('!!! Unknown normalisation metric. Please specify a different one.'); for i=1; break; end; end
    
norm_data = [];
norm_data(logical(sum(datacube.data,2)>0),:) = norm_data0;
norm_data(:,logical(sum(datacube.data,1)>0)) = norm_data;

% subplot(2,4,5);
% subplot(2,4,6);
% subplot(2,4,7); stem(sum(norm_data0,2));
% subplot(2,4,8); stem(sum(norm_data,2));

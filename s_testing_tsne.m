
load('X:\Beatson\dpo mva article\negative DESI\spectra details\20180305 SA1-1\tissue only\datacube.mat')
original_x = datacube.data;

load('X:\Beatson\dpo mva article\negative DESI\rois\20180305 SA1-1\tissue only\roi.mat')

mask = logical((sum(original_x,2)>0).*reshape(roi.pixelSelection',[],1));

x = original_x(mask,300:100:end);

%%

[ y, loss, tsne_parameters ] = f_tsne_with_diff_parameters( x );

norm_y = y;

for k = 1:3
    norm_y(:,k) = (y(:,k) - min(y(:,k))) ./ max(y(:,k) - min(y(:,k)));
end

if isnan(clusters_num)
    [ idx, C, ~, ~ ] = kmeans_elbow( norm_y, 30 );
else    
    [ idx, C ] = kmeans( norm_y, clusters_num, 'Distance', 'cosine' );
end

C(C<0) = 0;
C(C>1) = 1;

tsne_colomap(1,1:3) = 0;
tsne_colomap(2:max(idx)+1,:) = C;

large_idx = zeros(size(original_x,1),1);
large_idx(mask,1) = idx;


image_component = reshape(large_idx,datacube.width,datacube.height)';

rgb_image_component = zeros(size(image_component,1),size(image_component,2),size(norm_y,2));
for ci = 1:size(norm_y,2); aux_norm_y = 0*large_idx; aux_norm_y(large_idx>0) = norm_y(:,ci); rgb_image_component(:,:,ci) = reshape(aux_norm_y,datacube.width,datacube.height)'; end

figure;
subplot(2,2,[1 3])
image(rgb_image_component)
axis off; axis image; set(gca, 'fontsize', 12);
title({'t-sne space colours'})

subplot(2,2,2)
imagesc(image_component)
colormap(tsne_colomap)
axis off; axis image; colorbar; set(gca, 'fontsize', 12);
title({['t-sne space segmentation - ' num2str(numComponents)  ' clusters']})

scatter3_colour_vector = []; for cii = min(large_idx)+1:max(large_idx); scatter3_colour_vector(large_idx(large_idx>0)==cii,1:3) = repmat(tsne_colomap(cii+1,:),sum(large_idx(large_idx>0)==cii),1); end

subplot(2,2,4)
scatter3(norm_y(:,1),norm_y(:,2),norm_y(:,3),1,scatter3_colour_vector); colorbar;
title({'t-sne space'})
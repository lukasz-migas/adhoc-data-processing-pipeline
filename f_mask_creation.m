function f_mask_creation( filesToProcess, input_mask, dataset_name, mva_type, numComponents, norm_type, vector_set, regionsNumE, regionsNumI, output_mask )

% Creation of masks using the previously run mva results.

if size(filesToProcess,1) > 1; disp('Please select a unique file to create the roi!'); end

file_index = 1;

csv_inputs = [ filesToProcess(file_index).folder '\inputs_file' ];

[ ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, outputs_path ] = f_reading_inputs(csv_inputs);

% outputs_path = 'X:\Beatson\data processing outputs\positive MALDI\';

spectra_details_path    = [ char(outputs_path) '\spectra details\' ];
mva_path                = [ char(outputs_path) '\mva\' ];
rois_path               = [ char(outputs_path) '\rois\' ];

mkdir(rois_path)

% load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(input_mask) '\datacube' ])
% 
% width = datacube.width;
% height = datacube.height;
% 
% cd([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(input_mask) '\' ])
% 
% save('width','width')
% save('height','height')

load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(input_mask) '\width' ])
load([ spectra_details_path filesToProcess(file_index).name(1,1:end-6) '\' char(input_mask) '\height' ])

mva_type = char(mva_type);

switch mva_type
    
    case 'nntsne'
        
        cd([ mva_path filesToProcess(file_index).name(1,1:end-6) '\' char(input_mask) '\' char(mva_type) '\' char(norm_type) '\' char(dataset_name) '\'])
        
    case 'kmeans'
        
        cd([ mva_path filesToProcess(file_index).name(1,1:end-6) '\' char(input_mask) '\' char(mva_type) ' ' num2str(numComponents) ' components\' char(norm_type) '\' char(dataset_name) '\'])        
        
end

load('idx')

tissue_vector = 0*idx;
for clusteri = vector_set
    tissue_vector(idx == clusteri) = 1;
end

roi_mask0 = logical(reshape(tissue_vector,width,height)');

if regionsNumE > 0
    roi_mask1 = 0*roi_mask0;
else
    roi_mask1 = 1;
end

for regionsi = 1:regionsNumE
    figure(1000);
    title({'Choose Areas to Keep!'})
    roi_mask2 = roipoly(roi_mask0);
    roi_mask1 = roi_mask1 + roi_mask2;
end

roi_mask3 = 0*roi_mask0;
for regionsi = 1:regionsNumI
    figure(2000);
    title({'Choose Areas to Fill In!'})
    roi_mask4 = roipoly(roi_mask0.*roi_mask1);
    roi_mask3 = roi_mask3 + roi_mask4;
end

roi_mask = roi_mask0 .* roi_mask1 + roi_mask3;

roi = RegionOfInterest(width,height);
roi.addPixels(roi_mask)

figure(3000);
imagesc(roi.pixelSelection); axis image
colormap gray; title({'Final roi!'})

mkdir([ rois_path filesToProcess(file_index).name(1,1:end-6) '\' char(output_mask) '\'])
cd([ rois_path filesToProcess(file_index).name(1,1:end-6) '\' char(output_mask) '\'])

save('roi','roi')

if isequal(output_mask,"tissue only")
    
    new_mask = ~roi_mask;
    
    roi = RegionOfInterest(roi.width,roi.height);
    roi.addPixels(new_mask)
    
    figure(4000);
    imagesc(roi.pixelSelection); axis image
    colormap gray; title({'Final roi!'})
    
    mkdir([ rois_path filesToProcess(file_index).name(1,1:end-6) '\background\'])
    cd([ rois_path filesToProcess(file_index).name(1,1:end-6) '\background\'])
    
    save('roi','roi')

end

%         tissue_roi_test2 = tissue_roi;
%         save([ filesToProcess(file_index).folder '\tissue_roi_test2' ],'tissue_roi_test2')


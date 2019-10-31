function [ data4mva, mask4mva ] = f_data4mva_ca_comp_norm(filesToProcess, datacube_cell, main_mask_cell, smaller_masks_cell, norm_type, datacube_mzvalues_indexes )

% Data normalisation and compilation

data4mva = [];
mask4mva = [];

for file_index = 1:length(datacube_cell)
    
    if (file_index==1) || (~strcmpi(filesToProcess(file_index-1).name(1,1:end-6),filesToProcess(file_index).name(1,1:end-6)))
        
        % normalisation
        
        norm_data = f_norm_datacube_v2( datacube_cell{file_index}, main_mask_cell{file_index}, norm_type );
        
    end
    
    % compilation
    
    data4mva 	= [ data4mva;  norm_data(logical(smaller_masks_cell{file_index}.*main_mask_cell{file_index}.*(sum(norm_data(:,datacube_mzvalues_indexes),2)>0)),datacube_mzvalues_indexes)    ];
    mask4mva    = [ mask4mva;  logical(smaller_masks_cell{file_index}.*main_mask_cell{file_index}.*(sum(norm_data(:,datacube_mzvalues_indexes),2)>0))                                         ];
    
end

mask4mva = logical(mask4mva);
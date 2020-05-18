function datacube_mzvalues_indexes = f_datacube_mzvalues_lists( mva_molecules_lists_label_list, ppmTolerance, sample_info, datacubeonly_peakDetails )

% Select the mz values of the molecules that belong to the relevant lists (within a given ppm error).

mini_sample_info_mzvalues_indexes = 0;
for labeli = mva_molecules_lists_label_list
    mini_sample_info_mzvalues_indexes = mini_sample_info_mzvalues_indexes + ( strcmp(sample_info(:,7),labeli) .* logical(double(sample_info(:,5))<=ppmTolerance) );
end

mzvalues2keep1 = double(unique(sample_info(logical(mini_sample_info_mzvalues_indexes),4)));

mzvalues2keep = unique(mzvalues2keep1);

[~, datacube_mzvalues_indexes] = ismembertol(mzvalues2keep,datacubeonly_peakDetails(:,2),1e-12);

function datacube_mzvalues_indexes = f_datacube_mzvalues_classes( classes_info, classi, hmdb_sample_info, datacubeonly_peakDetails, totalSpectrum_mzvalues )

% Select the mz values of peaks that belong to a particular kingdom,
% super-class, class and/or sub-class.

indexes2keep = ones(size(hmdb_sample_info,1),1);
for i = 2:5
    if ~isnan(classes_info{classi,i}); indexes2keep = indexes2keep .* strcmpi(hmdb_sample_info(:,14+(i-2)),classes_info{classi,i}); end
end

mzvalues2keep = double(unique(hmdb_sample_info(logical(indexes2keep),4)));

datacube_mzvalues_indexes = 0;
for mzi = mzvalues2keep'
    datacube_mzvalues_indexes = datacube_mzvalues_indexes + logical(abs(datacubeonly_peakDetails(:,2)-mzi)<min(diff(totalSpectrum_mzvalues)));
end

datacube_mzvalues_indexes = logical(datacube_mzvalues_indexes);
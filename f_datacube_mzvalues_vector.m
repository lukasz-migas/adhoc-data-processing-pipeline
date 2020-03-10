function datacube_mzvalues_indexes = f_datacube_mzvalues_vector( mzvalues2keep, datacubeonly_peakDetails, totalSpectrum_mzvalues )

datacube_mzvalues_indexes = 0;
for mzi = reshape(unique(mzvalues2keep),1,[])
    datacube_mzvalues_indexes = datacube_mzvalues_indexes + logical(abs(datacubeonly_peakDetails(:,2)-mzi)<min(diff(totalSpectrum_mzvalues)));
end

datacube_mzvalues_indexes = logical(datacube_mzvalues_indexes);

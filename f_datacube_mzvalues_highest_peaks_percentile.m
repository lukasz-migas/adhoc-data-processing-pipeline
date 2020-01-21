function datacube_mzvalues_indexes = f_datacube_mzvalues_highest_peaks_percentile( perc4mva, peakDetails, datacubeonly_peakDetails, totalSpectrum_mzvalues )

% Select the mz values of the peaks that show the highest counts in the total spectrum.

if ~isempty(perc4mva)
    mzvalues2keep2 = peakDetails(logical(peakDetails(:,4)>=prctile(peakDetails(:,4),perc4mva)),2);
else
    mzvalues2keep2 = [];
end

mzvalues2keep = unique(mzvalues2keep2);

datacube_mzvalues_indexes = 0;
for mzi = mzvalues2keep'
    datacube_mzvalues_indexes = datacube_mzvalues_indexes + logical(abs(datacubeonly_peakDetails(:,2)-mzi)<min(diff(totalSpectrum_mzvalues)));
end

datacube_mzvalues_indexes = logical(datacube_mzvalues_indexes);

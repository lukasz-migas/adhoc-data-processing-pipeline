function datacube_mzvalues_indexes = f_datacube_mzvalues_highest_peaks_percentile( perc4mva, peakDetails, datacubeonly_peakDetails )

% Select the mz values of the peaks that show the highest counts in the total spectrum.

if ~isempty(perc4mva)
    mzvalues2keep2 = peakDetails(logical(peakDetails(:,4)>=prctile(peakDetails(:,4),perc4mva)),2);
else
    mzvalues2keep2 = [];
end

mzvalues2keep = unique(mzvalues2keep2);

[~, datacube_mzvalues_indexes] = ismembertol(mzvalues2keep,datacubeonly_peakDetails(:,2),1e-12);

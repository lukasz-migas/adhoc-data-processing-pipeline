function datacube_mzvalues_indexes = f_datacube_mzvalues_highest_peaks( numPeaks4mva, peakDetails, datacubeonly_peakDetails )

% Select the mz values of the peaks that show the highest counts in the total spectrum.

if ~isempty(numPeaks4mva)
    [ ~, mzvalues_highest_peaks_indexes ] = sort(peakDetails(:,4),'descend');
    mzvalues2keep2 = peakDetails(mzvalues_highest_peaks_indexes(1:numPeaks4mva,1),2);
else
    mzvalues2keep2 = [];
end

mzvalues2keep = unique(mzvalues2keep2);

[~, datacube_mzvalues_indexes] = ismembertol(mzvalues2keep,datacubeonly_peakDetails(:,2),1e-12);

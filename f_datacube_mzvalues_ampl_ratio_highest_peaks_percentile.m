function datacube_mzvalues_indexes = f_datacube_mzvalues_ampl_ratio_highest_peaks_percentile( amplratio4mva, perc4mva, peakDetails, datacubeonly_peakDetails, totalSpectrum_mzvalues, totalSpectrum_intensities )

y = totalSpectrum_intensities;

peak_amplitude_feature = zeros(size(peakDetails,1),1);
peak_mz = zeros(size(peakDetails,1),1);
peak_amplitude = zeros(size(peakDetails,1),1);

for peaki = 1:size(peakDetails,1)
    
    maxA = max(y(peakDetails(peaki,6):peakDetails(peaki,7)))-min(y(peakDetails(peaki,6)),y(peakDetails(peaki,7)));
    minA = max(y(peakDetails(peaki,6):peakDetails(peaki,7)))-max(y(peakDetails(peaki,6)),y(peakDetails(peaki,7)));
    
    peak_amplitude_feature(peaki,1) = minA./maxA*100;
    peak_mz(peaki) = peakDetails(peaki,2);
    peak_amplitude(peaki) = max(y(peakDetails(peaki,6):peakDetails(peaki,7)));
    
end

peaki2keep = logical(peak_amplitude_feature>=amplratio4mva);

smaller_peakDetails = peakDetails(peaki2keep,:);

% Select the mz values of the peaks that show the highest counts in the total spectrum.

if ~isempty(perc4mva)
    mzvalues2keep2 = smaller_peakDetails(logical(smaller_peakDetails(:,4)>=prctile(smaller_peakDetails(:,4),perc4mva)),2);
else
    mzvalues2keep2 = [];
end

mzvalues2keep = unique(mzvalues2keep2);

datacube_mzvalues_indexes = 0;
for mzi = mzvalues2keep'
    datacube_mzvalues_indexes = datacube_mzvalues_indexes + logical(abs(datacubeonly_peakDetails(:,2)-mzi)<min(diff(totalSpectrum_mzvalues)));
end

datacube_mzvalues_indexes = logical(datacube_mzvalues_indexes);

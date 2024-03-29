function datacube_mzvalues_indexes = f_datacube_mzvalues_ampl_ratio_highest_peaks( amplratio4mva, numPeaks4mva, peakDetails, datacubeonly_peakDetails, totalSpectrum_intensities )

% Select the mz values of peaks that survive the 'amplitude test' - Teresa Jan 2019.

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

if size(smaller_peakDetails,1)<numPeaks4mva
    
    disp("!!! After the amplitude ratio thresholding, there are not enought peaks to run the MVA.");
    
    mzvalues2keep2 = [];
    
else
    
    % Select the mz values of the peaks that show the highest counts in the total spectrum.
    
    if ~isempty(numPeaks4mva)
        [ ~, mzvalues_highest_peaks_indexes ] = sort(smaller_peakDetails(:,4),'descend');
        mzvalues2keep2 = smaller_peakDetails(mzvalues_highest_peaks_indexes(1:numPeaks4mva,1),2);
    else
        mzvalues2keep2 = [];
    end
    
end

mzvalues2keep = unique(mzvalues2keep2);

[~, datacube_mzvalues_indexes] = ismembertol(mzvalues2keep,datacubeonly_peakDetails(:,2),1e-12);
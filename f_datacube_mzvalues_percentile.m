function datacube_mzvalues_indexes = f_datacube_mzvalues_percentile( perc4mva, peakDetails, datacubeonly_peakDetails, y )

% Select the mz values of peaks that survive a particular 'peak test' - Teresa Oct 2019.

peak_mz = zeros(size(peakDetails,1),1);
peak_amplitude = zeros(size(peakDetails,1),1);

for peaki = 1:size(peakDetails,1)
        
    peak_mz(peaki) = peakDetails(peaki,2);
    peak_amplitude(peaki) = max(y(peakDetails(peaki,6):peakDetails(peaki,7)));
    
end

peaks2keep = logical(peak_amplitude >= prctile(peak_amplitude,perc4mva));

% Datacube indexes

[~, datacube_mzvalues_indexes] = ismembertol(mzvalues2keep,datacubeonly_peakDetails(:,2),1e-12);

disp(['!!! # unique mz selected: ' num2str(sum(peaks2keep)) ' vs # unique mz collected: ' num2str(sum(datacube_mzvalues_indexes)) ])



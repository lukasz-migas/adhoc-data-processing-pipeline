function datacube_mzvalues_indexes = f_datacube_mzvalues_percentile( perc4mva, peakDetails, datacubeonly_peakDetails, x, y )

% Select the mz values of peaks that survive a particular 'peak test' - Teresa Oct 2019.

% ppm_windown = ppmTolerance./3;

% var_vector = zeros(size(peakDetails,1),1);

peak_mz = zeros(size(peakDetails,1),1);
peak_amplitude = zeros(size(peakDetails,1),1);

for peaki = 1:size(peakDetails,1)
    
    % portion = 1;
    % peak_samples = round(ppm_windown*peakDetails(peaki,2)/(1E6*min(diff(x))));
    % peak_window_y = y((peakDetails(peaki,6)-ceil(portion*peak_samples)):(peakDetails(peaki,7)+ceil(portion*peak_samples)));
    % peak_window_y(peak_window_y>max(y(peakDetails(peaki,6):peakDetails(peaki,7)))) = NaN;
    % peak_window_y = peak_window_y(~isnan(peak_window_y));    
    % var_vector(peaki) = var((peak_window_y/max(peak_window_y))-min((peak_window_y-max(peak_window_y))));
    
    peak_mz(peaki) = peakDetails(peaki,2);
    peak_amplitude(peaki) = max(y(peakDetails(peaki,6):peakDetails(peaki,7)));
    
end

peaks2keep = logical(peak_amplitude >= prctile(peak_amplitude,perc4mva));

% Datacube indexes

mzvalues2keep = unique(peak_mz(peaks2keep));

datacube_mzvalues_indexes = 0;
for mzi = mzvalues2keep'
    datacube_mzvalues_indexes = datacube_mzvalues_indexes + logical(abs(datacubeonly_peakDetails(:,2)-mzi)<min(diff(x)));
end

datacube_mzvalues_indexes = logical(datacube_mzvalues_indexes);

disp(['!!! # unique mz selected: ' num2str(sum(peaks2keep)) ' vs # unique mz collected: ' num2str(sum(datacube_mzvalues_indexes)) ])



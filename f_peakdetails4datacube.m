function datacubeonly_peakDetails = f_peakdetails4datacube( sample_info, ppmTolerance, numPeaks4mva_array, perc4mva_array, molecules_classes_specification_path, hmdb_sample_info, peakDetails, totalSpectrum_mzvalues, totalSpectrum_intensities )

% Select the mz values of the molecules that belong to the relevant lists (within a given ppm error).

mzvalues2keep1 = double(unique(sample_info(:,4)));

% Select the mz values of the peaks that show the highest counts in the total spectrum.

if ~isempty(numPeaks4mva_array)
    [ ~, mzvalues_highest_peaks_indexes ] = sort(peakDetails(:,4),'descend');
    if max(numPeaks4mva_array)>size(peakDetails,1)
        disp('!!! ERROR !!! There are not enough peaks in the data. Please change the requested number of high intensity peaks.');
        return
    else
        mzvalues2keep2 = peakDetails(mzvalues_highest_peaks_indexes(1:max(numPeaks4mva_array),1),2);
    end
else
    mzvalues2keep2 = [];
end

% Select the mz values of peaks that survive a particular 'peak test' - Teresa Oct 2019.

x = totalSpectrum_mzvalues;
y = totalSpectrum_intensities;

ppm_windown = ppmTolerance./3;

var_vector = zeros(size(peakDetails,1),1);
peak_mz = zeros(size(peakDetails,1),1);
peak_amplitude = zeros(size(peakDetails,1),1);

for peaki = 1:size(peakDetails,1)
    
    portion = 1;
    peak_samples = round(ppm_windown*peakDetails(peaki,2)/(1E6*min(diff(x))));
    
    peak_window_y = y((peakDetails(peaki,6)-ceil(portion*peak_samples)):(peakDetails(peaki,7)+ceil(portion*peak_samples)));
    peak_window_y(peak_window_y>max(y(peakDetails(peaki,6):peakDetails(peaki,7)))) = NaN;
    
    peak_window_y = peak_window_y(~isnan(peak_window_y));
    
    var_vector(peaki) = var((peak_window_y/max(peak_window_y))-min((peak_window_y-max(peak_window_y))));
    
    peak_mz(peaki) = peakDetails(peaki,2);
    peak_amplitude(peaki) = max(y(peakDetails(peaki,6):peakDetails(peaki,7)));
    
end

peaks2keep = logical(var_vector >= prctile(var_vector,min(perc4mva_array)));

mzvalues2keep3 = peak_mz(peaks2keep);

% Select the mz values of peaks that belong to a particular kingdom,
% super-class, class and/or sub-class.

[ ~, ~, classes_info ] = xlsread(molecules_classes_specification_path);

for rowi = 2:size(classes_info,1)

    indexes2keep = 0;
    
    indexes2keep = indexes2keep + strcmpi(hmdb_sample_info(:,14),classes_info{rowi,2});
    indexes2keep = indexes2keep + strcmpi(hmdb_sample_info(:,15),classes_info{rowi,3});
    indexes2keep = indexes2keep + strcmpi(hmdb_sample_info(:,16),classes_info{rowi,4});
    indexes2keep = indexes2keep + strcmpi(hmdb_sample_info(:,17),classes_info{rowi,5});
    
end

mzvalues2keep4 = double(unique(hmdb_sample_info(logical(indexes2keep),4)));

% ! % PeakDetails indexes

mzvalues2keep = unique([ reshape(mzvalues2keep1,1,[]) reshape(mzvalues2keep2,1,[]) reshape(mzvalues2keep3,1,[]) reshape(mzvalues2keep4,1,[]) ] );

peak_details_index = 0;
for mzi = mzvalues2keep
    peak_details_index = peak_details_index + logical(abs(peakDetails(:,2)-mzi)<min(diff(totalSpectrum_mzvalues)));
end

datacubeonly_peakDetails = peakDetails(logical(peak_details_index),:);
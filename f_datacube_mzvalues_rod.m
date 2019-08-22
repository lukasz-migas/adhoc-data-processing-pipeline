function datacube_mzvalues_indexes = f_datacube_mzvalues_rod( numPeaks4mva, mva_molecules_lists_label_list, ppmTolerance, sample_info, peakDetails, datacubeonly_peakDetails )

% Peak the mz values of the molecules that belong to the relevant lists 
% (within a given error).

mini_sample_info_mzvalues_indexes = 0;
for labeli = mva_molecules_lists_label_list
    mini_sample_info_mzvalues_indexes = mini_sample_info_mzvalues_indexes + ( strcmp(sample_info(:,7),labeli) .* logical(double(sample_info(:,5))<=ppmTolerance) );
end

mzvalues2keep1 = double(unique(sample_info(logical(mini_sample_info_mzvalues_indexes),4)));

% Peak the mz values of the molecules that show the highest counts in the
% total spectrum.

if ~isempty(numPeaks4mva)
    [ ~, mzvalues_highest_peaks_indexes ] = sort(peakDetails(:,4),'descend');
    mzvalues2keep2 = peakDetails(mzvalues_highest_peaks_indexes(1:numPeaks4mva,1),2);
else
    mzvalues2keep2 = [];
end

mzvalues2keep = unique([ mzvalues2keep1; mzvalues2keep2 ]);

datacube_mzvalues_indexes = 0;
for mzi = mzvalues2keep'
    datacube_mzvalues_indexes = datacube_mzvalues_indexes + logical(abs(datacubeonly_peakDetails(:,2)-mzi)<0.0000001);
end

datacube_mzvalues_indexes = logical(datacube_mzvalues_indexes);


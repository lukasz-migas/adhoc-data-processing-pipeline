function white_datacube_mzvalues_indexes = f_black_peaks_list_removal( mzvalues2discard, datacubeonly_peakDetails, datacube_mzvalues_indexes )

% This function returns the indicies of peaks to keep in the datacube
% after discarding those specified in mzvalues2discard.

white_datacube_mzvalues_indexes = datacube_mzvalues_indexes;

[ ~, indexes2discard0 ] = ismembertol(mzvalues2discard,datacubeonly_peakDetails(:,2),1e-10);

[ ~, indexes2discard1 ] = ismembertol(indexes2discard0,white_datacube_mzvalues_indexes,0);

indexes2discard1(indexes2discard1==0) = [];

white_datacube_mzvalues_indexes(indexes2discard1) = [];


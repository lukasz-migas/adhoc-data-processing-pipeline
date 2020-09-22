function datacube_mzvalues_indexes = f_datacube_mzvalues_vector( mzvalues2keep, datacubeonly_peakDetails )

% This function returns the indicies of the m/z values of interest - 
% mzvalues2keep - in the datacube.

[~, datacube_mzvalues_indexes] = ismembertol(mzvalues2keep,datacubeonly_peakDetails(:,2),1e-12); % an m/z is considered the same when it differs less than 1e-12 from that saved in datacubeonly_peakDetails

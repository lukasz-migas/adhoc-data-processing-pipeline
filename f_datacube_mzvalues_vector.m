function datacube_mzvalues_indexes = f_datacube_mzvalues_vector( mzvalues2keep, datacubeonly_peakDetails )

[~, datacube_mzvalues_indexes] = ismembertol(mzvalues2keep,datacubeonly_peakDetails(:,2),1e-12);

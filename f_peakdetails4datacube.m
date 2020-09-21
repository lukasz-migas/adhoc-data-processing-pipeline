function datacubeonly_peakDetails = f_peakdetails4datacube( sample_info, amplratio4mva_array, numPeaks4mva_array, perc4mva_array, molecules_classes_specification_path, hmdb_sample_info, peakDetails, totalSpectrum_mzvalues, totalSpectrum_intensities )

% This function searches for all peaks of interest i.e. that will be
% required in any of the following steps of the data processing (e.g. 
% univariate or multivariate analyses, plotting of single ion images).
% In particular, this functions goes through all the available criteria for
% peak selection:
% - beloging to one of the lists of molecules of interest
% - top peaks in the total spectrum
% -- top N peaks
% -- top peaks whose intensities are part of X percentile
% - beloging to a kingdom, superclass, class or subclass of molecules

%

% Select the mz values of the molecules that belonging to the relevant lists (within a given ppm error).

mzvalues2keep1 = double(unique(sample_info(:,4)));

% Select the mz values of the peaks that show the highest counts in the total spectrum.

% Using a counts threshold.

if ~isempty(numPeaks4mva_array)
    [ ~, mzvalues_highest_peaks_indexes ] = sort(peakDetails(:,4),'descend');
    if max(numPeaks4mva_array)>size(peakDetails,1)
        disp('!!! ERROR !!! There are not enough peaks in the data. Please change the number of high intensity peaks requested.');
        return
    else
        mzvalues2keep2 = peakDetails(mzvalues_highest_peaks_indexes(1:max(numPeaks4mva_array),1),2);
    end
else
    mzvalues2keep2 = [];
end

% Using a counts percentile threshold. - Teresa Jan 2019.

if ~isempty(perc4mva_array)
    mzvalues2keep3 = peakDetails(logical(peakDetails(:,4)>=prctile(peakDetails(:,4),min(perc4mva_array))),2);
else
    mzvalues2keep3 = [];
end

% Select the mz values of peaks that survive the 'amplitude test' - Teresa Jan 2019.

if ~isempty(amplratio4mva_array)
    
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
    
    peaki2keep = logical(peak_amplitude_feature>=min(amplratio4mva_array));
    
    smaller_peakDetails = peakDetails(peaki2keep,:);
    
    if ~isempty(numPeaks4mva_array)
        [ ~, sorted_indexes ] = sort(smaller_peakDetails(:,4),'descend');
        if max(numPeaks4mva_array)>size(smaller_peakDetails,1)
            disp('!!! ERROR !!! There are not enough peaks in the data. Please change the number of high intensity peaks requested.');
            return
        else
            mzvalues2keep4 = smaller_peakDetails(sorted_indexes(1:max(numPeaks4mva_array),1),2);
        end
    else
        mzvalues2keep4 = [];
    end
    
    if ~isempty(perc4mva_array)
        mzvalues2keep5 = smaller_peakDetails(logical(smaller_peakDetails(:,4)>=prctile(smaller_peakDetails(:,4),min(perc4mva_array))),2);
    else
        mzvalues2keep5 = [];
    end
    
else
    
    mzvalues2keep4 = [];
    mzvalues2keep5 = [];
    
end

% Select the mz values of peaks that belong to a particular HMDB kingdom, super-class, class and/or sub-class.

if exist(molecules_classes_specification_path, 'file') == 2
    
    [ ~, ~, classes_info ] = xlsread(molecules_classes_specification_path);
    
    for rowi = 2:size(classes_info,1)
        
        indexes2keep = 0;
        indexes2keep = indexes2keep + strcmpi(hmdb_sample_info(:,14),classes_info{rowi,2});
        indexes2keep = indexes2keep + strcmpi(hmdb_sample_info(:,15),classes_info{rowi,3});
        indexes2keep = indexes2keep + strcmpi(hmdb_sample_info(:,16),classes_info{rowi,4});
        indexes2keep = indexes2keep + strcmpi(hmdb_sample_info(:,17),classes_info{rowi,5});
        
    end
    
    mzvalues2keep6 = double(unique(hmdb_sample_info(logical(indexes2keep),4)));
    
else
    
    mzvalues2keep6 = [];

end

% ! % Find PeakDetails indexes

mzvalues2keep = unique([mzvalues2keep1;mzvalues2keep2;mzvalues2keep3;mzvalues2keep4;mzvalues2keep5;mzvalues2keep6]);

[~, peak_details_index] = ismembertol(mzvalues2keep,peakDetails(:,2),1e-10);

datacubeonly_peakDetails = peakDetails(unique(peak_details_index),:);

if sum(diff(datacubeonly_peakDetails(:,2))==0)>1; disp('!!! There is an issue with datacubeonly_peakDetails.'); end
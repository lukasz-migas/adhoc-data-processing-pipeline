function new_hmdb_sample_info = f_saving_curated_hmdb_info( hmdb_sample_info, relevant_lists_sample_info )

% Curating the top loadings information table

% Inputs

% hmdb_sample_info (table of strings with the peak matching information for all peaks)
% relevant_lists_sample_info (table of strings with the peak matching information for peaks in the lists of interest)

% Sort by monoiso

[ ~, i1 ] = sort(double(hmdb_sample_info(:,12)),'ascend');

hmdb_sample_info1 = hmdb_sample_info(i1,:);

% Sort by measured mz

[ ~, i2 ] = sort(double(hmdb_sample_info1(:,4)),'ascend');

hmdb_sample_info2 = hmdb_sample_info1(i2,:);

log_diff = find(logical(diff(double(hmdb_sample_info2(:,12)))+diff(double(hmdb_sample_info2(:,4)))))';

i = 1;
starti = 1;
new_hmdb_sample_info = strings(length(log_diff),6);
for endi = log_diff
        
    % molecule
    
    long_string0 = unique(hmdb_sample_info2(starti:endi,1),'stable');
    long_string = reshape([long_string0 repmat(", ",size(long_string0,1),1)]',1,[]);
    new_hmdb_sample_info(i,1) = strjoin(long_string(1:end-1)); 
    
    % monoiso mz
            
    new_hmdb_sample_info(i,2) = num2str(unique(double(hmdb_sample_info2(starti:endi,12)),'stable'),'%1.12f');

    % meas mz
    
    new_hmdb_sample_info(i,3) = unique(hmdb_sample_info2(starti:endi,4),'stable');
    
    % adduct
    
    long_string0 = unique(hmdb_sample_info2(starti:endi,3),'stable');
    long_string = reshape([long_string0 repmat(", ",size(long_string0,1),1)]',1,[]);
    new_hmdb_sample_info(i,4) = strjoin(long_string(1:end-1)); 
    
    % ppm
    
    long_string0 = unique(hmdb_sample_info2(starti:endi,8),'stable');
    long_string = reshape([long_string0 repmat(", ",size(long_string0,1),1)]',1,[]);
    new_hmdb_sample_info(i,5) = strjoin(long_string(1:end-1)); 
    
    % database
        
    database_rows_mono = strcmpi(relevant_lists_sample_info(:,12),num2str(unique(double(hmdb_sample_info2(starti:endi,12)),'stable'),'%1.12f')); % Monoisotopic mass comparison
    
    long_string0 = unique(relevant_lists_sample_info(database_rows_mono,7),'stable');
    long_string = reshape([long_string0 repmat(", ",size(long_string0,1),1)]',1,[]);
    new_hmdb_sample_info(i,6) = strjoin(long_string(1:end-1)); 
    
    i = i + 1;
    starti = endi+1;

end
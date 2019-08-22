function top_loadings_info_curated_1 = f_saving_curated_top_loadings_info( table, relevant_lists_sample_info )

% Curating the top loadings information table

% Inputs

% top_loadings_info (table of strings)
% relevant_lists_sample_info (table of strings with the peak matching information)

toprow = table(1,:);
botomrows = table(2:end,:);

rows2keep = ~strcmpi(botomrows(:,8),"NA");

botomrows1 = botomrows(logical(rows2keep),:);

% Sort by monoiso

[ ~, i1 ] = sort(double(botomrows1(:,4)),'ascend');

botomrows2 = botomrows1(i1,:);

% Sort by measured mz

[ ~, i2 ] = sort(double(botomrows2(:,6)),'ascend');

botomrows3 = botomrows2(i2,:);

log_diff = find(logical(diff(double(botomrows3(:,4)))+diff(double(botomrows3(:,6)))))';

i = 1;
starti = 1;
new_botomrow = strings(length(log_diff),8);
for endi = log_diff
    
    % clusters id
       
    long_string0 = unique(botomrows3(starti:endi,1),'stable');
    long_string = reshape([long_string0 repmat(", ",size(long_string0,1),1)]',1,[]);
    new_botomrow(i,1) = strjoin(long_string(1:end-1)); 
    
    loadings_aux = string([]);
    for clusters_aux = unique(botomrows3(starti:endi,1),'stable')'
       
        rows_aux = strcmpi(clusters_aux,botomrows3(starti:endi,1));
        botomrows3_aux = botomrows3(starti:endi,2);
        loadings_aux = [ loadings_aux, ", ", unique(botomrows3_aux(rows_aux))];
        
    end
    
    % loadings id
        
    new_botomrow(i,2) = strjoin(loadings_aux(1,2:end)); 
    
    % molecule
    
    long_string0 = unique(botomrows3(starti:endi,3),'stable');
    long_string = reshape([long_string0 repmat(", ",size(long_string0,1),1)]',1,[]);
    new_botomrow(i,3) = strjoin(long_string(1:end-1)); 
    
    % monoiso mz
        
    new_botomrow(i,4) = unique(botomrows3(starti:endi,4),'stable');

    % meas mz
    
    new_botomrow(i,5) = unique(botomrows3(starti:endi,6),'stable');
    
    % adduct
    
    long_string0 = unique(botomrows3(starti:endi,7),'stable');
    long_string = reshape([long_string0 repmat(", ",size(long_string0,1),1)]',1,[]);
    new_botomrow(i,6) = strjoin(long_string(1:end-1)); 
    
    % ppm
    
    long_string0 = unique(botomrows3(starti:endi,8),'stable');
    long_string = reshape([long_string0 repmat(", ",size(long_string0,1),1)]',1,[]);
    new_botomrow(i,7) = strjoin(long_string(1:end-1)); 
    
    % database
        
    database_rows = strcmpi(relevant_lists_sample_info(:,12),unique(botomrows3(starti:endi,4),'stable'));

    long_string0 = unique(relevant_lists_sample_info(database_rows,7),'stable');
    long_string = reshape([long_string0 repmat(", ",size(long_string0,1),1)]',1,[]);
    new_botomrow(i,8) = strjoin(long_string(1:end-1)); 

    i = i + 1;
    starti = endi+1;

end

top_loadings_info_curated_1 = [
    [ toprow(1,[ 1 2 3 4 6 7 8 ]) "databases" ]
    new_botomrow
    ];
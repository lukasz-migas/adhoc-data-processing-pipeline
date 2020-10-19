function table2plot = f_mva_output_table( mva_output, data_cell )

table2plot = string(zeros(length(unique(mva_output))+1,length(data_cell)+1));
endi = 0;
for file_index = 1:length(data_cell)
    
    table2plot(1,file_index+1) = data_cell{file_index}.id;
    if file_index==1
        table2plot(1,1) = "cluster id";
        aux = string(unique(mva_output));
        table2plot(2:end-1,1) = aux(2:end);
        table2plot(end,1) = "# clusters per tissue";
    end
    
    starti = endi + 1;
    endi = starti+data_cell{file_index}.width*data_cell{file_index}.height-1;
    
    mva_output0 = mva_output(starti:endi,:); % MVAs results corresponde to all pixels in the imzml file.
    mva_output0(~data_cell{file_index}.mask) = []; % Removing all pixels with value equal to 0 (irrelavant for plotting MVAs results).
    
    for k = unique(mva_output)'
        if k>0
            if sum(mva_output0==k)>0
                table2plot(k+1,file_index+1) = string(k);
            end
        end
    end
    
end

table2plot(end,2:end) = string(sum(logical(double(table2plot(2:end,2:end))),1));

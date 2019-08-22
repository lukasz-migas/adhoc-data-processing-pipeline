function filesToProcess = f_unique_extensive_filesToProcess(extensive_filesToProcess)

string_files = string([]);
for i = 1:size(extensive_filesToProcess,1)
    string_files(i,1) = string(extensive_filesToProcess(i).name);
end

[~, ii] = unique(string_files);

filesToProcess = extensive_filesToProcess(ii);
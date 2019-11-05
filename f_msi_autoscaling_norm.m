function norm_data = f_msi_autoscaling_norm(data)

% msi_data  - [m x n] double of spectral data of m spectra and n mz values

data_nan = data;
data_nan(data==0) = NaN;

data_nan0 = data-repmat(mean(data_nan,'omitnan'),size(data,1),1);
norm_data = data_nan0./repmat(std(data_nan0,'omitnan'),size(data,1),1);
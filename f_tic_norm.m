function norm_data = f_tic_norm(data)

% msi_data  - [m x n] double of spectral data of m spectra and n mz values

norm_data = bsxfun(@rdivide, data, nansum(data,2));
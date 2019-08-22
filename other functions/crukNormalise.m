function [sp] = crukNormalise(sp,method)
%crukNormalise - methods for the normalisation of spectra.
%
% sp        - [m x n] double of spectral data of m spectra and n variables
% method    - char of normalisation method; see switch/case for values
%
% v0.1; 01/10/18; JSM

% Various methods...
switch lower(method)
    
    case {'tic'}
        [sp] = normTIC(sp);
        
    case {'pqn','pqn-mean'} % default pqn method
        [sp] = normPQN(sp,'mean');
        
    case {'pqn-median'}
        [sp] = normPQN(sp,'median');
        
    otherwise
        error('Invalid normalisation method');
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y] = normTIC(x)
% Total intensity normalisation

y = bsxfun(@rdivide,x,nansum(x,2));

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y] = normPQN(x,refType)
% PQN normalisation using the mean/median spectrum as a reference

% Mean reference spectrum
switch refType
    case 'mean'
        refSp = nanmean(x,1);
    case 'median'
        refSp = nanmedian(x,1);
end

% Fold changes relative to reference
fc = bsxfun(@rdivide,x,refSp);

% Change invalid values to NaN
fc(isinf(fc)) = NaN;
fc(fc == 0) = NaN;

% Median fold change for each spectrum, ignoring NaN values
medFC = nanmedian(fc,2);

% Divide each spectrum by its corresponding fold change
y = bsxfun(@rdivide,x,medFC);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ cl, cl_spectral_sign, Density, MinDist, centInd ] = f_LC_FDC( data, distance, perct, cut_off, isManualSelect, isAutoSelect, topK, path )
%
% LC-FDC
%
% INPUTS:
% 
% data:             a matrix where rows are pixels and columns are masses
% distance:         distance metric (e.g.: 'correlation', 'cosine')
% perct:            the percentage which determines the cut-off distance of FDC (lower values, more accuracy)
% cut_off:          the K parameter in the K-Nearest-Neighbours search (higher values, more accuracy)
% isManualSelect:   1- to sellect the clusters using a desiosion graph
%                   0- to spesify the number of cluster to find using (topK)
% topK:             the number of points chosen as cluster centres (only use with isManualSelect) (default: 10)
%
% Note: this code is an improved version of the work presented in [1].
% It improve the robusness of the algorithem by replacing dencity with local
% contrast. This also add the feature of specifying the number of top K clusters.
% which is usefull in some cases.
% [1] Alex Rodriguez & Alessandro Laio: Clustering by fast search and find of density peaks,
%       Science 344, 1492 (2014); DOI: 10.1126/science.1242072.
%
% example:
% cl = LC_FDC( test08,'correlation',0.1,500,0,20);
% cl = LC_FDC( test08,'correlation',0.1,500,1);
% output:
% cl: cluster labels

%% Compute pairwise distance between pixels

tic
DisMatrix0 = pdist2(data, data, distance); % this may be not suitable for large-scale data sets)
DisMatrix = DisMatrix0 - diag(diag(DisMatrix0)); % or squareform(dist) to set diag to 0
clear DisMatrix0
disp(['Pixel pairwise distance computation time: ' num2str(toc) ' seconds']);

%% Compute DC component

NumIns = size(DisMatrix,2);
z = ceil(perct/100*NumIns)+1;
c = zeros(1,NumIns);
for i = 1:NumIns
    a = DisMatrix(i,:);
    b = sort(a);
    c = [c b(z)];
end
dc = mean(c);

%% Compute density

Density=zeros(1,NumIns).*1.0; % row vector
for i=1:NumIns-1
    for j=i+1:NumIns
        if (DisMatrix(i,j)<dc)
            Density(i)=Density(i)+1.;
            Density(j)=Density(j)+1.;
        end
    end
end

%% Compute local contrast (LC) using K-nearest-neighbors and replace density with LC

LC=zeros(1,NumIns);
for i=1:NumIns
    [~,inx] = sort(DisMatrix(i,:));
    knn = inx(2:cut_off+1); % K-nearest-neighbors of instance i
    LC(i) = sum(Density(i) > Density(knn));
end
Density = LC;

%%

maxd=max(DisMatrix(:)); % max distance

[~,SortDensity]=sort(Density,'descend'); % SortDensity is index
MinDist(SortDensity(1))=-1.;
nneigh(SortDensity(1))=0;

for ii=2:NumIns
    MinDist(SortDensity(ii))=maxd;
    for jj=1:ii-1
        if(DisMatrix(SortDensity(ii),SortDensity(jj))<=MinDist(SortDensity(ii)))
            MinDist(SortDensity(ii))=DisMatrix(SortDensity(ii),SortDensity(jj));
            nneigh(SortDensity(ii))=SortDensity(jj); % nearest neigbour index
        end
    end
end
MinDist(SortDensity(1))=max(MinDist(:));

%% Normalise

Density=normalise(Density'); % column vector
MinDist=normalise(MinDist'); % column vector

%% Select top k

if isManualSelect==1
    [ NCLUST, centInd ] = f_decisionGraph( Density, MinDist, 1, 0, 0, path);
end

if isAutoSelect==1
    [ NCLUST, centInd ] = f_decisionGraph( Density, MinDist, 0, 1, 0, path);
end

if topK>0
    [ NCLUST, centInd ] = f_decisionGraph( Density, MinDist, 0, 0, topK, path );
end
    
disp(['Selected k: ' num2str(NCLUST)]);

cl = centInd;
cl(cl==0)=-1;

%% Assignment
for i=1:NumIns
    if (cl(SortDensity(i))==-1)
        cl(SortDensity(i))=cl(nneigh(SortDensity(i)));
    end
end
%halo
halo = zeros(1,NumIns);
for i=1:NumIns
    halo(i)=cl(i);
end
if (NCLUST>1)
    bord_rho = zeros(1,NCLUST);
    for i=1:NCLUST
        bord_rho(i)=0.;
    end
    for i=1:NumIns-1
        for j=i+1:NumIns
            if ((cl(i)~=cl(j))&& (DisMatrix(i,j)<=dc))
                Density_aver=(Density(i)+Density(j))/2.; %average density
                if (Density_aver>bord_rho(cl(i)))
                    bord_rho(cl(i))=Density_aver;
                end
                if (Density_aver>bord_rho(cl(j)))
                    bord_rho(cl(j))=Density_aver;
                end
            end
        end
    end
    for i=1:NumIns
        if (Density(i)<bord_rho(cl(i)))
            halo(i)=0;
        end
    end
end
for i=1:NCLUST
    nc=0;
    nh=0;
    for j=1:NumIns
        if (cl(j)==i)
            nc=nc+1;
        end
        if (halo(j)==i)
            nh=nh+1;
        end
    end    
end

%% Mean spectra of each cluster

cl_spectral_sign = zeros(NCLUST,size(data,2));
for k = 1:NCLUST
    cl_spectral_sign(k,:) = mean(data(cl==k,:),1);
end

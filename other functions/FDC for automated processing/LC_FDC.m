function [cl, centroidIdx] = LC_FDC( data,distance,perct,cut_off,isManualSelect,varargin)
% LC-FDC

% arguments:
% datacube: a DataInMemory object extracted from SpectralAnalysis
% distance: eg 'correlation' or 'cosine'
% perct: the percentage which determines the cut-off distance of FDC (lower values, more accuracy)
% cut_off: the K parameter in the K-Nearest-Neighbours search (higher values, more accuracy)
% isManualSelect: 1- to sellect the clusters using a desiosion graph
%                 0- to spesify the number of cluster to find using (topK)
% topK: the number of points chosen as cluster centres (only use with
%       isManualSelect) (default: 10)

% Note: this code is an improved version of the work presented in [1]. 
% It improve the robusness of the algorithem by replacing dencity with local
% contrast. This also add the feature of specifying the number of top K clusters.
% which is usefull in some cases.
% [1] Alex Rodriguez & Alessandro Laio: Clustering by fast search and find of density peaks,
%       Science 344, 1492 (2014); DOI: 10.1126/science.1242072.

% example:
% cl = LC_FDC( test08,'correlation',0.1,500,0,20);
% cl = LC_FDC( test08,'correlation',0.1,500,1);
% output:
% cl: cluster labels



%% compute Pairwise distance between pixels

tic;
    DisMatrix = pdist2(data, data,distance); % This case may be not suitable for large-scale data sets)
    out = DisMatrix - diag(diag(DisMatrix)); % or squareform(dist) to set diagnal to 0
    DisMatrix=out;
    clear out;
Comp_time_of_Pairwise_distance=toc;
% disp(['Computation time needed to compute the Pairwise distance between pixels = ' num2str(Comp_time_of_Pairwise_distance) ' seconds']);


%% compute dc component 
NumIns=size(DisMatrix,2);
%c=[];
z=ceil(perct/100*NumIns)+1;
c=zeros(1,NumIns);
for i=1:NumIns
    a=DisMatrix(i,:);
    b=sort(a);
    c=[c b(z)];
end
dc=mean(c);
%% compute Density
% for i=1:NumIns
%   Density(i)=0.;
% end
Density=zeros(1,NumIns).*1.0;
for i=1:NumIns-1
 for j=i+1:NumIns
   if (DisMatrix(i,j)<dc)
      Density(i)=Density(i)+1.;
      Density(j)=Density(j)+1.;
   end
 end
end

%% compute local contrast (LC) using K-nearest-neighbors and replace density with LC
LC = zeros(1,NumIns);
for i = 1:NumIns
    [~,inx] = sort(DisMatrix(i,:));
    knn = inx(2:cut_off+1); % K-nearest-neighbors of instance i
    LC(i) = sum(Density(i) > Density(knn));    
end
Density = LC;

%%

maxd=max(max(DisMatrix)); % max dis

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

% for i=1:NumIns
%   ind(i)=i;
%   gamma(i)=Density(i)*MinDist(i);
% end
%% normalise

    Density=normalise(Density');
    MinDist=normalise(MinDist');


%% select top k
Mult=(Density').*(MinDist');
[~,ISortMult]=sort(Mult,'descend');

if isManualSelect==1
    [topK, centroids, h] = decisionGraph( Density',MinDist', 1);
    centroidIdx = find(centroids~=0);
    close(h)
else
    if size(varargin,1)<1
        disp('you forgot to enter the number of desired clusters, the default value (10) will be used ');
        topK=10;
    else
        topK=varargin{1};
    end
end

NCLUST=topK;
disp(['Number of clusters =' num2str(NCLUST)]);

% for i=1:NumIns
%   cl(i)=-1;
% end
cl = ones(1,NumIns).*-1;
for i = 1:topK
    cl(ISortMult(i)) = i;
end

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
end



% Idx_img_FDC(mask==1)=cl; %kmeans(X,10); %
% I_FDC=Idx_img_FDC(1:125,1:125)';%(1:125,1:125)';
% 
% %cmap=hcparula(10);
% %Cmap2 = linspecer(20); 
%                                                        % to set the first colur to 0/background.
% I_FDC_RGB = ind2rgb(I_FDC+1, cmap);                                        %convert index image to RGB imagejet(10)
% h = figure(3);
% title('FDP clustering resaults');
% imshow(I_FDC_RGB);
% axis image
% axis off
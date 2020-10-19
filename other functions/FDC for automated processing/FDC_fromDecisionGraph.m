function [ cl, centroidIdx ] = FDC_fromDecisionGraph( Density, MinDist, NumIns, SortDensity, nneigh, DisMatrix, isManualSelect, dc)
% LC-FDC after creating the decision graph and selecting the parameters
%the inputs of this function are the outputs of the function
%FDC_toDecisionGraph 


% Note: this code is an improved version of the work presented in [1]. 
% It improve the robusness of the algorithem by replacing dencity with local
% contrast. This also add the feature of specifying the number of top K clusters.
% which is usefull in some cases.
% [1] Alex Rodriguez & Alessandro Laio: Clustering by fast search and find of density peaks,
%       Science 344, 1492 (2014); DOI: 10.1126/science.1242072.

% example:


%% select top k
Mult=(Density').*(MinDist');
[~,ISortMult]=sort(Mult,'descend');

    [topK, centroids, h] = decisionGraph( Density',MinDist', 1);
    centroidIdx = find(centroids~=0);
    close(h)


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


function [ ndata ] = normalise( data )
%NORMALISE Summary of this function goes here
%   Detailed explanation goes here
ndata=data;
for i=1:size(data,2)
    tdata=data(:,i);
    ndata(:,i)=(tdata-min(tdata))./(max(tdata)-min(tdata));
end

end
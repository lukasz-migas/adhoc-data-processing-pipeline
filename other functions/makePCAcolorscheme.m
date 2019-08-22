function [ colourMap ] = makePCAcolorscheme( imageData )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
 minVal = min(0, min(imageData(:)));
    maxVal = max(0, max(imageData(:)));
    
    %             scale = (maxVal - minVal) / 64;
    
    scaleSize = 256;
    zeroLoc = round((abs(minVal) / (maxVal - minVal)) * scaleSize);
    
    if(zeroLoc <= 0)
        zeroLoc = 1;
    elseif(zeroLoc >= scaleSize)
        zeroLoc = scaleSize;
    end
    
    colourMap = zeros(scaleSize, 3);
    
    for j = 1:zeroLoc
        colourMap(j, 2) = ((zeroLoc - (j - 1)) / zeroLoc);
    end
    
    for j = zeroLoc:scaleSize
        colourMap(j, [1 3]) = (j - zeroLoc) / (scaleSize - zeroLoc);
    end
    
    colourMap(zeroLoc, :) = [0 0 0];

end


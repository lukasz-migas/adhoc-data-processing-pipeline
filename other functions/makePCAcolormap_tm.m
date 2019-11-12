function colormap_values = makePCAcolormap_tm( colormap_name )

switch colormap_name
    
    case 'DarkRose-White-DarkGreen'
        
        pos_end_color   = [136, 14, 79]./255; % [ 199 21 133 ]./255;
        middle_color    = [ 255 255 255 ]./255;
        neg_end_color   = [0, 77, 64]./255; % [ 0 128 128 ]./255;
        
        r0 = [ neg_end_color(1) middle_color(1) pos_end_color(1) ];
        g0 = [ neg_end_color(2) middle_color(2) pos_end_color(2) ];
        b0 = [ neg_end_color(3) middle_color(3) pos_end_color(3) ];
        
        % interpolations
        
        pos = linspace(0,1,3);
        posDesired = linspace(0,1,1001);
        
        r = interp1(pos,r0,posDesired);
        g = interp1(pos,g0,posDesired);
        b = interp1(pos,b0,posDesired);
        
        colormap_values = [r' g' b'];
        
end
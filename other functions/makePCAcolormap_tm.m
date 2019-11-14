function colormap_values = makePCAcolormap_tm( colormap_name )

switch colormap_name
    
    case 'DarkRose-White-DarkGreen'
        
        pos_end_color   = [136, 14, 79]./255; % [ 199 21 133 ]./255;
        middle_color    = [ 255 255 255 ]./255;
        neg_end_color   = [0, 77, 64]./255; % [ 0 128 128 ]./255;
        
        r0 = [ neg_end_color(1) middle_color(1) pos_end_color(1) ];
        g0 = [ neg_end_color(2) middle_color(2) pos_end_color(2) ];
        b0 = [ neg_end_color(3) middle_color(3) pos_end_color(3) ];
        
        pos = linspace(0,1,3);

    case 'DarkRose-LightRose-White-LightGreen-DarkGreen'
        
        x = -50;
        pos_end_color   = [136+x, 14, 79+x]./255; % [ 199 21 133 ]./255;
        pos_mid_color   = [136, 14, 79]./255; % [ 199 21 133 ]./255;
        middle_color    = [ 255 255 255 ]./255;
        neg_mid_color   = [0, 77, 64]./255; % [ 0 128 128 ]./255;
        neg_end_color   = [0, 77+x, 64+x]./255; % [ 0 128 128 ]./255;
        
        r0 = [ neg_end_color(1) neg_mid_color(1) middle_color(1) pos_mid_color(1) pos_end_color(1) ];
        g0 = [ neg_end_color(2) neg_mid_color(2) middle_color(2) pos_mid_color(2) pos_end_color(2) ];
        b0 = [ neg_end_color(3) neg_mid_color(3) middle_color(3) pos_mid_color(3) pos_end_color(3) ];
        
        pos = linspace(0,1,5);
        
    case 'LightRose-DarkRose-White-DarkGreen-LightGreen'
        
        x = -50;
        pos_end_color   = [136, 14, 79]./255; % [ 199 21 133 ]./255;
        pos_mid_color   = [136+x, 14, 79+x]./255; % [ 199 21 133 ]./255;
        middle_color    = [ 255 255 255 ]./255;
        neg_mid_color   = [0, 77+x, 64+x]./255; % [ 0 128 128 ]./255;
        neg_end_color   = [0, 77, 64]./255; % [ 0 128 128 ]./255;
        
        r0 = [ neg_end_color(1) neg_mid_color(1) middle_color(1) pos_mid_color(1) pos_end_color(1) ];
        g0 = [ neg_end_color(2) neg_mid_color(2) middle_color(2) pos_mid_color(2) pos_end_color(2) ];
        b0 = [ neg_end_color(3) neg_mid_color(3) middle_color(3) pos_mid_color(3) pos_end_color(3) ];
        
        pos = linspace(0,1,5);
        
    case 'DarkRose-Blue-DarkGreen'
        
        pos_end_color   = [136, 14, 79]./255; % [ 199 21 133 ]./255;
        middle_color    = [ 255 255 20 ]./255; % [ 255 255 255 ]./255;
        neg_end_color   = [0, 77, 64]./255; % [ 0 128 128 ]./255;
        
        r0 = [ neg_end_color(1) middle_color(1) pos_end_color(1) ];
        g0 = [ neg_end_color(2) middle_color(2) pos_end_color(2) ];
        b0 = [ neg_end_color(3) middle_color(3) pos_end_color(3) ];
        
        pos = linspace(0,1,3);
        
end

% interpolations

posDesired = linspace(0,1,1001);

r = interp1(pos,r0,posDesired);
g = interp1(pos,g0,posDesired);
b = interp1(pos,b0,posDesired);

colormap_values = [r' g' b'];

end
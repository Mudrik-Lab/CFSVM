function asynchronously_generate_mondrians(obj)
    %asynchronously_generate_mondrians Asynchronously runs static make_mondrian_masks function.
    % Takes two arguments: shape and color.
    % Shape: 1 - squares, 2 - circles, 3 - diamonds
    % Color: Black(K), Gray(G), Red(R), Green(G), Blue(B), Yellow(Y),
    % Orange(O), Cyan(C), Magenta(M), White(W), Purple(P), dark+color(dColor), light+color(lColor)
    % 1 - RGBCMYKW, 2 - grayscale, 
    % 3 - R/dR/Gn/dGn/B/dB/lB/Y/dY/M/C/dC/W/K/G/dP/O
    % 4 - R/dR/B/dB/lB/M/dC/K/dP/O,
    % 5 - purples, 6 - reds, 7 - blues, 8 - professional 1, 9 - professional 2,
    % 10 - appetizing: tasty, 11 - electric, 12 - dependable 1, 
    % 13 - dependable 2, 14 - earthy ecological natural, 15 - feminine
    % See also make_mondrian_masks, parfeval.
    obj.future = parfeval(backgroundPool, @obj.make_mondrian_masks, 1, ...
                 obj.screen_x_pixels/2, obj.screen_y_pixels, ...
                 obj.masks_number, obj.mondrian_shape, obj.mondrian_color);
end

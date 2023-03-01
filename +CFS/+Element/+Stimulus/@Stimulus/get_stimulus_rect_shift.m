function [x0, y0, x1, y1, i, j] = get_stimulus_rect_shift(obj, position)
% Calculates fractional shift for every coordinate of a rectangle based on given parameters.
%
% If you define the rectangle position by the upper left and lower right 
% verticies (as the PTB does), you may see that positions with the same
% row indicies will have the same Y coordinates and those with the same
% column indicied will have the same X coordinates.
%
% Args:
%   position: Char array describing a ninth of a screen.
%
% Returns:
%   [x0, y0, x1, y1, i, j]: Array containing:
%
%   - x0: Float describing correction to the x0 coordinate.
%   - y0: Float describing correction to the y0 coordinate.
%   - x1: Float describing correction to the x1 coordinate.
%   - y1: Float describing correction to the y1 coordinate.
%   - i: Int describing row position in a position matrix.
%   - j: Int describing column position in a position matrix.

    % If size greater-or-equal to half of the screen, padding doesn't matter. 
    if obj.size >= 0.5
        obj.padding = 0;
    end
    
    % Position matrix.
    s = ["UpperLeft" "Top" "UpperRight";
        "Left" "Center" "Right";
        "LowerLeft" "Bottom" "LowerRight"];

    % Get matrix coordinates of the provided alignment.
    [i, j] = find(s == position);
    % Calculate X axis coordinates.
    [x0, x1] = coord_shift(j, obj.size, obj.padding);
    % Calculate Y axis coordinates
    [y0, y1] = coord_shift(i, obj.size, obj.padding);
end

function [coord0, coord1] = coord_shift(index, size, padding)
% Calculates actual shifts for the provided index.
    switch index
        case 1
            coord0 = (0.5-size)*padding;
            coord1 = 0.5-(0.5-size)*(1-padding);
        case 2
            coord0 = (1-size)/2;
            coord1 = (1+size)/2;
        case 3
            coord0 = 0.5+(0.5-size)*(1-padding);
            coord1 = 1-(0.5-size)*padding;
    end
end







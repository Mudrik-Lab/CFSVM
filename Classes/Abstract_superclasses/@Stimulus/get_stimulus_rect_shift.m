function [x0, y0, x1, y1, i, j] = get_stimulus_rect_shift(obj)
%get_stimulus_rect_shift Calculates fractional shift for every coordinate of a rectangle based on given parameters.
% alignment - alignment of the rectangle to the screen.
% Possible alignments are: UpperLeft, Top, UpperRight, Left, Center, Right, 
% LowerLeft, Bottom, LowerRight. 
% size - fractional size, i.e from 0 to 1, e.g. 1 will fill 100% of the provided screen.
% padding - fractional padding, i.e from 0 to 1, e.g. 1 will pad the rectangle to the center of the screen.
%
% Matrix 's' represents possible positions of rectangle on the screen, when
% divided into ninths like this:
%   |"UpperLeft"  "Top"     "UpperRight"|    |1    2    3|
%   |"Left"       "Center"  "Right"     | OR |4    5    6|
%   |"LowerLeft"  "Bottom"  "LowerRight"|    |7    8    9|
%
% Corresponding indicies of the matrix will be:
%   |1,1    1,2    1,3|
%   |2,1    2,2    2,3|
%   |3,1    3,2    3,3|
%
% If you define the rectangle position by the upper left and lower right 
% verticies (as the PTB does), you may see that positions with the same
% row indicies will have the same Y coordinates and those with the same
% column indicied will have the same X coordinates.

    % If size greater-or-equal to half of the screen, padding doesn't matter. 
    if obj.size >= 0.5
        obj.padding = 0;
    end
    
    % String array of possible alignments.
    s = ["UpperLeft" "Top" "UpperRight";
        "Left" "Center" "Right";
        "LowerLeft" "Bottom" "LowerRight"];
    % Get matrix coordinates of the provided alignment.
    [i, j] = find(s == obj.position);
    % Calculate X axis coordinates.
    [x0, x1] = coord_shift(j, obj.size, obj.padding);
    % Calculate Y axis coordinates
    [y0, y1] = coord_shift(i, obj.size, obj.padding);
end

function [coord0, coord1] = coord_shift(index, size, padding)
%coord_shift Calculates actual shifts for the provided index.
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







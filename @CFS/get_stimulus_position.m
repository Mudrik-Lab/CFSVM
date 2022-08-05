function [x0, y0, x1, y1] = get_stimulus_position(ninth, size)
%get_stimulus_position(ninth, size) The function accepts position of the 
% rectangle on screen divided into ninths. Possible positions are: 
% UpperLeft, Top, UpperRight, Left, Center, Right, LowerLeft, Bottom, 
% LowerRight. The size argument represents filling of the screen from 0 to 
% 1, e.g. 1 will fill 100% of the allocated window space.
%
% Matrix 's' represents possible positions of rectangle on the screen, when
% divided into ninths like this:
%   |"UpperLeft"  "Top"     "UpperRight"|    |1    2    3|
%   |"Left"       "Center"  "Right"     | OR |4    5    6|
%   |"LowerLeft"  "Bottom"  "LowerRight"|    |7    8    9|
% Corresponding indicies of the matrix will be:
%   |1,1    1,2    1,3|
%   |2,1    2,2    2,3|
%   |3,1    3,2    3,3|
% If you define the rectangle position by the upper left and lower right 
% verticies (as the PTB does), you may see that positions with the same
% row indicies will have the same Y coordinates and those with the same
% column indicied will have the same X coordinates, e.g. positions 1, 4 and
% 7 will have X0 (upper left vertex) coordinate equal to 0 and X1 
% (lower right vertex) coordinate equal to number_of_pixels_on_X_axis 
% (defined by screen resolution) multiplicated by size (defined by user).
% 
% Catch exceptions
    s = ["UpperLeft" "Top" "UpperRight";
        "Left" "Center" "Right";
        "LowerLeft" "Bottom" "LowerRight"];
    [i, j] = find(s == ninth);
    [x0, x1] = coord_shift(j, size);
    [y0, y1] = coord_shift(i, size);
end

function [coord0, coord1] = coord_shift(index, size)
    switch index
        case 1
            coord0 = 0;
            coord1 = size;
        case 2
            coord0 = (1-size)/2;
            coord1 = (1+size)/2;
        case 3
            coord0 = 1-size;
            coord1 = 1;
    end
end

function [x0, y0, x1, y1] = positions(ninth, size)
%POSITIONS Summary of this function goes here
%   Detailed explanation goes here
% Catch exceptions
%     switch ninth
%         case 'UpperLeft'
%             k = 1;
%             j = 1;
%         case 'Top'
%             k = 1;
%             j = 2;
%         case 'UpperRight'
%             k = 1;
%             j = 3;
%         case 'Left'
%             k = 2;
%             j = 1;
%         case 'Center'
%             k = 2;
%             j = 2;
%         case 'Right'
%             k = 2;
%             j = 3;
%         case 'LowerLeft'
%             k = 3;
%             j = 1;
%         case 'Bottom'
%             k = 3;
%             j = 2;
%         case 'LowerRight'
%             k = 3;
%             j = 3;
%     end
    s = ["UpperLeft" "Top" "UpperRight";
        "Left" "Center" "Right";
        "LowerLeft" "Bottom" "LowerRight"];
    [k, j] = find(s == ninth);
    [x0, x1] = coord_shift(j, size);
    [y0, y1] = coord_shift(k, size);
end

function [coord0, coord1] = coord_shift(position, size)
    switch position
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

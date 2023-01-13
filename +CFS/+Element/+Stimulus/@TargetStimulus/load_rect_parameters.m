function load_rect_parameters(obj, screen)
%LOAD_RECT_PARAMETERS Summary of this function goes here
%   Detailed explanation goes here
    obj.left_rect = obj.get_rect(screen.left.rect);
    obj.right_rect =  obj.get_rect(screen.right.rect);
end


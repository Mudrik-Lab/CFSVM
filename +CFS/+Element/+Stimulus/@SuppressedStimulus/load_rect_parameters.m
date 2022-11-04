function load_rect_parameters(obj, screen, is_left_suppression)
% LOAD_RECT_PARAMETERS Calculate rect coordinates on screen.

    obj.left_rect = obj.get_rect(screen.left.rect);
    obj.right_rect =  obj.get_rect(screen.right.rect);

    if is_left_suppression
        obj.rect = obj.right_rect;
    else
        obj.rect = obj.left_rect;
    end

end
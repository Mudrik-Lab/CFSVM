function load_rect_parameters(obj, screen, is_left_suppression)
% Calculates rects depending on suppression side for the trial.
%
% Args:
%   screen: :class:`~+CFS.+Element.+Screen.@CustomScreen` object.
%   is_left_suppression: bool
%

    obj.left_rect = obj.get_rect(screen.left.rect);
    obj.right_rect =  obj.get_rect(screen.right.rect);

    if is_left_suppression
        obj.rect = obj.right_rect;
    else
        obj.rect = obj.left_rect;
    end

end
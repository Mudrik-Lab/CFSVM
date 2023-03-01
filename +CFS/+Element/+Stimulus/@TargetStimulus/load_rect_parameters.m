function load_rect_parameters(obj, screen)
% Calculates rect coordinates on screen.
%
% Args:
%   screen: :class:`~+CFS.+Element.+Screen.@CustomScreen` object.
%

    obj.left_rect = obj.get_rect(screen.left.rect);
    obj.right_rect =  obj.get_rect(screen.right.rect);
end


function load_rect_parameters(obj, screen)
% Calculates rect coordinates on screen.
%
% Args:
%   screen: :class:`~+CFSVM.+Element.+Screen.@CustomScreen` object.
%

    obj.left_rect = obj.get_rect(screen.fields{1}.rect);
    obj.right_rect =  obj.get_rect(screen.fields{2}.rect);
end


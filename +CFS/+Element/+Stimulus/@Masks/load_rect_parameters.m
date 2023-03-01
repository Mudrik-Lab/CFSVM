function load_rect_parameters(obj, screen, is_left_suppression)
% Calculates rects depending on suppression side for the trial.
%
% Args:
%   screen: :class:`~+CFS.+Element.+Screen.@CustomScreen` object.
%   is_left_suppression: bool
%

    if is_left_suppression
        %obj.xy_ratio = screen.left.x_pixels/screen.left.y_pixels;
        obj.rect = obj.get_rect(screen.left.rect);
    else
        %obj.xy_ratio = screen.right.x_pixels/screen.right.y_pixels;
        obj.rect = obj.get_rect(screen.right.rect);
    end
    
end
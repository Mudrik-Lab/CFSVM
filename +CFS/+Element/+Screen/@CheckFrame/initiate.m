function initiate(obj, screenfield)
% Initiates checkframe for a screenfield by generating 
% rects and colors matrices.
%
% Args:
%   screen: :class:`~+CFS.+Element.+Screen.@ScreenField` object.

    
    screen_rect = screenfield.rect;

    % Correct screen rect for the checker width before calculating rects and colors
    screen_rect(1:2) = screenfield.rect(1:2) - obj.checker_width;
    screen_rect(3:4) = screenfield.rect(3:4) + obj.checker_width;

    [rects, colors] = obj.rects_and_colors(screen_rect);

    obj.rect = cat(2, obj.rect, rects);
    obj.color = cat(2, obj.color, colors);
    
end
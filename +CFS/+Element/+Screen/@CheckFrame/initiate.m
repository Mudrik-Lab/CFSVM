function initiate(obj, screen)
% Initiates checkframe by generating rects and colors matrices for 
% both parts of the screen.
%
% Args:
%   screen: :class:`~+CFS.+Element.+Screen.@CustomScreen` object.
    
    % Set screens rects inside the checkframe execute following experiment
    % inside them.
    if isempty(obj.color_codes)
        % Convert hex codes to matlab RGB codes.
        obj.color_codes = {screen.background_color'};
    end
    left_screen_rect = screen.left.rect;
    right_screen_rect = screen.right.rect;

    % Correct screen rect for the checker width before calculating rects and colors
    left_screen_rect(1:2) = screen.left.rect(1:2) - obj.checker_width;
    left_screen_rect(3:4) = screen.left.rect(3:4) + obj.checker_width;
    right_screen_rect(1:2) = screen.right.rect(1:2) - obj.checker_width;
    right_screen_rect(3:4) = screen.right.rect(3:4) + obj.checker_width;

    [l_rects, l_colors] = obj.rects_and_colors(left_screen_rect);
    [r_rects, r_colors] = obj.rects_and_colors(right_screen_rect);

    obj.rect = cat(2, l_rects, r_rects);
    obj.color = cat(2, l_colors, r_colors);
    
end
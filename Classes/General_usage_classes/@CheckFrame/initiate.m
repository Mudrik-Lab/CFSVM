function initiate(obj, left_screen_rect, right_screen_rect)
    %initiate Initiates checkframe by generating rects and colors
    %matrices for both halves of the screen.

    [l_rects, l_colors] = obj.rects_and_colors(left_screen_rect);
    [r_rects, r_colors] = obj.rects_and_colors(right_screen_rect);

    obj.rects = cat(2, l_rects, r_rects);
    obj.colors = cat(2, l_colors, r_colors);
end
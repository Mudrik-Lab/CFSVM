function initiate_checkerboard_frame(obj)
%initiate_checkerboard_frame Calculates checkerboard frame rectangles and colors.

    [left_screen_rects, left_screen_colors] = rects_and_colors(obj.left_side_screen, ... 
        obj.checker_rect_length, obj.checker_rect_width, obj.checker_color_codes);
    [right_screen_rects, right_screen_colors] = rects_and_colors(obj.right_side_screen, ... 
        obj.checker_rect_length, obj.checker_rect_width, obj.checker_color_codes);

    obj.checker_rects = cat(2, left_screen_rects, right_screen_rects);
    obj.checker_colors = cat(2, left_screen_colors, right_screen_colors);
end


function [checker_rects, checker_colors] = rects_and_colors(screen, checker_rect_length, checker_rect_width, checker_color_codes)
    rect_cell = num2cell(screen);
    [x0, y0, x1, y1] = rect_cell{:};

    dx = x1-x0;
    dy = y1-y0;
    % Rects  
    hor_rect_length = smallest_divisor_of_N_as_large_as_n(dx, checker_rect_length);
    vert_rect_length = smallest_divisor_of_N_as_large_as_n(dy, checker_rect_length);
    number_of_x_rects = dx/hor_rect_length;
    number_of_y_rects = dy/vert_rect_length;

    top_rects = get_frame_rects(x0, hor_rect_length, ...
        checker_rect_width, ...
        number_of_x_rects, y0, 0);
    bottom_rects = get_frame_rects(x0, hor_rect_length, ...
        checker_rect_width, number_of_x_rects, ...
        y1-checker_rect_width, 0);
    left_rects = get_frame_rects(y0, vert_rect_length, ...
        checker_rect_width, ...
        number_of_y_rects, screen(1), 1);
    right_rects = get_frame_rects(y0, vert_rect_length, ...
        checker_rect_width, number_of_y_rects, ...
        x1-checker_rect_width, 1);
    
    % Colors
    hor_rgb = zeros(3, number_of_x_rects);
    vert_rgb = zeros(3, number_of_y_rects);
    ccnum = length(checker_color_codes);
    for i = 1:ccnum
        hor_rgb(:, i:ccnum:end) = repmat(checker_color_codes{i}, 1, length(hor_rgb(:, i:ccnum:end)));
        vert_rgb(:, i:ccnum:end) = repmat(checker_color_codes{i}, 1, length(vert_rgb(:, i:ccnum:end)));
    end
    
    % Concatenate sides of the frame
    checker_rects = cat(2, top_rects, left_rects, right_rects, bottom_rects);
    checker_colors = cat(2, hor_rgb, vert_rgb, flip(vert_rgb, 2), flip(hor_rgb,2));

end

function rects = get_frame_rects(start_coord, rect_length, rect_width, number_of_rects, shift, y)
    
    main_rects = start_coord:rect_length:start_coord+rect_length*(number_of_rects-1);
    coord00=main_rects;
    coord10=zeros(1,number_of_rects) + shift;
    coord01=main_rects+rect_length;
    coord11=zeros(1,number_of_rects) + shift + rect_width;
    if y == 0
        rects = [coord00; coord10; coord01; coord11];
    else
        rects = [coord10; coord00; coord11; coord01];
    end
    
end

function divisor = smallest_divisor_of_N_as_large_as_n(N, n)
% compute the set of all integer divisors of the positive integer N
% first, get the list of prime factors of N. 
    facs = factor(N);
    divs = [1,facs(1)];
    for fi = facs(2:end)
        % if N is prime, then facs had only one element,
        % and this loop will not execute at all
        
        % this outer product will generate all combinations of
        % the divisors found so far, and the current divisor
        divs = [1;fi]*divs;
        
        % unique eliminates the replicate divisors
        divs = unique(divs(:)');

        divisor = divs(find(divs >= n,1,'first'));
    end
end
function checkerboard_frame(obj)
%CHECKERBOARD_FRAME Summary of this function goes here
%   Detailed explanation goes here
    hor_rect_length = smallest_divisor_of_N_as_large_as_n(obj.screen_x_pixels, obj.checker_rect_length);
    vert_rect_length = smallest_divisor_of_N_as_large_as_n(obj.screen_y_pixels, obj.checker_rect_length);
    number_of_x_rects = obj.screen_x_pixels/hor_rect_length;
    number_of_y_rects = obj.screen_y_pixels/vert_rect_length;

    top_rects = get_frame_rects(hor_rect_length, ...
        obj.checker_rect_width, ...
        number_of_x_rects, 0, 0);
    bottom_rects = get_frame_rects(hor_rect_length, ...
        obj.checker_rect_width, number_of_x_rects, ...
        obj.screen_y_pixels-obj.checker_rect_width, 0);
    left_rects = get_frame_rects(vert_rect_length, ...
        obj.checker_rect_width, ...
        number_of_y_rects, 0, 1);
    right_rects = get_frame_rects(vert_rect_length, ...
        obj.checker_rect_width, number_of_y_rects, ...
        obj.screen_x_pixels-obj.checker_rect_width, 1);
    left_central_rects = get_frame_rects(vert_rect_length, ...
        obj.checker_rect_width, number_of_y_rects, ...
        obj.x_center-obj.checker_rect_width, 1);
    right_central_rects = get_frame_rects(vert_rect_length, ...
        obj.checker_rect_width, number_of_y_rects, ...
        obj.x_center, 1);
    
    hor_rgb = zeros(3, number_of_x_rects);
    vert_rgb = zeros(3, number_of_y_rects);
    ccnum = length(obj.checker_color_codes);
    for i = 1:ccnum
        hor_rgb(:, i:ccnum:end) = repmat(obj.checker_color_codes{i}, 1, length(hor_rgb(:, i:ccnum:end)));
        vert_rgb(:, i:ccnum:end) = repmat(obj.checker_color_codes{i}, 1, length(vert_rgb(:, i:ccnum:end)));
    end
%     hor_rgb(:, 1:2:end) = repmat(obj.checker_color_codes{1}, 1, ceil(length(hor_rgb)/2));
%     hor_rgb(:, 2:2:end) = repmat(obj.checker_color_codes{2}, 1, floor(length(hor_rgb)/2));
%     vert_rgb = zeros(3, number_of_y_rects);
%     vert_rgb(:, 1:2:end) = repmat(obj.checker_color_codes{1}, 1, ceil(length(vert_rgb)/2));
%     vert_rgb(:, 2:2:end) = repmat(obj.checker_color_codes{2}, 1, floor(length(vert_rgb)/2));
%     horizontal_colors = mod(1:number_of_x_rects,2);
%     hor_rgb = repmat(horizontal_colors, 3, 1);
%     vertical_colors = mod(1:number_of_y_rects,2);
%     vert_rgb = repmat(vertical_colors, 3, 1);

    obj.checker_rects = cat(2, top_rects, left_rects, left_central_rects, right_central_rects, right_rects, bottom_rects);
    obj.checker_colors = cat(2, hor_rgb, vert_rgb, flip(vert_rgb, 2), vert_rgb, flip(vert_rgb, 2), flip(hor_rgb,2));
end

function rects = get_frame_rects(rect_length, rect_width, number_of_rects, shift, y)
    
    main_rects = 0:rect_length:rect_length*(number_of_rects-1);
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
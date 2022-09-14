function rect = get_rect(screen, shift, position, size, xy_ratio)
    %get_rect Calculates on-screen rectangles from stimulus and mask position/size parameters.
    % Uses static get_stimulus_poisition function, all the tech behind can
    % be find in its documentation.
    % See also get_stimulus_position

    screen_rect(1:2) = screen(1:2) + shift;
    screen_rect(3:4) = screen(3:4) - shift;
    rect_cell = num2cell(screen_rect);
    [x0, y0, x1, y1] = rect_cell{:};

    dx = x1-x0;
    dy = y1-y0;
    rem = dy-dx;
    rect = [0,0,dx*size,dx*size/xy_ratio];
    
    [m0, n0, m1, n1, i, j] = CFS.get_stimulus_position(position, size);

    x_center = mean([x0+m0*dx, x0+m1*dx]);
    y_center = mean([y0+n0*dy-(1-i)*(1-n0)*rem/2, y0+n1*dy-(3-i)*n1*rem/2]);
    
    rect = CenterRectOnPointd(rect, x_center, y_center);
end

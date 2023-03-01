function new_rectangle = get_rect(obj, screen_rectangle)
% Returns array with pixels coordinates for the new_rectangle in a
% given screen_rectangle, new_rectangle alignment, its size, padding and its X to Y ratio.
%
% Args:
%   screen_rectangle: [x0, y0, x1, y1] array with pixel positions.
%
% Returns:
%   [x0, y0, x1, y1]: resized and positioned rectangle array.
%
    

    % Extract coordinates from the provided screen rectangle.
    rect_cell = num2cell(screen_rectangle);
    [x0, y0, x1, y1] = rect_cell{:};

    % Get length of X axis in pixels.
    dx = x1-x0;
    % Get length of Y axis in pixels.
    dy = y1-y0;
    % Get remainder of subtraction between lengths of Y and X axes.
    rem = dy-dx;

    % Set rectangle with proper size and x to y ratio.
    unmoved_rect = [0,0,dx*obj.size,dx*obj.size/obj.xy_ratio];
    

    % Calculate shift from 0 to 1 of every coordinate of the new_rectangle given the provided stimulus alignment.
    [m0, n0, m1, n1, i, j] = obj.get_stimulus_rect_shift(obj.position);

    % Calculate X axis center of the new_rectangle.
    x_center = mean([x0+m0*dx, x0+m1*dx]);
    % Calculate Y axis center of the new_rectangle.
    y_center = mean([y0+n0*dy-(1-i)*(1-n0)*rem/2, y0+n1*dy-(3-i)*n1*rem/2]);
    
    % Get the new rectangle
    new_rectangle = CenterRectOnPointd(unmoved_rect, x_center, y_center);
end

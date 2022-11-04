function show(obj, screen, frame)
% SHOW Shows text version of mAFC, waits for the subject response and records it.
% 
% See also CFS.Element.Evidence.Evidence.record_response

    obj.title_size = round(screen.left.x_pixels/15);
    obj.text_size = round(obj.title_size/1.5);
    left_screen_shift = screen.left.x_pixels/obj.n_options;
    right_screen_shift = screen.right.x_pixels/obj.n_options;

    Screen('TextSize', screen.window, obj.title_size);
    text_bounds = Screen('TextBounds', screen.window, obj.title);
    title_length = text_bounds(3)-text_bounds(1);
    Screen('DrawText', screen.window, obj.title, screen.left.x_center-title_length/2, screen.left.rect(2));
    Screen('DrawText', screen.window, obj.title, screen.right.x_center-title_length/2, screen.right.rect(2));


    Screen('TextSize', screen.window, obj.text_size);
    for index = 1:obj.n_options
        Screen('DrawText', ...
            screen.window, ...
            obj.options{index}, ...
            screen.left.rect(1)+(index-(1-0.5/obj.n_options))*left_screen_shift, ...
            screen.left.y_center-obj.text_size);
        Screen('DrawText', ...
            screen.window, ...
            obj.options{index}, ...
            screen.right.rect(1)+(index-(1-0.5/obj.n_options))*right_screen_shift, ...
            screen.right.y_center-obj.text_size);
    end

    % Checkerboard frame
    Screen('FillRect', screen.window, frame.color, frame.rect);

    obj.onset = Screen('Flip', screen.window);
    
    % Wait for the response.
    obj.record_response();

end
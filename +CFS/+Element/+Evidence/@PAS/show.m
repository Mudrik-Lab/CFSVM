function show(obj, screen, frame)
%show Shows PAS screen, waits for the
% subject response and records it.
% See also record_response and append_trail_response.

    
    

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
            screen.left.rect(1), ...
            obj.left_text_start+(obj.text_size+obj.spacing)*(index-1));
        Screen('DrawText', ...
            screen.window, ... 
            obj.options{index}, ...
            screen.right.rect(1), ...
            obj.right_text_start+(obj.text_size+obj.spacing)*(index-1));
    end
    
    % Checkerboard frame
    Screen('FillRect', screen.window, frame.color, frame.rect);
    obj.onset = Screen('Flip', screen.window);
    
    % Wait for the response.
    obj.record_response()

    
end



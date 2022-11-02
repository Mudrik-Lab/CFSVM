function show(obj, screen, frame)
%show Draws and shows mAFC images, waits for the
% subject response and records it.
% See also record_response and append_trial_response.
    obj.title_size = round(screen.left.x_pixels/15);
    Screen('TextSize', screen.window, obj.title_size);
    text_bounds = Screen('TextBounds', screen.window, obj.title);
    title_length = text_bounds(3)-text_bounds(1);
    Screen('DrawText', screen.window, obj.title, screen.left.x_center-title_length/2, screen.left.rect(2));
    Screen('DrawText', screen.window, obj.title, screen.right.x_center-title_length/2, screen.right.rect(2));
    
    for i = 1:obj.n_options
        Screen('DrawTexture', screen.window, obj.options{i}, [], obj.rect{1}(i,:));
        Screen('DrawTexture', screen.window, obj.options{i}, [], obj.rect{2}(i,:));
    end

    % Checkerboard frame
    Screen('FillRect', screen.window, frame.color, frame.rect);
    obj.onset = Screen('Flip', screen.window);
    
    % Wait for the response.
    obj.record_response();

    
end

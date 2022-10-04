function perceptual_awareness_scale(obj)
%perceptual_awareness_scale Shows PAS screen, waits for the
% subject response and records it.
% See also record_response and append_trail_response.

    title_size = round(obj.screen.left.x_pixels/15);
    text_size = round(title_size/1.5);
    spacing = round(text_size/2);
    n_rows = length(obj.PAS_options);
    left_text_height = obj.screen.left.y_center-(text_size+spacing)*n_rows/2;
    right_text_height = obj.screen.right.y_center-(text_size+spacing)*n_rows/2;

    Screen('TextSize', obj.window, title_size);
    text_bounds = Screen('TextBounds', obj.window, obj.PAS_title);
    title_length = text_bounds(3)-text_bounds(1);
    Screen('DrawText', obj.window, obj.PAS_title, obj.screen.left.x_center-title_length/2, obj.screen.left.rect(2));
    Screen('DrawText', obj.window, obj.PAS_title, obj.screen.right.x_center-title_length/2, obj.screen.right.rect(2));

    Screen('TextSize', obj.window, text_size);
    for index = 1:n_rows
        Screen('DrawText', ...
            obj.window, ... 
            sprintf('%s', obj.PAS_options{index}), ...
            obj.screen.left.rect(1), ...
            left_text_height+(text_size+spacing)*(index-1));
        Screen('DrawText', ...
            obj.window, ... 
            sprintf('%s', obj.PAS_options{index}), ...
            obj.screen.right.rect(1), ...
            right_text_height+(text_size+spacing)*(index-1));
    end

    obj.results.pas_onset = Screen('Flip', obj.window);
    
    % Wait for the response.
    [obj.results.pas_kbname, obj.results.pas_response_time] = obj.record_response(obj.PAS_keys);
    obj.results.pas_response = find(strcmpi(obj.PAS_keys,obj.results.pas_kbname));
    obj.results.pas_method = 'PAS';
    obj.results.pas_kbname = string(obj.results.pas_kbname);

    
end



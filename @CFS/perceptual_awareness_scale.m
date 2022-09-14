function perceptual_awareness_scale(obj)
%perceptual_awareness_scale Shows PAS screen, waits for the
% subject response and records it.
% See also record_response and append_trail_response.
    m = obj.number_of_PAS_choices;
    left_screen_shift = (obj.left_side_screen(3)-obj.left_side_screen(1))/m;
    right_screen_shift = (obj.right_side_screen(3)-obj.right_side_screen(1))/m;
    for i = 1:m
        DrawFormattedText(obj.window, ...
            sprintf('PAS #%d', i), ...
            obj.left_side_screen(1)+(i-1)*left_screen_shift, ...
            obj.left_screen_y_center);
        DrawFormattedText(obj.window, ...
            sprintf('PAS #%d', i), ...
            obj.right_side_screen(1)+(i-1)*right_screen_shift, ...
            obj.right_screen_y_center);
    end
    
    obj.results.pas_onset = Screen('Flip', obj.window);
    
    % Wait for the response.
    [obj.results.pas_kbname, obj.results.pas_response_time] = obj.record_response(obj.PAS_keys);
    obj.results.pas_response = find(strcmpi(obj.PAS_keys,obj.results.pas_kbname))-1;
    obj.results.pas_method = 'PAS';
    obj.results.pas_kbname = string(obj.results.pas_kbname);

    
end



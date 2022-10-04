function m_alternative_forced_choice_text(obj)
%m_alternative_forced_choice_text Shows text version of mAFC.

    m = obj.number_of_mAFC_pictures;
    left_screen_shift = (obj.left_side_screen(3)-obj.left_side_screen(1))/m;
    right_screen_shift = (obj.right_side_screen(3)-obj.right_side_screen(1))/m;
    for i = 1:m
        DrawFormattedText(obj.window, ...
            sprintf('mAFC #%d', i), ...
            obj.left_side_screen(1)+(i-1)*left_screen_shift, ...
            obj.screen.left.y_center);
        DrawFormattedText(obj.window, ...
            sprintf('mAFC #%d', i), ...
            obj.right_side_screen(1)+(i-1)*right_screen_shift, ...
            obj.screen.right.y_center);
    end
    
    obj.results.afc_onset = Screen('Flip', obj.window);
    
    % Wait for the response.
    [obj.results.afc_kbname, obj.results.afc_response_time] = obj.record_response(obj.mAFC_keys);
    obj.results.afc_response = find(strcmpi(obj.mAFC_keys,obj.results.afc_kbname));
    obj.results.afc_method = sprintf('%dAFC', length(obj.mAFC_keys));
    obj.results.afc_kbname = string(obj.results.afc_kbname);
end
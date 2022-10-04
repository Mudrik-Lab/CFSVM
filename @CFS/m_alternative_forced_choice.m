function m_alternative_forced_choice(obj)
%m_alternative_forced_choice Draws and shows mAFC images, waits for the
% subject response and records it.
% See also record_response and append_trial_response.

    for i = 1:obj.number_of_mAFC_pictures
        Screen('DrawTexture', obj.window, obj.mAFC_textures{i}, [], obj.mAFC_rects{1}(i,:));
        Screen('DrawTexture', obj.window, obj.mAFC_textures{i}, [], obj.mAFC_rects{2}(i,:));
    end

    DrawFormattedText(obj.window, obj.mAFC_title, 'center');

    obj.results.afc_onset = Screen('Flip', obj.window);
    
    % Wait for the response.
    [obj.results.afc_kbname, obj.results.afc_response_time] = obj.record_response(obj.mAFC_keys);
    obj.results.afc_response = find(strcmpi(obj.mAFC_keys, obj.results.afc_kbname));
    obj.results.afc_method = sprintf('%dAFC', length(obj.mAFC_keys));
    obj.results.afc_kbname = string(obj.results.afc_kbname);

end

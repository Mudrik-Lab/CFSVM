function flash_masks_only(obj)
%FLASH_MASKS_ONLY Flashes the suppressing pattern only, without prime or target.
    
    % First iteration outside the loop in order to get the timestamp.
    Screen('DrawTexture', obj.window, obj.textures{1}, [], obj.masks_rect, 0, 1, obj.mask_contrast);
    obj.vbl = Screen('Flip', obj.window, obj.vbl + (obj.waitframe - 0.5) * obj.inter_frame_interval);

    % Save the experiment start time.
    obj.tstart = obj.vbl;
    
    % Flash the suppressing pattern only.
    for mask = 2:obj.masks_number_before_stimulus
        Screen('DrawTexture', obj.window, obj.textures{mask}, [], obj.masks_rect, 0, 1, obj.mask_contrast);
        obj.vbl = Screen('Flip', obj.window, obj.vbl + (obj.waitframe - 0.5) * obj.inter_frame_interval);
    end
end


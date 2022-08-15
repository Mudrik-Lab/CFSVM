function flash_masks_with_stimulus(obj)
%flash_masks_with_stimulus Returns to the normal flip-delay after the fade-in of the stimulus  
% until the end of the experiment.

    % After the fade-in return to the normal flip-delay until the end of the
    % experiment.
    for mask = (obj.masks_number_before_stimulus + obj.masks_number_while_fade_in + 1):obj.masks_number
        Screen('DrawTexture', obj.window, obj.stimulus, [], obj.stimulus_rect, obj.stimulus_rotation, 1, obj.stimulus_contrast);
        Screen('DrawTexture', obj.window, obj.textures{mask}, [], obj.masks_rect, 0, 1, obj.mask_contrast);
        obj.vbl = Screen('Flip', obj.window, obj.vbl + (obj.waitframe - 0.5) * obj.inter_frame_interval);
    end
    obj.vbl = Screen('Flip', obj.window, obj.vbl + (obj.waitframe - 0.5) * obj.inter_frame_interval);
end


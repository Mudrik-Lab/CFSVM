function flash(obj)
%flash Flashes the suppressing pattern and stimulus.

    % First iteration outside the loop in order to wait for the fixation 
    % cross and get the timestamp.
    Screen('DrawTexture', obj.window, obj.textures{1}, [], obj.masks_rect, 0, 1, obj.mask_contrast);
    obj.vbl = Screen('Flip', obj.window, obj.vbl + obj.fixation_cross_duration - obj.inter_frame_interval/2);

    % Save the experiment start time.
    obj.trial_start = obj.vbl;
    
    %Flash the suppressing pattern only.
    for mask = 2:obj.masks_number_before_stimulus
        Screen('DrawTexture', obj.window, obj.textures{mask}, [], obj.masks_rect, 0, 1, obj.mask_contrast);
        obj.vbl = Screen('Flip', obj.window, obj.vbl + 1/obj.temporal_frequency - obj.inter_frame_interval/2); 
    end

    % Continue flashing the suppressing pattern while changing flip delay 
    % for stimulus in order to get smooth fade-in.
    for n = 1:obj.masks_number_while_fade_in*obj.waitframe
        mask = floor(obj.masks_number_before_stimulus+n/obj.waitframe);
        Screen('DrawTexture', obj.window, obj.stimulus, [], obj.stimulus_rect, obj.stimulus_rotation, 1, obj.contrasts(n));
        Screen('DrawTexture', obj.window, obj.textures{mask}, [], obj.masks_rect, 0, 1, obj.mask_contrast);    
        obj.vbl = Screen('Flip', obj.window, obj.vbl - obj.inter_frame_interval/2); 
    end

    % After the fade-in return to the normal flip-delay until the end of the
    % experiment.
    for mask = (obj.masks_number_before_stimulus + obj.masks_number_while_fade_in + 1):obj.masks_number
        Screen('DrawTexture', obj.window, obj.stimulus, [], obj.stimulus_rect, obj.stimulus_rotation, 1, obj.stimulus_contrast);
        Screen('DrawTexture', obj.window, obj.textures{mask}, [], obj.masks_rect, 0, 1, obj.mask_contrast);
        obj.vbl = Screen('Flip', obj.window, obj.vbl + 1/obj.temporal_frequency - obj.inter_frame_interval/2);
    end
end


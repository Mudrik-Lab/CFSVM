function time_elapsed = run_the_experiment(obj)
    %run_the_experiment Flips the screen.
    %   Detailed explanation goes here
    
    target = obj.target_textures{randi(length(obj.target_textures),1)};
    
    % Initiate the experiment, flip the screen with the mask and get timestamp.
    Screen('DrawTexture', obj.window, obj.textures{1}, [], obj.masks_rect, 0, 1, obj.mask_contrast);
    vbl = Screen('Flip', obj.window);
    
    % Save the experiment start time.
    tstart = vbl;
    
    
    
    % Flash the suppressing pattern until the target starts to fade in.
    for mask = 2:obj.masks_number_before_target
        Screen('DrawTexture', obj.window, obj.textures{mask}, [], obj.masks_rect, 0, 1, obj.mask_contrast);
        vbl = Screen('Flip', obj.window, vbl + (obj.waitframe - 0.5) * obj.inter_frame_interval);
    end
    
    % Continue flashing the suppressing pattern while changing flip delay 
    % for target in order to get smooth fade-in.
    for n = 1:obj.masks_number_while_fade_in*obj.waitframe
        mask = floor(obj.masks_number_before_target+n/obj.waitframe);
        thisContrast = n/(obj.masks_number_while_fade_in*obj.waitframe)*obj.target_contrast;
        Screen('DrawTexture', obj.window, target, [], obj.target_rect, obj.target_rotation, 1, thisContrast);
        Screen('DrawTexture', obj.window, obj.textures{mask}, [], obj.masks_rect, 0, 1, obj.mask_contrast);    
        vbl = Screen('Flip', obj.window, vbl + (1 - 0.5) * obj.inter_frame_interval);
    end
    
    % After the fade-in return to the normal flip-delay until the end of the
    % experiment.
    for mask = obj.masks_number_before_target + obj.masks_number_while_fade_in + 1:obj.masks_number
        Screen('DrawTexture', obj.window, target, [], obj.target_rect, obj.target_rotation, 1, obj.target_contrast);
        Screen('DrawTexture', obj.window, obj.textures{mask}, [], obj.masks_rect, 0, 1, obj.mask_contrast);
        vbl = Screen('Flip', obj.window, vbl + (obj.waitframe - 0.5) * obj.inter_frame_interval);
    end
    vbl = Screen('Flip', obj.window, vbl + (obj.waitframe - 0.5) * obj.inter_frame_interval);
    
    % Save the experiment end time 
    tend = vbl;
    
    % Calculate the experiment duration.
    time_elapsed = tend-tstart;
end


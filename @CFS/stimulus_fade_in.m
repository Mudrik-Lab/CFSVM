function stimulus_fade_in(obj)
%STIMULUS_FADE_IN Summary of this function goes here
%   Detailed explanation goes here

    % Continue flashing the suppressing pattern while changing flip delay 
    % for stimulus in order to get smooth fade-in.
    for n = 1:obj.masks_number_while_fade_in*obj.waitframe
        mask = floor(obj.masks_number_before_stimulus+n/obj.waitframe);
        thisContrast = n/(obj.masks_number_while_fade_in*obj.waitframe)*obj.stimulus_contrast;
        Screen('DrawTexture', obj.window, obj.stimulus, [], obj.stimulus_rect, obj.stimulus_rotation, 1, thisContrast);
        Screen('DrawTexture', obj.window, obj.textures{mask}, [], obj.masks_rect, 0, 1, obj.mask_contrast);    
        obj.vbl = Screen('Flip', obj.window, obj.vbl + (1 - 0.5) * obj.inter_frame_interval);
    end

end


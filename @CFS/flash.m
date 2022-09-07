function flash(obj)
%flash Flashes mondriands and stimulus.

    mask=1;

    if obj.stimulus_appearance_delay ~= 0
        
        masks_only(obj, mask, obj.delay)
        obj.results.mondrians_onset = obj.vbl;
        for mask = 2:(obj.masks_number_before_stimulus-1)
            masks_only(obj, mask, obj.delay)
        end
        with_stimulus(obj, mask+1, 1, obj.delay)
        obj.results.stimulus_onset = obj.vbl;   
    else
        with_stimulus(obj, mask, 1, obj.delay)
        obj.results.mondrians_onset = obj.vbl;
        obj.results.stimulus_onset = obj.vbl;
    end
    
    
    
    % FADE IN
    for n = 2:(1+obj.masks_number_while_fade_in*obj.waitframe)
        with_stimulus(obj, obj.mask_in(n), n, 0)
    end
    obj.results.stimulus_full_contrast_onset = obj.vbl;
    

    % STIMULUS
    for mask = (1+obj.masks_number_before_stimulus + obj.masks_number_while_fade_in):(obj.cumul_masks_number_before_fade_out-1)
        with_stimulus(obj, mask, length(obj.contrasts), obj.delay)
    end

    
    % FADE OUT
    if obj.stimulus_fade_in_duration ~= 0
        % Stimulus
        with_stimulus(obj, obj.cumul_masks_number_before_fade_out, length(obj.contrasts)-1, obj.delay)
        obj.results.stimulus_fade_out_onset = obj.vbl;   
        
        
        for n = flip(1:(obj.masks_number_while_fade_in*obj.waitframe-1))
            with_stimulus(obj, obj.mask_out(n), n, 0)
        end
        
        masks_only(obj, mask, 0)
        obj.results.stimulus_offset = obj.vbl;
    
    else
        masks_only(obj, obj.cumul_masks_number_before_fade_out, obj.delay)
        obj.results.stimulus_fade_out_onset = obj.vbl;
        obj.results.stimulus_offset = obj.vbl;
    end
    
    % MASKS ONLY
    
    for mask = (obj.cumul_masks_number_before_fade_out+obj.masks_number_while_fade_in+1):obj.masks_number
        masks_only(obj, mask, obj.delay);
    end

    obj.vbl = Screen('Flip', obj.window, obj.vbl + 1/obj.temporal_frequency - 0.5*obj.inter_frame_interval);

end

function masks_only(obj, mask, delay)
    % Mondrian
    Screen('DrawTexture', obj.window, obj.textures{mask}, [], obj.masks_rect, 0, 1, obj.mask_contrast);
    % Left screen cross
    Screen(obj.fixation_cross_args{1}{:});
    % Right screen cross
    Screen(obj.fixation_cross_args{2}{:});
    % Flip
    obj.vbl = Screen('Flip', obj.window, obj.vbl + delay);
end

function with_stimulus(obj, mask, contrast, delay)
    % Stimulus
    Screen('DrawTexture', obj.window, obj.stimulus, [], obj.stimulus_rect, obj.stimulus_rotation, 1, obj.contrasts(contrast));
    % Mondrian
    Screen('DrawTexture', obj.window, obj.textures{mask}, [], obj.masks_rect, 0, 1, obj.mask_contrast);
    % Left screen cross
    Screen(obj.fixation_cross_args{1}{:});
    % Right screen cross
    Screen(obj.fixation_cross_args{2}{:});
    % Flip
    obj.vbl = Screen('Flip', obj.window, obj.vbl + delay);
end
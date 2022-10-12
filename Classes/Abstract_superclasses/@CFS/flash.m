function flash(obj)
%flash Flashes mondriands and stimulus.

    mask=1;

    if obj.stimulus.appearance_delay ~= 0
        
        masks_only(obj, mask, obj.masks.delay)
        obj.masks.onset = obj.vbl;
        for mask = 2:(obj.masks.n_before_stimulus-1)
            masks_only(obj, mask, obj.masks.delay)
        end
        with_stimulus(obj, mask+1, obj.stimulus.contrasts_in(1), obj.masks.delay)
        obj.stimulus.onset = obj.vbl;   
    else
        with_stimulus(obj, mask, obj.stimulus.contrasts_in(1), obj.masks.delay)
        obj.masks.onset = obj.vbl;
        obj.stimulus.onset = obj.vbl;
    end
    
    
    
    % FADE IN
    for n = 2:(1+obj.masks.n_while_fade_in*obj.masks.waitframe)
        with_stimulus(obj, obj.masks.indices_while_fade_in(n), obj.stimulus.contrasts_in(n), 0)
    end
    obj.stimulus.full_contrast_onset = obj.vbl;
    

    % STIMULUS
    for mask = (1+obj.masks.n_before_stimulus + obj.masks.n_while_fade_in):(obj.masks.n_cumul_before_fade_out-1)
        with_stimulus(obj, mask, obj.stimulus.contrasts_in(end), obj.masks.delay)
    end

    
    % FADE OUT
    if obj.stimulus.fade_out_duration ~= 0
        % Stimulus
        with_stimulus(obj, obj.masks.n_cumul_before_fade_out, obj.stimulus.contrasts_out(end-1), obj.masks.delay)
        obj.stimulus.fade_out_onset = obj.vbl;   
       
        
        for n = flip(1:(obj.masks.n_while_fade_out*obj.masks.waitframe-1))
            with_stimulus(obj, obj.masks.indices_while_fade_out(n), obj.stimulus.contrasts_out(n), 0)
        end
        
        masks_only(obj, mask, 0)
        obj.stimulus.offset = obj.vbl;
    
    else
        masks_only(obj, obj.masks.n_cumul_before_fade_out, obj.masks.delay)
        obj.stimulus.fade_out_onset = obj.vbl;
        obj.stimulus.offset = obj.vbl;
    end
    
    % MASKS ONLY
    
    for mask = (obj.masks.n_cumul_before_fade_out+obj.masks.n_while_fade_out+1):obj.masks.n
        masks_only(obj, mask, obj.masks.delay);
    end
    if (obj.masks.n - (obj.masks.n_cumul_before_fade_out+obj.masks.n_while_fade_out+1)) >= 0
        % Left screen cross
        Screen(obj.fixation.args{1}{:});
        % Right screen cross
        Screen(obj.fixation.args{2}{:});
        % Checkerboard frame
        Screen('FillRect', obj.screen.window, obj.frame.colors, obj.frame.rects);
        obj.vbl = Screen('Flip', obj.screen.window, obj.vbl + obj.masks.delay);
    end
    
    obj.masks.offset = obj.vbl;
end

function masks_only(obj, mask_index, delay)
    % Mondrian
    Screen('DrawTexture', obj.screen.window, obj.masks.textures.PTB_indices{mask_index}, [], obj.masks.rect, 0, 1, obj.masks.contrast);
    % Left screen cross
    Screen(obj.fixation.args{1}{:});
    % Right screen cross
    Screen(obj.fixation.args{2}{:});
    % Checkerboard frame
    Screen('FillRect', obj.screen.window, obj.frame.colors, obj.frame.rects);
    % Flip
    obj.vbl = Screen('Flip', obj.screen.window, obj.vbl + delay);
end

function with_stimulus(obj, mask_index, contrast, delay)
    % Stimulus
    Screen('DrawTexture', obj.screen.window, obj.stimulus.textures.index, [], obj.stimulus.rect, obj.stimulus.rotation, 1, contrast);
    % Mondrian
    Screen('DrawTexture', obj.screen.window, obj.masks.textures.PTB_indices{mask_index}, [], obj.masks.rect, 0, 1, obj.masks.contrast);
    % Left screen cross
    Screen(obj.fixation.args{1}{:});
    % Right screen cross
    Screen(obj.fixation.args{2}{:});
    % Checkerboard frame
    Screen('FillRect', obj.screen.window, obj.frame.colors, obj.frame.rects);
    % Flip
    obj.vbl = Screen('Flip', obj.screen.window, obj.vbl + delay);
end
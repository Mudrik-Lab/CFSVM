function flash(obj)
% FLASH Flashes mondriands and stimulus.
%
% Frames are being updated at display's refresh rate according to the
% parameters in every part
% (MASKS ONLY, FADE IN, STIMULUS, FADE OUT, MASKS ONLY), etc.
% Check load_flashing_parameters method to understand how these parameters 
% are being calculated.
% 
% See also CFS.Element.Stimulus.Masks.load_flashing_parameters 

    stop = 0;


    %% MASKS ONLY
    
    % If there is a delay for a stimulus - flash only masks first.
    if obj.stimulus.appearance_delay ~= 0
        % Draw first mask
        masks_only(obj, obj.masks.indices(1))
        % Flip
        obj.vbl = Screen('Flip', ...
            obj.screen.window, ...
            obj.vbl + obj.fixation.duration - 0.5*obj.screen.inter_frame_interval); %+1/obj.masks.temporal_frequency - 0.5*obj.screen.inter_frame_interval);
        % Record timing
        obj.masks.onset = obj.vbl;
        
        % Draw only masks for a duration of the stimulus delay.
        start = 1;
        stop = obj.stimulus.appearance_delay*obj.screen.frame_rate;
        for frame = (start+1):stop
            masks_only(obj, obj.masks.indices(frame))
            % Flip
            obj.vbl = Screen('Flip', obj.screen.window);
        end 
        
        % Draw first frame with stimulus
        with_stimulus(obj, ...
            obj.masks.indices(stop+1), ...
            obj.stimulus.contrasts_in(1), ...
            obj.stimulus.rotation_indices(1))
        % Flip
        obj.vbl = Screen('Flip', obj.screen.window);
        % Record timing
        obj.stimulus.onset = obj.vbl;   

    else
        % If there is no stimulus delay, then flash first frame with
        % stimulus.
        with_stimulus(obj, ...
            obj.masks.indices(1), ...
            obj.stimulus.contrasts_in(1), ...
            obj.stimulus.rotation_indices(1))
        % Flip
        obj.vbl = Screen('Flip', ...
            obj.screen.window, ...
            obj.vbl + 1/obj.masks.temporal_frequency - 0.5*obj.screen.inter_frame_interval);
        % Record timing
        obj.masks.onset = obj.vbl;
        obj.stimulus.onset = obj.vbl;
    end


    %% FADE IN

    start = stop+1;
    stop = stop+obj.stimulus.fade_in_duration*obj.screen.frame_rate;
    for frame = (start+1):stop
        with_stimulus(obj, ...
            obj.masks.indices(frame), ...
            obj.stimulus.contrasts_in(frame+1-start), ...
            obj.stimulus.rotation_indices(frame+1-start))
        % Flip
        obj.vbl = Screen('Flip', obj.screen.window);
    end
    
    

    %% STIMULUS

    % Set variable for controlling stimulus rotation.
    if obj.stimulus.fade_in_duration
        rotation_frame = frame+1-start;
    else
        rotation_frame = 0;
    end

    start = stop+1;
    stop = stop+obj.stimulus.show_duration*obj.screen.frame_rate;

    if obj.stimulus.fade_in_duration ~= 0
        with_stimulus(obj, ...
                obj.masks.indices(start), ...
                obj.stimulus.contrasts_in(end), ...
                obj.stimulus.rotation_indices(rotation_frame+1))
        % Flip
        obj.vbl = Screen('Flip', obj.screen.window);
    end
    obj.stimulus.full_contrast_onset = obj.vbl;

    for frame = (start+1):stop
        with_stimulus(obj, ...
            obj.masks.indices(frame), ...
            obj.stimulus.contrasts_in(end), ...
            obj.stimulus.rotation_indices(rotation_frame+frame+1-start))
        % Flip
        obj.vbl = Screen('Flip', obj.screen.window);
    end
    

    %% FADE OUT

    rotation_frame = rotation_frame+frame+1-start;
    start = stop+1;
    stop = stop+obj.stimulus.fade_out_duration*obj.screen.frame_rate;

    if obj.stimulus.fade_out_duration

        with_stimulus(obj, ...
                obj.masks.indices(start), ...
                obj.stimulus.contrasts_out(stop+1-start), ...
                obj.stimulus.rotation_indices(rotation_frame+1))
        % Flip
        obj.vbl = Screen('Flip', obj.screen.window);
        % Record timing
        obj.stimulus.fade_out_onset = obj.vbl;

        for frame = (start+1):stop
            with_stimulus(obj, ...
                obj.masks.indices(frame), ...
                obj.stimulus.contrasts_out(stop+1-frame), ...
                obj.stimulus.rotation_indices(rotation_frame+frame+1-start))
            % Flip
            obj.vbl = Screen('Flip', obj.screen.window);
        end

        masks_only(obj, obj.masks.indices(stop+1))
        % Flip
        obj.vbl = Screen('Flip', obj.screen.window);
        % Record timing
        obj.stimulus.offset = obj.vbl;
    else
        masks_only(obj, obj.masks.indices(stop+1))
        % Flip
        obj.vbl = Screen('Flip', obj.screen.window);
        % Record timing
        obj.stimulus.fade_out_onset = obj.vbl;
        obj.stimulus.offset = obj.vbl;
    end


    %% MASKS ONLY
    start = stop+1;
    stop = (obj.masks.duration)*obj.screen.frame_rate+1;
    for frame = (start+1):stop
        masks_only(obj, obj.masks.indices(frame))
        % Flip
        obj.vbl = Screen('Flip', obj.screen.window);
    end
    obj.masks.offset = obj.vbl;


end


function masks_only(obj, mask_index)

    % Mondrian
    Screen('DrawTexture', ...
        obj.screen.window, ...
        obj.masks.textures.PTB_indices{mask_index}, ...
        [], ...
        obj.masks.rect, ...
        0, ...
        1, ...
        obj.masks.contrast);
    % Left screen cross
    Screen(obj.fixation.args{1}{:});
    % Right screen cross
    Screen(obj.fixation.args{2}{:});
    % Checkerboard frame
    Screen('FillRect', obj.screen.window, obj.frame.color, obj.frame.rect);

end

function with_stimulus(obj, mask_index, contrast, rot_index)

    % Stimulus
    Screen('DrawTexture', ...
        obj.screen.window, ...
        obj.stimulus.textures.index, ...
        [], ...
        obj.stimulus.rect, ...
        obj.stimulus.rotation_array(rot_index), ...
        1, ...
        contrast);
    % Mondrian
    Screen('DrawTexture', ...
        obj.screen.window, ...
        obj.masks.textures.PTB_indices{mask_index}, ...
        [], ...
        obj.masks.rect, ...
        0, ...
        1, ...
        obj.masks.contrast);
    % Left screen cross
    Screen(obj.fixation.args{1}{:});
    % Right screen cross
    Screen(obj.fixation.args{2}{:});
    % Checkerboard frame
    Screen('FillRect', obj.screen.window, obj.frame.color, obj.frame.rect);

end
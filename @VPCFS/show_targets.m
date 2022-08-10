function show_targets(obj)
%SHOW_TARGETS Summary of this function goes here
%   Detailed explanation goes here

    % If multiple target images - randomise.
    target = obj.target_textures{randi(length(obj.target_textures),1)};

    Screen('DrawTexture', obj.window, target, [], obj.stimulus_rect, 0, 1, obj.stimulus_contrast);

    Screen('DrawTexture', obj.window, target, [], obj.masks_rect, 0, 1, obj.stimulus_contrast);
    
    obj.vbl = Screen('Flip', obj.window);

    WaitSecs(obj.target_presentation_duration);
end


function show(obj, experiment)
% SHOW Presents target for the provided duration.

    target = obj.textures.PTB_indices{obj.index};
    obj.image_name = obj.textures.images_names(obj.index);
    
    Screen('DrawTexture', experiment.screen.window, target, [], ...
        obj.left_rect, 0, 1, obj.contrast);

    Screen('DrawTexture', experiment.screen.window, target, [], ...
        obj.right_rect, 0, 1, obj.contrast);
    
    % Left screen cross
    Screen(experiment.fixation.args{1}{:});
    % Right screen cross
    Screen(experiment.fixation.args{2}{:});
    % Checkerboard frame
    Screen('FillRect', experiment.screen.window, experiment.frame.color, experiment.frame.rect);
    
    obj.onset = Screen('Flip', experiment.screen.window);
    
    WaitSecs(obj.duration);
    obj.offset = GetSecs();
    
end

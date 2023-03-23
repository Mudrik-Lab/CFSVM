function show(obj, experiment)
% Presents target for the provided duration.
%
% Args:
%   experiment: An experiment object.
%

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
    Screen('FillRect', experiment.screen.window, experiment.frame.colors, experiment.frame.rects);
    
    obj.onset = Screen('Flip', experiment.screen.window);
    
    WaitSecs(obj.duration);
    obj.offset = GetSecs();
    
end

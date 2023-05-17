function show_info(obj, type)
% Flips screen to the info, e.g., introduction, farewell etc.
%
    p = fullfile(obj.path_to_functions, sprintf('%s.m', type));
    if ~isfile(p)
        error('Info function with the name %s.m was not found in the provided path', type)
    end
    [directory, func_name, ~] = fileparts(p);
    old_dir = pwd;
    cd(directory);
    handle_func = str2func(func_name);
    cd(old_dir);

    for n = 1:length(obj.screen.fields)
        key = handle_func(obj.screen.window, obj.screen.fields{n}.rect);
    end
    
    if isa(obj, "CFSVM.Experiment.CFS")
        % Checkerboard frame
        Screen('FillRect', obj.screen.window, obj.frame.colors, obj.frame.rects);
    end
    Screen('Flip', obj.screen.window);
    
    % Wait until the right key is pressed, then continue.
    obj.wait_for_keypress(key, func_name);
    
end


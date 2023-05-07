function show(obj, experiment)
% Shows PAS screen, waits for the subject response and records it.
% 
% See also :func:`~CFSVM.Element.Evidence.record_response`.
%
% Args:
%   experiment: An experiment object.
%

    screen = experiment.screen;
    PADDING = 10;
    Screen('TextSize', screen.window, obj.title_size);
    text_bounds = Screen('TextBounds', screen.window, obj.title);
    title_length = text_bounds(3)-text_bounds(1);
    Screen('DrawText', ...
        screen.window, ...
        obj.title, ...
        screen.fields{1}.x_center-title_length/2, ...
        screen.fields{1}.rect(2)+PADDING);
    
    if length(screen.fields) > 1
        Screen('DrawText', ...
            screen.window, ...
            obj.title, ...
            screen.fields{2}.x_center-title_length/2, ...
            screen.fields{2}.rect(2)+PADDING);
    end

    Screen('TextSize', screen.window, obj.text_size);
    for index = 1:obj.n_options
        Screen('DrawText', ...
            screen.window, ... 
            obj.options{index}, ...
            screen.fields{1}.rect(1)+PADDING, ...
            obj.left_text_start+(obj.text_size+obj.spacing)*(index-1));
        
        if length(screen.fields) > 1
            Screen('DrawText', ...
                screen.window, ... 
                obj.options{index}, ...
                screen.fields{2}.rect(1)+PADDING, ...
                obj.right_text_start+(obj.text_size+obj.spacing)*(index-1));
        end
    end
    
    if isa(experiment, "CFSVM.Experiment.CFS")
        % Checkerboard frame
        Screen('FillRect', screen.window, experiment.frame.colors, experiment.frame.rects);
    end
    obj.onset = Screen('Flip', screen.window);
    
    % Wait for the response.
    obj.record_response()
    obj.response_choice = obj.response_choice - 1;
  
end



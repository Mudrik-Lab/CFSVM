function show(obj, experiment)
% Draws and shows mAFC images, waits for the subject response and records it.
% 
% See also :func:`~CFSVM.Element.Evidence.record_response`.
%
% Args:
%   experiment: An experiment object.
%

    screen = experiment.screen;
    PADDING=10;
    obj.title_size = round(screen.fields{1}.x_pixels/15);
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
    
    for i = 1:obj.n_options
        Screen('DrawTexture', screen.window, obj.options{i}, [], obj.rects{1}(i,:));
        if length(screen.fields) > 1
            Screen('DrawTexture', screen.window, obj.options{i}, [], obj.rects{2}(i,:));
        end
    end

    if isa(experiment, "CFSVM.Experiment.CFS")
        % Checkerboard frame
        Screen('FillRect', screen.window, experiment.frame.colors, experiment.frame.rects);
    end
    obj.onset = Screen('Flip', screen.window);
    
    % Wait for the response.
    obj.record_response();

    
end

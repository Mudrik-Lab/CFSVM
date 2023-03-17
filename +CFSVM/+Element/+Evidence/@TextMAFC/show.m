function show(obj, experiment)
% Shows text version of mAFC, waits for the subject response and records it.
% 
% See also :func:`~+CFSVM.+Element.+Evidence.@ScaleEvidence.record_response`.
%
% Args:
%   experiment: An experiment object.
%
    
    screen = experiment.screen;
    PADDING = 10;
    obj.title_size = round(screen.fields{1}.x_pixels/15);
    obj.text_size = round(obj.title_size/1.5);
    left_screen_shift = screen.fields{1}.x_pixels/obj.n_options;
    right_screen_shift = screen.fields{2}.x_pixels/obj.n_options;

    Screen('TextSize', screen.window, obj.title_size);
    text_bounds = Screen('TextBounds', screen.window, obj.title);
    title_length = text_bounds(3)-text_bounds(1);
    Screen('DrawText', ...
        screen.window, ...
        obj.title, ...
        screen.fields{1}.x_center-title_length/2, ...
        screen.fields{1}.rect(2)+PADDING);
    Screen('DrawText', ...
        screen.window, ...
        obj.title, ...
        screen.fields{2}.x_center-title_length/2, ...
        screen.fields{2}.rect(2)+PADDING);


    Screen('TextSize', screen.window, obj.text_size);
    for index = 1:obj.n_options
        Screen('DrawText', ...
            screen.window, ...
            obj.options{index}, ...
            screen.fields{1}.rect(1)+(index-(1-0.5/obj.n_options))*left_screen_shift, ...
            screen.fields{1}.y_center-obj.text_size);
        Screen('DrawText', ...
            screen.window, ...
            obj.options{index}, ...
            screen.fields{2}.rect(1)+(index-(1-0.5/obj.n_options))*right_screen_shift, ...
            screen.fields{2}.y_center-obj.text_size);
    end

    if isa(experiment, "CFSVM.Experiment.CFS")
        % Checkerboard frame
        Screen('FillRect', screen.window, experiment.frame.color, experiment.frame.rect);
    end

    obj.onset = Screen('Flip', screen.window);
    
    % Wait for the response.
    obj.record_response();

end
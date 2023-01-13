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
    
    draw(obj, 1)
    obj.vbl = Screen(...
        'Flip', ...
        obj.screen.window, ...
        obj.vbl + obj.fixation.duration - 0.5*obj.screen.inter_frame_interval);
    obj.vbl_recs(1) = obj.vbl;

    for fr = 2:(obj.masks.duration*obj.screen.frame_rate)
        draw(obj, fr)
        obj.vbl = Screen('Flip', obj.screen.window);
        obj.vbl_recs(fr) = obj.vbl;
    end
    
    draw(obj, fr)
    obj.vbl = Screen('Flip', obj.screen.window);
    obj.vbl_recs(end+1) = obj.vbl;
end


function draw(obj, fr)
    % Stimuli and Mondrians
    Screen(obj.masks.args{fr}{:});
    % Left screen cross
    Screen(obj.fixation.args{1}{:});
    % Right screen cross
    Screen(obj.fixation.args{2}{:});
    % Checkerboard frame
    Screen('FillRect', obj.screen.window, obj.frame.color, obj.frame.rect);
    
end
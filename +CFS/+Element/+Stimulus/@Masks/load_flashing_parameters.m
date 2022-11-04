function load_flashing_parameters(obj, screen, stimulus)
% LOAD_FLASHING_PARAMETERS Calculates parameters for flashing for the
% current trial.

    obj.waitframe = Screen('NominalFrameRate', screen.window)/obj.temporal_frequency;
    
    obj.delay=1/obj.temporal_frequency - 0.5*screen.inter_frame_interval;

    obj.n = obj.temporal_frequency*obj.duration;

    obj.n_before_stimulus = ...
        obj.temporal_frequency*stimulus.appearance_delay+1;

    obj.n_while_fade_in = ...
        obj.temporal_frequency*stimulus.fade_in_duration;

    obj.n_while_stimulus = ...
        obj.temporal_frequency*stimulus.show_duration;

    obj.n_while_fade_out = ...
        obj.temporal_frequency*stimulus.fade_out_duration;

    obj.n_cumul_before_fade_out = ... 
        obj.n_while_stimulus + ...
        obj.n_while_fade_in + ...
        obj.n_before_stimulus;

    obj.indices_while_fade_in = arrayfun(@(n) (floor(obj.n_before_stimulus+(n-1)/obj.waitframe)), ...
        1:(1+obj.n_while_fade_in*obj.waitframe));

    obj.indices_while_fade_out = arrayfun(@(n) (floor(obj.n_cumul_before_fade_out+...
        (obj.n_while_fade_out*obj.waitframe-n)/obj.waitframe)), ...
        1:(obj.n_while_fade_out*obj.waitframe-1));

end